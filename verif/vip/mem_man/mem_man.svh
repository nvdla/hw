`ifndef MEM_MAN_SVH
`define MEM_MAN_SVH

class mem_man extends uvm_report_object;

    /* public functions */

    extern static function mem_man get_mem_man();

    extern function mem_domain
        register_domain(string domain_name,
                        bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                        bit [`MEM_ADDR_SIZE_MAX-1:0] limit,
                        alloc_policy_e alloc_policy = ALLOC_FROM_LOW);

    extern function mem_region
        request_region_by_addr(string domain_name,
                               string region_name,
                               bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                               bit [`MEM_ADDR_SIZE_MAX-1:0] limit);

    extern function mem_region
        request_region_by_size(string domain_name,
                               string region_name,
                               bit [`MEM_ADDR_SIZE_MAX-1:0] size,
                               bit [`MEM_ADDR_SIZE_MAX-1:0] align_mask);

    extern function mem_region release_region_by_name(string domain_name,
                                                      string region_name);

    extern function mem_region release_region_by_addr(string domain_name,
                                                      bit [`MEM_ADDR_SIZE_MAX-1:0] addr);

    extern function void display();

    /* private functions */

    extern protected function new(string name = "mem_man");
    extern local     function mem_domain get_domain(string domain_name);

    /* private variables */

    local string            tID;
    local static mem_man    inst;
    local mem_domain        domains[string];

endclass

/* public functions */

static function
mem_man mem_man::get_mem_man();
    if (inst == null)
        inst = new();

    return inst;
endfunction

function mem_domain
mem_man::register_domain(string domain_name,
                         bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                         bit [`MEM_ADDR_SIZE_MAX-1:0] limit,
                         alloc_policy_e alloc_policy = ALLOC_FROM_LOW);
    if (!domains.exists(domain_name)) begin
        mem_domain tmp_domain = new(domain_name, base, limit, alloc_policy);
        domains[domain_name] = tmp_domain;
        `uvm_info(tID,
            $sformatf("Creating new mem_domain %s: base=%#0x, limit=%#0x, alloc_policy=%s",
                domain_name, base, limit, alloc_policy.name()), UVM_LOW)
    end

    return domains[domain_name];
endfunction

function mem_region
mem_man::request_region_by_addr(string domain_name,
                                string region_name,
                                bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                                bit [`MEM_ADDR_SIZE_MAX-1:0] limit);

    mem_domain tmp_domain = get_domain(domain_name);
    if (tmp_domain == null) begin
        `uvm_fatal(tID, {"Could not find domain_name ", domain_name});
    end

    return tmp_domain.request_region_by_addr(region_name, base, limit);
endfunction

function mem_region
mem_man::request_region_by_size(string domain_name,
                                string region_name,
                                bit [`MEM_ADDR_SIZE_MAX-1:0] size,
                                bit [`MEM_ADDR_SIZE_MAX-1:0] align_mask);

    mem_domain tmp_domain = get_domain(domain_name);
    if (tmp_domain == null) begin
        `uvm_fatal(tID, {"Could not find domain_name ", domain_name});
    end

    return tmp_domain.request_region_by_size(region_name, size, align_mask);
endfunction

function mem_region mem_man::release_region_by_name(string domain_name,
                                                    string region_name);
    mem_domain tmp_domain = get_domain(domain_name);
    if (tmp_domain == null) begin
        `uvm_fatal(tID, {"Could not find domain_name ", domain_name});
    end

    return tmp_domain.release_region_by_name(region_name);
endfunction

function mem_region mem_man::release_region_by_addr(string domain_name,
                                                    bit [`MEM_ADDR_SIZE_MAX-1:0] addr);
    mem_domain tmp_domain = get_domain(domain_name);
    if (tmp_domain == null) begin
        `uvm_fatal(tID, {"Could not find domain_name ", domain_name});
    end

    return tmp_domain.release_region_by_addr(addr);
endfunction

function void mem_man::display();
    string tmp = $psprintf("Global mem_man (%s):\n", get_name());

    foreach (domains[iter]) begin
        tmp = {tmp, domains[iter].convert2string(), "\n"};
    end

    `uvm_info(get_name(), $psprintf("%s", tmp), UVM_LOW);
endfunction

/* private functions */

function mem_man::new(string name = "mem_man");
    super.new(name);

    tID = get_name();
    tID = tID.toupper();
endfunction

function mem_domain mem_man::get_domain(string domain_name);
    if (!domains.exists(domain_name)) return null;

    return domains[domain_name];
endfunction

`endif
