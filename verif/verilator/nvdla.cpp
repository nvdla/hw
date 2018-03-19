/* nvdla.cpp
 * Driver for Verilator testbench
 * NVDLA Open Source Project
 *
 * Copyright (c) 2017 NVIDIA Corporation.  Licensed under the NVDLA Open
 * Hardware License.  For more information, see the "LICENSE" file that came
 * with this distribution.
 */

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>

#include <queue>
#include <map>
#include <vector>

#include "verilated.h"

#include "VNV_nvdla.h"

#include "../spec/defs/project.h"

#ifndef NVDLA_MEM_ADDRESS_WIDTH
#define NVDLA_MEM_ADDRESS_WIDTH 64
#endif

#if VM_TRACE
#include <verilated_vcd_c.h>
VerilatedVcdC* tfp;

void _close_trace() {
	if (tfp) tfp->close();
}
#endif

uint64_t ticks = 0;

double sc_time_stamp() {
	return (double) ticks;
}

class CSBMaster {
	enum why {
		FROM_TRACE,
		IS_MASK,
		IS_STATUS
	};

	struct csb_op {
		int is_ext;
		int write;
		int tries;
		int reading;
		enum why why;
		uint32_t addr;
		uint32_t mask;
		uint32_t data;
	};
	
	std::queue<csb_op> opq;
	
	VNV_nvdla *dla;
	
	int _test_passed;
	int quiet;
	
	/* It's kind of gross that we have to have this here -- an otherwise
	 * pure class that doesn't know much about NVDLA internals -- but oh
	 * well. */
	uint32_t intr_status_reg;
	uint32_t intr_mask_reg;
	
	uint32_t last_mask, last_status;
	
	/* Maps from outstanding syncpoint IDs to interrupt masks. */
	std::map<uint32_t, uint32_t> syncpts;
	
public:
	CSBMaster(VNV_nvdla *_dla) {
		dla = _dla;
		
		dla->csb2nvdla_valid = 0;
		_test_passed = 1;
		quiet = 0;
	}

	void read(uint32_t addr, uint32_t mask, uint32_t data, enum why why = FROM_TRACE) {
		csb_op op;
	
		op.is_ext = 0;
		op.write = 0;
		op.why = why;
		op.addr = addr;
		op.mask = mask;
		op.data = data;
		op.tries = 10;
		op.reading = 0;
	
		opq.push(op);
	}
	
	void write(uint32_t addr, uint32_t data) {
		csb_op op;
	
		op.is_ext = 0;
		op.write = 1;
		op.why = FROM_TRACE;
		op.addr = addr;
		op.data = data;
	
		opq.push(op);
	}
	
	void ext_event(int ext) {
		csb_op op;
		
		op.is_ext = ext;
		opq.push(op);
	}
	
