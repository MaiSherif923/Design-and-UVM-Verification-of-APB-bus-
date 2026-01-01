package apb_wrapper_sequence_pkg;
import shared_pkg::*;
import apb_wrapper_seqitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class reset_sequence extends uvm_sequence #(apb_wrapper_seq_item);
    `uvm_object_utils(reset_sequence)
    apb_wrapper_seq_item rst_seq_item;
    function new(string name = "reset_sequence");
        super.new(name);        
    endfunction //new()

task body();
    rst_seq_item = apb_wrapper_seq_item :: type_id::create("rst_seq_item");
    start_item(rst_seq_item);
    rst_seq_item.PRESETn = 0;
    rst_seq_item.BADDR = 0;
    rst_seq_item.BWDATA = 0;
    rst_seq_item.start_transfer = 0;
    rst_seq_item.BWRITE = 0;
    finish_item(rst_seq_item);
endtask
endclass //reset_sequence extends superClass

class write_sequence extends uvm_sequence #(apb_wrapper_seq_item);
    `uvm_object_utils(write_sequence)
    apb_wrapper_seq_item main_seq_item;
    function new(string name = "write_sequence");
        super.new(name);        
    endfunction //new()

task body();
    main_seq_item = apb_wrapper_seq_item :: type_id::create("main_seq_item");
    main_seq_item.read_ct.constraint_mode(0);
    main_seq_item.addr_ct_with_err.constraint_mode(0);
   repeat (500) begin
    start_item(main_seq_item);
        assert(main_seq_item.randomize());
    finish_item(main_seq_item);
   end
endtask
endclass

class read_sequence extends uvm_sequence #(apb_wrapper_seq_item);
    `uvm_object_utils(read_sequence)
    apb_wrapper_seq_item main_seq_item;
    function new(string name = "read_sequence");
        super.new(name);        
    endfunction //new()

task body();
    main_seq_item = apb_wrapper_seq_item :: type_id::create("main_seq_item");
    main_seq_item.read_ct.constraint_mode(1);
    main_seq_item.write_ct.constraint_mode(0);
   repeat (500) begin
    start_item(main_seq_item);
        assert(main_seq_item.randomize());
    finish_item(main_seq_item);
   end
endtask
endclass


class error_sequence extends uvm_sequence #(apb_wrapper_seq_item);
    `uvm_object_utils(error_sequence)
    apb_wrapper_seq_item main_seq_item;
    function new(string name = "error_sequence");
        super.new(name);        
    endfunction //new()
       task pre_body();
    uvm_config_db#(bit)::set( null, "uvm_test_top.wrapper_env.wrapper_sb", "sb_enable",0);
  
  endtask


task body();
    main_seq_item = apb_wrapper_seq_item :: type_id::create("main_seq_item");
    main_seq_item.read_ct.constraint_mode(0);
    main_seq_item.write_ct.constraint_mode(0);
    main_seq_item.addr_ct_with_err.constraint_mode(1);
    main_seq_item.addr_ct.constraint_mode(0);

   repeat (500) begin
    start_item(main_seq_item);
        assert(main_seq_item.randomize() with {BWRITE inside {0,1};});
    finish_item(main_seq_item);
   end
endtask
 task post_body();
    uvm_config_db#(bit)::set(null, "uvm_test_top.wrapper_env.wrapper_sb", "sb_enable",1);
 endtask
endclass


class new_transfer extends uvm_sequence #(apb_wrapper_seq_item);
    `uvm_object_utils(new_transfer)
    apb_wrapper_seq_item main_seq_item;
    function new(string name = "new_transfer");
        super.new(name);        
    endfunction //new()


task body();
    main_seq_item = apb_wrapper_seq_item :: type_id::create("main_seq_item");
    main_seq_item.read_ct.constraint_mode(0);
    main_seq_item.write_ct.constraint_mode(0);
    main_seq_item.new_trasfere.constraint_mode(1);
    main_seq_item.start_transfer_ct.constraint_mode(0);
   repeat (500) begin
    start_item(main_seq_item);
        assert(main_seq_item.randomize() with {BWRITE inside {0,1};});
    finish_item(main_seq_item);
   end
endtask
endclass



endpackage