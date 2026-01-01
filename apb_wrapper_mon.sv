package apb_wrapper_mon_pkg;
import apb_wrapper_cfg::*;
import apb_wrapper_seqitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"  
class apb_wrapper_mon extends uvm_monitor;
    `uvm_component_utils(apb_wrapper_mon)
    virtual apb_wrapper_if mon_wrapper_if;
    apb_wrapper_seq_item mon_seq_item;
    uvm_analysis_port #(apb_wrapper_seq_item) mon_ap;
function new(string name = "apb_wrapper_mon", uvm_component parent = null );        
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_ap = new("mon_ap", this);
endfunction

task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
        mon_seq_item = apb_wrapper_seq_item::type_id::create("mon_seq_item");
        @(posedge mon_wrapper_if.PCLK);
        mon_seq_item.PRESETn = mon_wrapper_if.PRESETn;
        mon_seq_item.BADDR = mon_wrapper_if.BADDR;
        mon_seq_item.BWDATA = mon_wrapper_if.BWDATA;
        mon_seq_item.start_transfer = mon_wrapper_if.start_transfer;
        mon_seq_item.BWRITE = mon_wrapper_if.BWRITE;
        mon_seq_item.PREADY = mon_wrapper_if.PREADY;
        mon_seq_item.PRDATA = mon_wrapper_if.PRDATA;
        mon_seq_item.PSLVERR = mon_wrapper_if.PSLVERR;
        mon_seq_item.BRDATA = mon_wrapper_if.BRDATA;
        mon_seq_item.BERR = mon_wrapper_if.BERR;
        mon_seq_item.PADDR = mon_wrapper_if.PADDR;
        mon_seq_item.PSEL = mon_wrapper_if.PSEL;
        mon_seq_item.PENABLE = mon_wrapper_if.PENABLE;
        mon_seq_item.PWRITE = mon_wrapper_if.PWRITE;
        mon_seq_item.PWDATA = mon_wrapper_if.PWDATA;
        mon_seq_item.PSEL_gm = mon_wrapper_if.PSEL_gm;
        mon_seq_item.PENABLE_gm = mon_wrapper_if.PENABLE_gm;
        mon_seq_item.PWRITE_gm = mon_wrapper_if.PWRITE_gm;
        mon_seq_item.PADDR_gm = mon_wrapper_if.PADDR_gm;
        mon_seq_item.PWDATA_gm = mon_wrapper_if.PWDATA_gm;
        mon_seq_item.PREADY_gm = mon_wrapper_if.PREADY_gm;
        mon_seq_item.PSLVERR_gm = mon_wrapper_if.PSLVERR_gm;
        // mon_seq_item.PRDATA_gm = mon_wrapper_if.PRDATA_gm;
        // mon_seq_item.BERR_gm = mon_wrapper_if.BERR_gm;
        mon_seq_item.BRDATA_gm = mon_wrapper_if.BRDATA_gm;
        // mon_seq_item.SSTRB = mon_wrapper_if.SSTRB;
        // mon_seq_item.SPROT = mon_wrapper_if.SPROT;
        mon_ap.write(mon_seq_item);
        `uvm_info("run_phase", mon_seq_item.convert2string(), UVM_HIGH)
    end
endtask
endclass 
endpackage