	int eval(int noop) {
		if (dla->nvdla2csb_wr_complete)
			if (!quiet) printf("(%lu) write complete from CSB\n", ticks);
		
		dla->csb2nvdla_valid = 0;
		if (opq.empty() && syncpts.empty())
			return 0;
		if (opq.empty() && !syncpts.empty()) {
			/* Perhaps we need to synthesize some mask reads and interrupt reads? */
			if (!quiet) printf("(%lu) CSB switching to interrupt polling\n", ticks);
			quiet = 1;
			read(intr_mask_reg, 0, 0, IS_MASK);
			read(intr_status_reg, 0, 0, IS_STATUS);
		}

		csb_op &op = opq.front();
		
		if (op.is_ext && !noop) {
			int ext = op.is_ext;
			opq.pop();
			
			return ext;
		}
		
		if (!op.write && op.reading && dla->nvdla2csb_valid) {
			if (!quiet) printf("(%lu) read response from nvdla: %08x\n", ticks, dla->nvdla2csb_data);
			
			if (op.why == IS_MASK) {
				last_mask = dla->nvdla2csb_data;
				opq.pop();
			} else if (op.why == IS_STATUS) {
				last_status = dla->nvdla2csb_data;
				opq.pop();
				
				uint32_t status = ~last_mask & last_status;
				for (std::map<uint32_t, uint32_t>::iterator it = syncpts.begin();
				     it != syncpts.end(); it++) {
					if ((status & it->second) != it->second)
						continue;
					
					printf("(%lu) syncpt %08x\n", ticks, it->first);
					write(intr_status_reg, it->second);
					syncpts.erase(it);
					
					return it->first;
				}
			} else if ((dla->nvdla2csb_data & op.mask) != (op.data & op.mask)) {
				op.reading = 0;
				op.tries--;
				if (!quiet) printf("(%lu) invalid response -- trying again\n", ticks);
				if (!op.tries) {
					if (!quiet) printf("(%lu) ERROR: timed out reading response\n", ticks);
					_test_passed = 0;
					opq.pop();
				}
			} else
				opq.pop();
		}
		
		if (!op.write && op.reading)
			return 0;
		
		if (noop)
			return 0;
		
		if (!dla->csb2nvdla_ready) {
			if (!quiet) printf("(%lu) CSB stalled...\n", ticks);
			return 0;
		}
		
		if (op.write) {
			dla->csb2nvdla_valid = 1;
			dla->csb2nvdla_addr = op.addr;
			dla->csb2nvdla_wdat = op.data;
			dla->csb2nvdla_write = 1;
			dla->csb2nvdla_nposted = 0;
			if (!quiet) printf("(%lu) write to nvdla: addr %08x, data %08x\n", ticks, op.addr, op.data);
			opq.pop();
		} else {
			dla->csb2nvdla_valid = 1;
			dla->csb2nvdla_addr = op.addr;
			dla->csb2nvdla_write = 0;
			if (!quiet) printf("(%lu) read from nvdla: addr %08x\n", ticks, op.addr);
			
			op.reading = 1;
		}
		
		return 0;
	}
	
	bool done() {
		return opq.empty() && syncpts.empty();
	}
	
	int test_passed() {
		return _test_passed;
	}
	
	void set_intr_registers(uint32_t status, uint32_t mask) {
		intr_status_reg = status;
		intr_mask_reg = mask;
	}
	
	void register_syncpt(uint32_t syncpt, uint32_t mask) {
		syncpts[syncpt] = mask;
	}
};

class AXIResponder {
public:
#if NVDLA_PRIMARY_MEMIF_WIDTH == 64
#	define AXI_WDATA_TYPE uint64_t
#	define AXI_WDATA_TYLEN 64
#	define AXI_WDATA_MKPTR &
#	define AXI_WSTRB_TYPE uint8_t
#elif NVDLA_PRIMARY_MEMIF_WIDTH == 512
#	define AXI_WDATA_TYPE uint32_t
#	define AXI_WDATA_TYLEN 32
#	define AXI_WDATA_MKPTR
#	define AXI_WSTRB_TYPE uint64_t
#else
#	error unsupported NVDLA_PRIMARY_MEMIF_WIDTH
#endif

#if NVDLA_MEM_ADDRESS_WIDTH == 32
#	define AXI_ADDR_TYPE uint32_t
#elif NVDLA_MEM_ADDRESS_WIDTH == 64
#	define AXI_ADDR_TYPE uint64_t
#else
#	error unsupported NVDLA_MEM_ADDRESS_WIDTH
#endif

#define AXI_WIDTH NVDLA_PRIMARY_MEMIF_WIDTH

	struct connections {
		uint8_t *aw_awvalid;
		uint8_t *aw_awready;
		uint8_t *aw_awid;
		uint8_t *aw_awlen;
		AXI_ADDR_TYPE *aw_awaddr;
		
		uint8_t *w_wvalid;
		uint8_t *w_wready;
		AXI_WDATA_TYPE *w_wdata;
		AXI_WSTRB_TYPE *w_wstrb;
		uint8_t *w_wlast;
		
		uint8_t *b_bvalid;
		uint8_t *b_bready;
		uint8_t *b_bid;
		
		uint8_t *ar_arvalid;
		uint8_t *ar_arready;
		uint8_t *ar_arid;
		uint8_t *ar_arlen;
		AXI_ADDR_TYPE *ar_araddr;
		
		uint8_t *r_rvalid;
		uint8_t *r_rready;
		uint8_t *r_rid;
		uint8_t *r_rlast;
		AXI_WDATA_TYPE *r_rdata;
	};

private:

#define AXI_BLOCK_SIZE 4096

	const static int AXI_R_LATENCY = 32;
	const static int AXI_R_DELAY = 0;

