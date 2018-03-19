`ifndef MEM_DOMAIN_SVH
`define MEM_DOMAIN_SVH

// TODO: Add region release APIs

class mem_domain extends uvm_report_object;

    /* public variables */

    alloc_policy_e alloc_policy;

    /* public functions */

    extern function new(string name,
                        bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                        bit [`MEM_ADDR_SIZE_MAX-1:0] limit,
                        alloc_policy_e alloc_policy = ALLOC_FROM_LOW);

    extern function mem_region
        request_region_by_size(string region_name,
                               bit [`MEM_ADDR_SIZE_MAX-1:0] size,
                               bit [`MEM_ADDR_SIZE_MAX-1:0] align_mask);

    extern function mem_region
        request_region_by_addr(string region_name,
                               bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                               bit [`MEM_ADDR_SIZE_MAX-1:0] limit);

    extern function string convert2string();

    /* private functions */

    extern local function mem_region
        create_region(string region_name,
                      bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                      bit [`MEM_ADDR_SIZE_MAX-1:0] limit);

    extern function bit [`MEM_ADDR_SIZE_MAX-1:0]
        search_for_free_space(bit [`MEM_ADDR_SIZE_MAX-1:0] size,
                              bit [`MEM_ADDR_SIZE_MAX-1:0] align_mask);

    extern function mem_region
        reserve_region(string region_name,
                       bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                       bit [`MEM_ADDR_SIZE_MAX-1:0] limit);

    extern function mem_region
        allocate_region(string unique_region_name,
                        bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                        bit [`MEM_ADDR_SIZE_MAX-1:0] limit);

    extern local function string get_unique_name(string old_name);

    extern local function bit [`MEM_ADDR_SIZE_MAX]
        find_aligned_addr_abovebase(bit [`MEM_ADDR_SIZE_MAX] base,
                                    bit [`MEM_ADDR_SIZE_MAX] align_mask);

    extern local function bit [`MEM_ADDR_SIZE_MAX]
        find_aligned_addr_belowbase(bit [`MEM_ADDR_SIZE_MAX] base,
                                    bit [`MEM_ADDR_SIZE_MAX] align_mask);

    extern function mem_region
        find_region_in_freelist(bit [`MEM_ADDR_SIZE_MAX-1:0] rgnbase,
                                bit [`MEM_ADDR_SIZE_MAX-1:0] rgnlimit);

    extern local function bit
        check_domain_bounds(bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                            bit [`MEM_ADDR_SIZE_MAX-1:0] limit);

    extern local function void
        delete_region_from_free_list(mem_region region_to_delete);

    extern local function int get_num_regions();

    /* private variables */

    local string                        tID;
    local mem_region                    region_list[$];
    local mem_region                    free_list[$];
    local mem_region                    named_region_map[string];
    local bit [`MEM_ADDR_SIZE_MAX-1:0]  base;
    local bit [`MEM_ADDR_SIZE_MAX-1:0]  limit;

endclass

// ----------------------------------------------------------------------------
// Implementations
// ----------------------------------------------------------------------------

/* public functions */

function mem_domain::new(string name,
                         bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                         bit [`MEM_ADDR_SIZE_MAX-1:0] limit,
                         alloc_policy_e alloc_policy = ALLOC_FROM_LOW);
    super.new({"mem_domain_", name});

    tID = name.toupper();

    if (limit < base)
        `uvm_fatal(tID,
            $sformatf("limit (%#0x) is lower than base (%#0x) for domain %s",
            limit, base, name))

    this.base = base;
    this.limit = limit;
    this.alloc_policy = alloc_policy;

    free_list[0] = create_region(get_unique_name("free"), base, limit);
endfunction

function mem_region
mem_domain::request_region_by_size(string region_name,
                                   bit [`MEM_ADDR_SIZE_MAX-1:0] size,
                                   bit [`MEM_ADDR_SIZE_MAX-1:0] align_mask);

    bit [`MEM_ADDR_SIZE_MAX-1:0] alignedbase;
    mem_region new_region;

    alignedbase = search_for_free_space(size, align_mask);
    `uvm_info(tID, $sformatf("request_region_by_size: size = %#x, align_mask = %#x", size, align_mask), UVM_HIGH)
    if (alignedbase == -1) begin
        `uvm_fatal(tID,
            $sformatf("request_region: Not enough contiguous space available to reserve region size=%#0x, align_mask=%#0x for region %s.\n %s",
            size, align_mask, region_name, convert2string()));
        return null;
    end

    new_region = reserve_region(region_name, alignedbase, alignedbase+size);
    return new_region;
endfunction

