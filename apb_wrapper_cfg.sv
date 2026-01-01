package apb_wrapper_cfg;
import uvm_pkg::*;
`include "uvm_macros.svh"  

    class apb_wrapper_cfg extends uvm_object;
    `uvm_object_utils(apb_wrapper_cfg)
    virtual apb_wrapper_if cfg_wrapper_if;
    uvm_active_passive_enum mode;
        function new(string name = "apb_wrapper_cfg");
            super.new(name);
        endfunction //new()
    endclass 
endpackage