	struct axi_r_txn {
		int rvalid;
		int rlast;
		AXI_WDATA_TYPE rdata[AXI_WIDTH / AXI_WDATA_TYLEN];
		uint8_t rid;
	};
	std::queue<axi_r_txn> r_fifo;
	std::queue<axi_r_txn> r0_fifo;
	
	struct axi_aw_txn {
		uint8_t awid;
		AXI_ADDR_TYPE awaddr;
		uint8_t awlen;
	};
	std::queue<axi_aw_txn> aw_fifo;
	
	struct axi_w_txn {
		AXI_WDATA_TYPE wdata[AXI_WIDTH / AXI_WDATA_TYLEN];
		AXI_WSTRB_TYPE wstrb;
		uint8_t wlast;
	};
	std::queue<axi_w_txn> w_fifo;
	
	struct axi_b_txn {
		uint8_t bid;
	};
	std::queue<axi_b_txn> b_fifo;
	
	std::map<uint32_t, std::vector<uint8_t> > ram;
	
	struct connections dla;
	const char *name;
	
public:	
	AXIResponder(struct connections _dla, const char *_name) {
		dla = _dla;
		
		*dla.aw_awready = 1;
		*dla.w_wready = 1;
		*dla.b_bvalid = 0;
		*dla.ar_arready = 1;
		*dla.r_rvalid = 0;
		
		name = _name;
		
		/* add some latency... */
		for (int i = 0; i < AXI_R_LATENCY; i++) {
			axi_r_txn txn;
			
			txn.rvalid = 0;
			txn.rvalid = 0;
			txn.rid = 0;
			txn.rlast = 0;
			for (int i = 0; i < AXI_WIDTH / AXI_WDATA_TYLEN; i++) {
				txn.rdata[i] = (AXI_WDATA_TYPE)0xAAAAAAAAAAAAAAAAULL;
			}
			
			r0_fifo.push(txn);
		}
	}

	uint8_t read(uint32_t addr) {
		ram[addr / AXI_BLOCK_SIZE].resize(AXI_BLOCK_SIZE, 0);
		return ram[addr / AXI_BLOCK_SIZE][addr % AXI_BLOCK_SIZE];
	}
	
	void write(uint32_t addr, uint8_t data) {
		ram[addr / AXI_BLOCK_SIZE].resize(AXI_BLOCK_SIZE, 0);
		ram[addr / AXI_BLOCK_SIZE][addr % AXI_BLOCK_SIZE] = data;
	}
	