function mem_region
mem_domain::request_region_by_addr(string region_name,
                                   bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                                   bit [`MEM_ADDR_SIZE_MAX-1:0] limit);
    return reserve_region(region_name, base, limit);
endfunction

function string mem_domain::convert2string();
    string tmp = $sformatf("mem_domain %s:\n", get_name());

    tmp = {tmp, "  [region_list]\n"};
    foreach (region_list[iter]) begin
        tmp = {tmp, "    ", region_list[iter].convert2string(), "\n"};
    end

    tmp = {tmp, "  [free_list]\n"};
    foreach (free_list[ i ]) begin
        tmp = {tmp, "    ", free_list[ i ].convert2string(), "\n"};
    end

    return tmp;
endfunction

/* private functions */

function mem_region
mem_domain::create_region(string region_name,
                          bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                          bit [`MEM_ADDR_SIZE_MAX-1:0] limit);
    mem_region new_region;
    new_region = new (region_name);
    new_region.base = base;
    new_region.limit = limit;

    return new_region;
endfunction

function bit [`MEM_ADDR_SIZE_MAX-1:0]
mem_domain::search_for_free_space(bit [`MEM_ADDR_SIZE_MAX-1:0] size,
                                  bit [`MEM_ADDR_SIZE_MAX-1:0] align_mask);
    mem_region possible_regions[$];
    bit [`MEM_ADDR_SIZE_MAX-1:0] aligned_addr;

    case (alloc_policy)
        ALLOC_FROM_LOW: begin
            possible_regions = free_list.find(rgn) with (
                rgn.limit >= (find_aligned_addr_abovebase(rgn.base, align_mask) + size -1)
            );
            if (possible_regions.size() <= 0) return -1;

            possible_regions.sort(rgn) with (rgn.get_len());
            aligned_addr = find_aligned_addr_abovebase(possible_regions[0].base, align_mask);
        end

        ALLOC_FROM_HIGH: begin
            possible_regions = free_list.find(rgn) with (
                rgn.base <= (find_aligned_addr_belowbase(rgn.limit-size+1, align_mask))
            );
            if (possible_regions.size() <= 0) return -1;

            possible_regions.sort(rgn) with (rgn.get_len());
            aligned_addr = find_aligned_addr_belowbase(possible_regions[0].limit-size, align_mask);
        end

        ALLOC_RANDOM: begin
            bit success = 0;

            possible_regions = free_list.find(rgn) with (
                rgn.limit >= (find_aligned_addr_abovebase(rgn.base, align_mask) + size -1)
            );
            if (possible_regions.size() <= 0) return -1;

            possible_regions.shuffle();
            success = std::randomize(aligned_addr) with {
                (aligned_addr & align_mask) == 0;
                aligned_addr inside {[possible_regions[0].base : possible_regions[0].limit-1]};
                (`MEM_ADDR_SIZE_MAX+1)'(aligned_addr + size) inside {[possible_regions[0].base : possible_regions[0].limit]};
            };
            if (!success) `uvm_fatal(tID, "std::randomize(aligned_addr) failed!")
            `uvm_info(tID,
                $sformatf("search_for_free_space: possible_regions[0].base = %#x, possible_regions[0].limit = %#x, aligned_addr = %#x, size = %#x, align_mask = %#x",
                possible_regions[0].base, possible_regions[0].limit, aligned_addr, size, align_mask), UVM_HIGH)
        end

        default:
            `uvm_fatal(tID,
                $sformatf("Invalid allocation policy (%s)", alloc_policy.name()))
    endcase
    `uvm_info(tID,
        $sformatf("[%#0x:%#0x] is allocated from [%#0x:%#0x]",
            aligned_addr, aligned_addr+size, possible_regions[0].base, possible_regions[0].limit), UVM_HIGH)

    return aligned_addr;
endfunction

function mem_region
mem_domain::reserve_region(string region_name,
                           bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                           bit [`MEM_ADDR_SIZE_MAX-1:0] limit);

    mem_region new_region;

    if (limit < base) begin
        `uvm_fatal(tID,
            $sformatf("limit (%#0x) is lower than base(%#0x) for %s.",
            limit, base, region_name))
    end
    `uvm_info(tID, $sformatf("reserve_region: base = %#x, limit = %#x", base, limit), UVM_HIGH)

    if (! check_domain_bounds(base, limit)) return null;

    region_name = get_unique_name(region_name);
    new_region  = allocate_region(region_name, base, limit);
    if (new_region == null) begin
        `uvm_fatal(tID,
            $sformatf("Unable to reserve region '%s' with base=%#0x, limit=%#0x\n%s",
            region_name,  base, limit, convert2string()));
         return null;
    end

    foreach (region_list[iter]) begin
        if (new_region.overlaps(region_list[iter])) begin
            `uvm_fatal(tID,
                $sformatf("Unable to reserve region '%s' with base=%#0x, limit=%#0x\n%s",
                region_name, base, limit, convert2string()))
            return null;
        end
    end

    `uvm_info(tID,
        $sformatf("Reserved region '%s' with base=%#0x, limit=%#0x",
        region_name, new_region.base, new_region.limit),
        UVM_HIGH);

    region_list.push_back(new_region);
    named_region_map[region_name] = new_region;

    return new_region;
endfunction

function mem_region
mem_domain::allocate_region(string unique_region_name,
                            bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                            bit [`MEM_ADDR_SIZE_MAX-1:0] limit);

    mem_region    found_region;
    int           containing_fr_rgn_idx[$];
    mem_region    allocd_rgn;
    mem_region    new_free_rgn;

    found_region = find_region_in_freelist(base, limit);

    if (found_region == null) return null;

    if ((limit == found_region.limit) && (base == found_region.base)) begin
        found_region.set_name(unique_region_name);
        delete_region_from_free_list(found_region);
        return found_region;
    end

    // If the memory region doesnt exactly match an existing free region
    // then we must create it.
    allocd_rgn = create_region(unique_region_name, base, limit);
    if ((base == found_region.base)) begin
        // If the requested region is on the 'base' end of the
        // free region that can contain this then we move the base
        // of that section to reflect the allocation
        // Before: |-------------------found_region--------------------|
        // After:  |--allocd_region--|--found_region-------------------|
        found_region.base = allocd_rgn.limit + 1;
    end else if ((limit == found_region.limit)) begin
        // If the requested region is on the 'limit' end of
        // the free region that can contain this, then we
        // shorten the limit on that section to reflect the allocation
        // Before: |-------------------found_region--------------------|
        // After:  |-----------------found_region--|---allocd_region---|
        found_region.limit = allocd_rgn.base - 1;
    end else begin
        // Else, if the region requested exists somewhere in
        // the middle of the found free region, then we edit the free region
        // and create a new one.
        // Before: |-------------------found_region--------------------|
        // After:  |--found_region--|--allocd_region--|--new_free_rgn--|
        new_free_rgn = create_region(get_unique_name("free"),
                                     allocd_rgn.limit + 1, found_region.limit);
        found_region.limit = allocd_rgn.base - 1;

        // Insert this newly created free region in its right place
        // in the sorted free list
        containing_fr_rgn_idx = free_list.find_first_index(rgn) with(rgn == found_region);
        free_list.insert(containing_fr_rgn_idx[0] + 1, new_free_rgn);
    end
    return allocd_rgn;
