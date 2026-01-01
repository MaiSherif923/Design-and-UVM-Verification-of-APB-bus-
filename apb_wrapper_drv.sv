package apb_wrapper_drv_pkg;
import apb_wrapper_cfg::*;
import apb_wrapper_seqitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"  
class apb_wrapper_drv extends uvm_driver #(apb_wrapper_seq_item);
    `uvm_component_utils(apb_wrapper_drv)
    virtual apb_wrapper_if drv_wrapper_if;
    apb_wrapper_seq_item drv_seq_item;
function new(string name = "apb_wrapper_drv", uvm_component parent = null );        
    super.new(name, parent);
endfunction

task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
        drv_seq_item = apb_wrapper_seq_item::type_id::create("drv_seq_item");
        seq_item_port.get_next_item(drv_seq_item);
        drv_wrapper_if.PRESETn <= drv_seq_item.PRESETn;
        drv_wrapper_if.BADDR <= drv_seq_item.BADDR;
        drv_wrapper_if.BWDATA <= drv_seq_item.BWDATA;
        drv_wrapper_if.start_transfer <= drv_seq_item.start_transfer;
        drv_wrapper_if.BWRITE <= drv_seq_item.BWRITE;
        @(posedge drv_wrapper_if.PCLK);
        seq_item_port.item_done();
        `uvm_info("run_phase", drv_seq_item.convert2string(), UVM_HIGH)
    end
endtask

endclass //apb_wrapper_drv extends superClass


endpackage