	void eval() {
		/* write request */
		if (*dla.aw_awvalid && *dla.aw_awready) {
			printf("(%lu) %s: write request from dla, addr %08lx id %d\n", ticks, name, (uint64_t) *dla.aw_awaddr, *dla.aw_awid);
			
			axi_aw_txn txn;
			
			txn.awid = *dla.aw_awid;
			txn.awaddr = *dla.aw_awaddr & ~(AXI_ADDR_TYPE)(AXI_WIDTH / 8 - 1);
			txn.awlen = *dla.aw_awlen;
			aw_fifo.push(txn);
			
			*dla.aw_awready = 0;
		} else
			*dla.aw_awready = 1;
		
		/* write data */
		if (*dla.w_wvalid) {
			printf("(%lu) %s: write data from dla (%08lx...)\n", ticks, name, (uint64_t) dla.w_wdata[0]);
			
			axi_w_txn txn;
			
			for (int i = 0; i < AXI_WIDTH / AXI_WDATA_TYLEN; i++)
				txn.wdata[i] = dla.w_wdata[i];
			txn.wstrb = *dla.w_wstrb;
			txn.wlast = *dla.w_wlast;
			w_fifo.push(txn);
		}
		
		/* read request */
		if (*dla.ar_arvalid && *dla.ar_arready) {
			AXI_ADDR_TYPE addr = *dla.ar_araddr & ~(AXI_ADDR_TYPE)(AXI_WIDTH / 8 - 1);
			uint8_t len = *dla.ar_arlen;

			printf("(%lu) %s: read request from dla, addr %08lx burst %d id %d\n", ticks, name, (uint64_t) *dla.ar_araddr, *dla.ar_arlen, *dla.ar_arid);
			
			do {
				axi_r_txn txn;

				txn.rvalid = 1;
				txn.rlast = len == 0;
				txn.rid = *dla.ar_arid;
			
				for (int i = 0; i < AXI_WIDTH / AXI_WDATA_TYLEN; i++) {
					AXI_WDATA_TYPE da = 0;
					for (int j = 0; j < AXI_WDATA_TYLEN / 8; j++)
						da |= ((uint64_t)read(addr + i * (AXI_WDATA_TYLEN / 8) + j)) << (j * 8);
					txn.rdata[i] = da;
				}

				r_fifo.push(txn);
				
				addr += AXI_WIDTH / 8;
			} while (len--);
			
			axi_r_txn txn;
			
			txn.rvalid = 0;
			txn.rid = 0;
			txn.rlast = 0;
			for (int i = 0; i < AXI_WIDTH / 32; i++) {
				txn.rdata[i] = (AXI_WDATA_TYPE)0x5555555555555555ULL;
			}
			
			for (int i = 0; i < AXI_R_DELAY; i++)
				r_fifo.push(txn);
			
			*dla.ar_arready = 0;
		} else
			*dla.ar_arready = 1;
		
		/* now handle the write FIFOs ... */
		if (!aw_fifo.empty() && !w_fifo.empty()) {
			axi_aw_txn &awtxn = aw_fifo.front();
			axi_w_txn &wtxn = w_fifo.front();
			
			if (wtxn.wlast != (awtxn.awlen == 0)) {
				printf("(%lu) %s: wlast / awlen mismatch\n", ticks, name);
				abort();
			}
			
			for (int i = 0; i < AXI_WIDTH / 8; i++) {
				if (!((wtxn.wstrb >> i) & 1))
					continue;
				
				write(awtxn.awaddr + i, (wtxn.wdata[i / (AXI_WDATA_TYLEN / 8)] >> ((i % (AXI_WDATA_TYLEN / 8)) * 8)) & 0xFF);
			}
			
			
			if (wtxn.wlast) {
				printf("(%lu) %s: write, last tick\n", ticks, name);
				aw_fifo.pop();

				axi_b_txn btxn;
				btxn.bid = awtxn.awid;
				b_fifo.push(btxn);
			} else {
				printf("(%lu) %s: write, ticks remaining\n", ticks, name);

				awtxn.awlen--;
				awtxn.awaddr += AXI_WIDTH / 8;
			}
			
			w_fifo.pop();
		}
		
		/* read response */
		if (!r_fifo.empty()) {
			axi_r_txn &txn = r_fifo.front();
			
			r0_fifo.push(txn);
			r_fifo.pop();
		} else {
			axi_r_txn txn;
			
			txn.rvalid = 0;
			txn.rid = 0;
			txn.rlast = 0;
			for (int i = 0; i < AXI_WIDTH / AXI_WDATA_TYLEN; i++) {
				txn.rdata[i] = 0xAAAAAAAA;
			}
			
			r0_fifo.push(txn);
		}

		*dla.r_rvalid = 0;
		if (*dla.r_rready && !r0_fifo.empty()) {
			axi_r_txn &txn = r0_fifo.front();
			
			*dla.r_rvalid = txn.rvalid;
			*dla.r_rid = txn.rid;
			*dla.r_rlast = txn.rlast;
			for (int i = 0; i < AXI_WIDTH / AXI_WDATA_TYLEN; i++) {
				dla.r_rdata[i] = txn.rdata[i];
			}
			
			if (txn.rvalid)
				printf("(%lu) %s: read push: id %d, da %08lx\n",
					ticks, name, txn.rid, (uint64_t) txn.rdata[0]);
			
			r0_fifo.pop();
		}
		
		/* write response */
		*dla.b_bvalid = 0;
		if (*dla.b_bready && !b_fifo.empty()) {
			*dla.b_bvalid = 1;
			
			axi_b_txn &txn = b_fifo.front();
			*dla.b_bid = txn.bid;
			b_fifo.pop();
		}
	}
};

class TraceLoader {
	enum axi_opc {
		AXI_LOADMEM,
		AXI_DUMPMEM
	};

	struct axi_op {
		axi_opc opcode;
		uint32_t addr;
		uint32_t len;
		const uint8_t *buf;
		const char *fname;
	};
	std::queue<axi_op> opq;
	
