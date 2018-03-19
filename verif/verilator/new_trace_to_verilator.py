#!/usr/bin/env python

import argparse
import opendla
import struct
import array
import re

class VerilatorTraceWriter(object):
    def __init__(self, fname):
        self.f = open(fname, 'wb')
    
    def wfi(self):
        self.f.write(struct.pack('=B', 1))
    
    def write_reg(self, addr, data):
        self.f.write(struct.pack('=BII', 2, addr, data))
    
    def read_reg(self, addr, mask, data):
        self.f.write(struct.pack('=BIII', 3, addr, mask, data))
    
    def dump_mem(self, addr, expected, dumpfile):
        self.f.write(struct.pack('=BII', 4, addr, len(expected)))
        self.f.write(expected)
        self.f.write(struct.pack('=I', len(dumpfile)))
        self.f.write(dumpfile)
    
    def load_mem(self, addr, data):
        self.f.write(struct.pack('=BII', 5, addr, len(data)))
        self.f.write(data)
    
    def close(self):
        self.f.write(struct.pack('=B', 0xFF))
        self.f.close()
    
    def register_syncpt_mask(self, id, mask):
        self.f.write(struct.pack('=BII', 6, id, mask))
    
    def set_intr_registers(self, status, mask):
        self.f.write(struct.pack('=BII', 7, status, mask))
    
    def syncpt_check_crc(self, spid, base, size, crc):
        self.f.write(struct.pack('=BIIII', 8, spid, base, size, crc))
    
    def syncpt_check_nothing(self, spid):
        self.f.write(struct.pack('=BI', 9, spid))

def main():
    parser = argparse.ArgumentParser(description = "Tool to convert new-style traces to Verilator blobs.")
    parser.add_argument("input", help = "Directory containing input compiled trace")
    parser.add_argument("output", help = "Trace file to create")
    args = parser.parse_args()
    
    # Ok, here we go.
    trace = VerilatorTraceWriter(args.output)

    # Start by configuring memory.
    with open('%s/trace_parser_cmd_memory_model_command.log' % args.input, 'r') as memf:
        for line in memf:
            toks = line.split()
            assert toks[1] == 'PRI_MEM'
            if toks[0] == 'MEM_INIT_PATTERN':
                assert toks[4] == 'ALL_ZERO'
                trace.load_mem(int(toks[2], 16), b'\x00' * int(toks[3], 16))
            elif toks[0] == 'MEM_LOAD':
                ar = array.array('B')
                
                if toks[5][0] == '/':
                    patpath = toks[5]
                else:
                    patpath = '%s/%s' % (args.input, toks[5])
                with open(patpath, 'r') as mempatf:
                    for memline in mempatf:
                        if memline.strip() == "{":
                            continue
                        if memline.strip() == "}":
                            continue

                        p = re.match(r'{\s*offset:\s*([0-9a-fA-Fx]+)\s*,\s*size:\s*([0-9a-fA-Fx]+)\s*,\s*payload:\s*([0-9a-fA-Fx ]+)\s*}\s*', memline)
                        assert p
                        
                        offset = int(p.group(1), 0)
                        size = int(p.group(2), 0)
                        payload = p.group(3)
                        
                        if len(ar) < offset + size:
                            ar.extend([0] * (offset + size - len(ar)))
                        for i,b in enumerate(payload.split()):
                            ar[offset + i] = int(b, 0)
                
                trace.load_mem(int(toks[2], 16), ar)
            else:
                raise ValueError(toks[0])
    
    syncpts = {}
    syncptid = 0
    
    # Set up syncpoints.
    with open('%s/trace_parser_cmd_interrupt_controller_command.log' % args.input, 'r') as icf:
        for line in icf:
            toks = line.split()
            
            syncpts[toks[2]] = syncptid
            syncptid += 1

            if toks[0] == 'MULTI_SHOT':
                # Which bit is this, really?
                (blk,id) = re.match(r'(.*)_(.*)', toks[1].upper()).groups()
                trace.register_syncpt_mask(
                  syncpts[toks[2]],
                  opendla.registers['NVDLA_GLB']['S_INTR_STATUS_0']['%s_DONE_STATUS%s' % (blk, id)]['field'])
            else:
                raise ValueError(toks[0])
                
    # Set up result checker.
    with open('%s/trace_parser_cmd_result_checker_command.log' % args.input, 'r') as rcf:
        for line in rcf:
            toks = line.split()
            
            assert toks[1] in syncpts
            assert toks[2] == "1" # memory_type
            
            if toks[0] == 'CHECK_NOTHING':
                trace.syncpt_check_nothing(syncpts[toks[1]])
                pass
            elif toks[0] == 'CHECK_CRC':
                trace.syncpt_check_crc(syncpts[toks[1]], int(toks[3], 16), int(toks[4], 16), int(toks[5], 16))
            else:
                raise ValueError(toks[0])
    
    # Finally, registers.
    with open('%s/trace_parser_cmd_sequence_command.log' % args.input, 'r') as seqf:
        for line in seqf:
            toks = line.split()
            
            reg = opendla.registers[toks[1]][toks[2]]
            
            if toks[0] == 'WRITE':
                trace.write_reg(reg['addr'] >> 2, int(toks[4], 16))
            elif toks[0] == 'POLL_REG_EQUAL':
                trace.read_reg(reg['addr'] >> 2, 0xFFFFFFFF, int(toks[4], 16))
            else:
                raise ValueError(toks[0])
    
    if len(syncpts) > 0:
        trace.set_intr_registers(
          opendla.registers['NVDLA_GLB']['S_INTR_STATUS_0']['addr'] >> 2,
          opendla.registers['NVDLA_GLB']['S_INTR_MASK_0']['addr'] >> 2)
    
    trace.close()

if __name__ == '__main__':
    main()