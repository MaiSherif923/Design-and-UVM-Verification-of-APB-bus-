package apb_wrapper_sqr_pkg;
import apb_wrapper_seqitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"  
class apb_wrapper_sqr extends uvm_sequencer #(apb_wrapper_seq_item);
   `uvm_component_utils(apb_wrapper_sqr)

function new(string name = "apb_wrapper_sqr", uvm_component parent = null);
    super.new(name, parent);
endfunction //new()
endclass
endpackage   