	enum syncpt_opc {
		SYNCPT_CRC,
		SYNCPT_NOOP
	};
	
	struct syncpt_op {
		syncpt_opc opcode;
		uint32_t base, size, crc;
	};
	std::map<uint32_t, syncpt_op> syncpts;
	
	CSBMaster *csb;
	AXIResponder *axi_dbb;
	AXIResponder *axi_cvsram;
	
	int _test_passed;

public:
	enum stop_type {	
		TRACE_CONTINUE = 0,
		TRACE_AXIEVENT,
		TRACE_WFI,
		TRACE_SYNCPT_MASK = 0x80000000
	};

	TraceLoader(CSBMaster *_csb, AXIResponder *_axi_dbb, AXIResponder *_axi_cvsram) {
		csb = _csb;
		axi_dbb = _axi_dbb;
		axi_cvsram = _axi_cvsram;
		_test_passed = 1;
	}
	
	void load(const char *fname) {
		int fd;
		fd = open(fname, O_RDONLY);
		if (fd < 0) {
			perror("open(trace file)");
			abort();
		}
	
		unsigned char cmd;
		int rv;
#define VERILY_READ(p, n) do { if (read(fd, (p), (n)) != (n)) { perror("short read"); abort(); } } while(0)
		do {
			VERILY_READ(&cmd, 1);
			
			switch (cmd) {
			case 1:
				printf("CMD: wait\n");
				csb->ext_event(TRACE_WFI);
				break;
			case 2: {
				uint32_t addr;
				uint32_t data;
			
				VERILY_READ(&addr, 4);
				VERILY_READ(&data, 4);
				printf("CMD: write_reg %08x %08x\n", addr, data);
				csb->write(addr, data);
				break;
			}
			case 3: {
				uint32_t addr;
				uint32_t mask;
				uint32_t data;
				
				VERILY_READ(&addr, 4);
				VERILY_READ(&mask, 4);
				VERILY_READ(&data, 4);
				printf("CMD: read_reg %08x %08x %08x\n", addr, mask, data);
				csb->read(addr, mask, data);
				break;
			}
			case 4: {
				uint32_t addr;
				uint32_t len;
				uint8_t *buf;
				uint32_t namelen;
				char *fname;
				axi_op op;
				
				VERILY_READ(&addr, 4);
				VERILY_READ(&len, 4);
				buf = (uint8_t *)malloc(len);
				VERILY_READ(buf, len);
				
				VERILY_READ(&namelen, 4);
				fname = (char *) malloc(namelen+1);
				VERILY_READ(fname, namelen);
				fname[namelen] = 0;
				
				op.opcode = AXI_DUMPMEM;
				op.addr = addr;
				op.len = len;
				op.buf = buf;
				op.fname = fname;
				opq.push(op);
				csb->ext_event(TRACE_AXIEVENT);
				
				printf("CMD: dump_mem %08x bytes from %08x -> %s\n", len, addr, fname);
				break;
			}
			case 5: {
				uint32_t addr;
				uint32_t len;
				uint8_t *buf;
				axi_op op;
				
				VERILY_READ(&addr, 4);
				VERILY_READ(&len, 4);
				buf = (uint8_t *)malloc(len);
				VERILY_READ(buf, len);
				
				op.opcode = AXI_LOADMEM;
				op.addr = addr;
				op.len = len;
				op.buf = buf;
				opq.push(op);
				csb->ext_event(TRACE_AXIEVENT);
				
				printf("CMD: load_mem %08x bytes to %08x\n", len, addr);
				break;
			}
			case 6: {
				uint32_t id, mask;
				
				VERILY_READ(&id, 4);
				VERILY_READ(&mask, 4);
				
				csb->register_syncpt(TRACE_SYNCPT_MASK | id, mask);
				
				printf("CMD: register syncpt %d = %08x\n", id, mask);
				break;
			}
			case 7: {
				uint32_t status, mask;
				
				VERILY_READ(&status, 4);
				VERILY_READ(&mask, 4);
				
				csb->set_intr_registers(status, mask);
				
				printf("CMD: set interrupt registers: status %08x, mask %08x\n", status, mask);
				break;
			}
			case 8: {
				uint32_t spid, base, size, crc;
				syncpt_op op;
				
				VERILY_READ(&spid, 4);
				VERILY_READ(&base, 4);
				VERILY_READ(&size, 4);
				VERILY_READ(&crc, 4);
				
				op.opcode = SYNCPT_CRC;
				op.base = base;
				op.size = size;
				op.crc = crc;
				syncpts[spid] = op;
				
				printf("CMD: syncpt action %d = CRC(%08x + %08x) -> %08x\n", spid, base, size, crc);
				
				break;
			}
			case 9: {
				uint32_t spid;
				syncpt_op op;
				
				VERILY_READ(&spid, 4);
				
				op.opcode = SYNCPT_NOOP;
				syncpts[spid] = op;
				
				printf("CMD: syncpt action %d = ignore\n", spid);
				
				break;
			}
			case 0xFF:
				printf("CMD: done\n");
				break;
			default:
				printf("unknown command %c\n", cmd);
				abort();
			}
		} while (cmd != 0xFF);
		
		close(fd);
	}
	