endfunction

function string
mem_domain::get_unique_name(string old_name);
    string new_name = old_name;

    if (new_name == "") new_name = "unnamed";

    if (named_region_map.exists(new_name))
        new_name = $sformatf("%s_%1d", new_name, get_num_regions());

    return new_name;
endfunction

function bit [`MEM_ADDR_SIZE_MAX]
mem_domain::find_aligned_addr_abovebase(bit [`MEM_ADDR_SIZE_MAX] base,
                                        bit [`MEM_ADDR_SIZE_MAX] align_mask);
    return (base + align_mask) & ~align_mask;
endfunction

function bit [`MEM_ADDR_SIZE_MAX]
mem_domain::find_aligned_addr_belowbase(bit [`MEM_ADDR_SIZE_MAX] base,
                                        bit [`MEM_ADDR_SIZE_MAX] align_mask);
    return base & ~align_mask;
endfunction

function mem_region
mem_domain::find_region_in_freelist(bit [`MEM_ADDR_SIZE_MAX-1:0] rgnbase,
                                    bit [`MEM_ADDR_SIZE_MAX-1:0] rgnlimit);

    mem_region    containing_fr_rgn[$];

    containing_fr_rgn = free_list.find_first(rgn) with (
        (rgnbase >= rgn.base) && (rgnlimit<= rgn.limit)
    );

    if (containing_fr_rgn.size() == 0) return null;
    if (rgnlimit > containing_fr_rgn[0].limit) return null;

    return containing_fr_rgn[0];
endfunction

function bit
mem_domain::check_domain_bounds(bit [`MEM_ADDR_SIZE_MAX-1:0] base,
                                bit [`MEM_ADDR_SIZE_MAX-1:0] limit);

    if (base < this.base) begin
        `uvm_fatal(tID,
            $sformatf("Requested base address (%#0x) is lower than the base address for this mem_domain (%#0x)",
            base, this.base))
        return 0;
    end

    if (limit > this.limit) begin
        `uvm_fatal(tID,
            $sformatf("Requested limit address (%#0x) is higher than the limit address for this mem_domain (%#0x)",
            limit, this.limit))
        return 0;
    end

    return 1;
endfunction

function void
mem_domain::delete_region_from_free_list(mem_region region_to_delete);
    int containing_fr_rgn_idx[$];

    containing_fr_rgn_idx = free_list.find_first_index(rgn) with(rgn == region_to_delete);
    if (containing_fr_rgn_idx.size() == 0) begin
        `uvm_fatal(tID, "Attempted to grant free region that does not exist!")
    end

    free_list.delete(containing_fr_rgn_idx[0]);
endfunction

function int mem_domain::get_num_regions();
    return region_list.size();
endfunction

`endif