	void axievent() {
		if (opq.empty()) {
			printf("extevent with nothing in the queue?\n");
			abort();
		}
		
		axi_op &op = opq.front();
		
		AXIResponder *axi;
		if (((op.addr & 0x80000000) == 0x00000000) && axi_cvsram)
			axi = axi_cvsram;
		else if (((op.addr & 0x80000000) == 0x80000000) && axi_dbb)
			axi = axi_dbb;
		else {
			printf("AXI event to bad offset\n");
			abort();
		}
		
		switch(op.opcode) {
		case AXI_LOADMEM: {
			const uint8_t *buf = op.buf;
			
			printf("AXI: loading memory at 0x%08x\n", op.addr);
			while (op.len) {
				axi->write(op.addr, *buf);
				buf++;
				op.addr++;
				op.len--;
			}
			break;
		}
		case AXI_DUMPMEM: {
			int fd;
			const uint8_t *buf = op.buf;
			int matched = 1;
			
			printf("AXI: dumping memory to %s\n", op.fname);
			fd = creat(op.fname, 0666);
			if (!fd) {
				perror("creat(dumpmem)");
				break;
			}
			while (op.len) {
				uint8_t da = axi->read(op.addr);
				write(fd, &da, 1);
				if (da != *buf && matched) {
					printf("AXI: FAIL: mismatch at memory address %08x (exp 0x%02x, got 0x%02x), and maybe others too\n", op.addr, *buf, da);
					matched = 0;
					_test_passed = 0;
				}
				buf++;
				op.addr++;
				op.len--;
			}
			close(fd);
			
			if (matched)
				printf("AXI: memory dump matched reference\n");
			break;
		}
		default:
			abort();
		}
		
		opq.pop();
	}
	
	void syncpt(uint32_t id) {
		id &= ~TRACE_SYNCPT_MASK;
		
		syncpt_op op = syncpts[id];
		syncpts.erase(id);
		
		switch (op.opcode) {
		case SYNCPT_NOOP:
			break;
		case SYNCPT_CRC: {
			uint32_t crc = ~0;
			uint32_t addr = op.base, len = op.size;
			
			AXIResponder *axi;
			if (((op.base & 0x80000000) == 0x00000000) && axi_cvsram)
				axi = axi_cvsram;
			else if (((op.base & 0x80000000) == 0x80000000) && axi_dbb)
				axi = axi_dbb;
			else {
				printf("AXI event to bad offset\n");
				abort();
			}
			
			while (len) {
				uint8_t da = axi->read(addr);
				
				crc ^= da;
				for (int i = 0; i < 8; i++) {
					crc = (crc >> 1) ^ ((crc & 1) ? 0xEDB88320 : 0);
				}
				
				addr++;
				len--;
			}
			
			crc = ~crc;
			
			if (crc != op.crc) {
				printf("*** FAIL: CRC mismatch: %08x + %08x should have been %08x, was %08x\n", op.base, op.size, crc, op.crc);
				_test_passed = 0;
			} else
				printf("*** CRC matched %08x + %08x -> %08x\n", op.base, op.size, crc);
			
			break;
		}
		default:
			abort();
		}
	}
	
	int test_passed() {
		return _test_passed;
	}
};

int main(int argc, const char **argv, char **env) {
	VNV_nvdla *dla = new VNV_nvdla;
	CSBMaster *csb = new CSBMaster(dla);
	
	AXIResponder::connections dbbconn = {
		.aw_awvalid = &dla->nvdla_core2dbb_aw_awvalid,
		.aw_awready = &dla->nvdla_core2dbb_aw_awready,
		.aw_awid = &dla->nvdla_core2dbb_aw_awid,
		.aw_awlen = &dla->nvdla_core2dbb_aw_awlen,
		.aw_awaddr = &dla->nvdla_core2dbb_aw_awaddr,
		
		.w_wvalid = &dla->nvdla_core2dbb_w_wvalid,
		.w_wready = &dla->nvdla_core2dbb_w_wready,
		.w_wdata = AXI_WDATA_MKPTR dla->nvdla_core2dbb_w_wdata,
		.w_wstrb = &dla->nvdla_core2dbb_w_wstrb,
		.w_wlast = &dla->nvdla_core2dbb_w_wlast,
		
		.b_bvalid = &dla->nvdla_core2dbb_b_bvalid,
		.b_bready = &dla->nvdla_core2dbb_b_bready,
		.b_bid = &dla->nvdla_core2dbb_b_bid,

		.ar_arvalid = &dla->nvdla_core2dbb_ar_arvalid,
		.ar_arready = &dla->nvdla_core2dbb_ar_arready,
		.ar_arid = &dla->nvdla_core2dbb_ar_arid,
		.ar_arlen = &dla->nvdla_core2dbb_ar_arlen,
		.ar_araddr = &dla->nvdla_core2dbb_ar_araddr,
	
		.r_rvalid = &dla->nvdla_core2dbb_r_rvalid,
		.r_rready = &dla->nvdla_core2dbb_r_rready,
		.r_rid = &dla->nvdla_core2dbb_r_rid,
		.r_rlast = &dla->nvdla_core2dbb_r_rlast,
		.r_rdata = AXI_WDATA_MKPTR dla->nvdla_core2dbb_r_rdata,
	};
	AXIResponder *axi_dbb = new AXIResponder(dbbconn, "DBB");

#ifdef NVDLA_SECONDARY_MEMIF_ENABLE
	AXIResponder::connections cvsramconn = {
		.aw_awvalid = &dla->nvdla_core2cvsram_aw_awvalid,
		.aw_awready = &dla->nvdla_core2cvsram_aw_awready,
		.aw_awid = &dla->nvdla_core2cvsram_aw_awid,
		.aw_awlen = &dla->nvdla_core2cvsram_aw_awlen,
		.aw_awaddr = &dla->nvdla_core2cvsram_aw_awaddr,
		
		.w_wvalid = &dla->nvdla_core2cvsram_w_wvalid,
		.w_wready = &dla->nvdla_core2cvsram_w_wready,
		.w_wdata = dla->nvdla_core2cvsram_w_wdata,
		.w_wstrb = &dla->nvdla_core2cvsram_w_wstrb,
		.w_wlast = &dla->nvdla_core2cvsram_w_wlast,
		
		.b_bvalid = &dla->nvdla_core2cvsram_b_bvalid,
		.b_bready = &dla->nvdla_core2cvsram_b_bready,
		.b_bid = &dla->nvdla_core2cvsram_b_bid,

		.ar_arvalid = &dla->nvdla_core2cvsram_ar_arvalid,
		.ar_arready = &dla->nvdla_core2cvsram_ar_arready,
		.ar_arid = &dla->nvdla_core2cvsram_ar_arid,
		.ar_arlen = &dla->nvdla_core2cvsram_ar_arlen,
		.ar_araddr = &dla->nvdla_core2cvsram_ar_araddr,
	
		.r_rvalid = &dla->nvdla_core2cvsram_r_rvalid,
		.r_rready = &dla->nvdla_core2cvsram_r_rready,
		.r_rid = &dla->nvdla_core2cvsram_r_rid,
		.r_rlast = &dla->nvdla_core2cvsram_r_rlast,
		.r_rdata = dla->nvdla_core2cvsram_r_rdata,
	};
	AXIResponder *axi_cvsram = new AXIResponder(cvsramconn, "CVSRAM");
#else
	AXIResponder *axi_cvsram = NULL;
#endif

	TraceLoader *trace = new TraceLoader(csb, axi_dbb, axi_cvsram);

#if VM_TRACE
	Verilated::traceEverOn(true);
	tfp = new VerilatedVcdC;
	dla->trace(tfp, 99);
	tfp->open("trace.vcd");
	atexit(_close_trace);
#endif
	
	dla->global_clk_ovr_on = 0;
	dla->tmc2slcg_disable_clock_gating = 0;
	dla->test_mode = 0;
	dla->nvdla_pwrbus_ram_c_pd = 0;
	dla->nvdla_pwrbus_ram_ma_pd = 0;
	dla->nvdla_pwrbus_ram_mb_pd = 0;
	dla->nvdla_pwrbus_ram_p_pd = 0;
	dla->nvdla_pwrbus_ram_o_pd = 0;
	dla->nvdla_pwrbus_ram_a_pd = 0;

	Verilated::commandArgs(argc, argv);
	if (argc != 2) {
		fprintf(stderr, "nvdla requires exactly one parameter (a trace file)\n");
		return 1;
	}
	
	trace->load(argv[1]);

	printf("reset...\n");
	dla->dla_reset_rstn = 1;
	dla->direct_reset_ = 1;
	dla->eval();
	for (int i = 0; i < 20; i++) {
		dla->dla_core_clk = 1;
		dla->dla_csb_clk = 1;
		dla->eval();
		ticks++;
#if VM_TRACE
		tfp->dump(ticks);
#endif
		
		dla->dla_core_clk = 0;
		dla->dla_csb_clk = 0;
		dla->eval();
		ticks++;
#if VM_TRACE
		tfp->dump(ticks);
#endif
	}

	dla->dla_reset_rstn = 0;
	dla->direct_reset_ = 0;
	dla->eval();
	
	for (int i = 0; i < 20; i++) {
		dla->dla_core_clk = 1;
		dla->dla_csb_clk = 1;
		dla->eval();
		ticks++;
#if VM_TRACE
		tfp->dump(ticks);
#endif
		
		dla->dla_core_clk = 0;
		dla->dla_csb_clk = 0;
		dla->eval();
		ticks++;
#if VM_TRACE
		tfp->dump(ticks);
#endif
	}
	
	dla->dla_reset_rstn = 1;
	dla->direct_reset_ = 1;
	
	printf("letting buffers clear after reset...\n");
	for (int i = 0; i < 8192; i++) {
		dla->dla_core_clk = 1;
		dla->dla_csb_clk = 1;
		dla->eval();
		ticks++;
#if VM_TRACE
		tfp->dump(ticks);
#endif
		
		dla->dla_core_clk = 0;
		dla->dla_csb_clk = 0;
		dla->eval();
		ticks++;
#if VM_TRACE
		tfp->dump(ticks);
#endif
	}

	printf("running trace...\n");
	uint32_t quiesc_timer = 200;
	int waiting = 0;
	while (!csb->done() || (quiesc_timer--)) {
		int extevent;
		
		extevent = csb->eval(waiting);
		
		if (extevent == TraceLoader::TRACE_AXIEVENT)
			trace->axievent();
		else if (extevent == TraceLoader::TRACE_WFI) {
			waiting = 1;
			printf("(%lu) waiting for interrupt...\n", ticks);
		} else if (extevent & TraceLoader::TRACE_SYNCPT_MASK) {
			trace->syncpt(extevent);
		}
		
		if (waiting && dla->dla_intr) {
			printf("(%lu) interrupt!\n", ticks);
			waiting = 0;
		}
		
		axi_dbb->eval();
		if (axi_cvsram)
			axi_cvsram->eval();

		dla->dla_core_clk = 1;
		dla->dla_csb_clk = 1;
		dla->eval();
		ticks++;
#if VM_TRACE
		tfp->dump(ticks);
#endif
		
		dla->dla_core_clk = 0;
		dla->dla_csb_clk = 0;
		dla->eval();
		ticks++;
#if VM_TRACE
		tfp->dump(ticks);
#endif
	}
	
	printf("done at %lu ticks\n", ticks);

	if (!trace->test_passed()) {
		printf("*** FAIL: test failed due to output mismatch\n");
		return 1;
	}
	
	if (!csb->test_passed()) {
		printf("*** FAIL: test failed due to CSB read mismatch\n");
		return 2;
	}
	
	printf("*** PASS\n");
	
	return 0;
}
