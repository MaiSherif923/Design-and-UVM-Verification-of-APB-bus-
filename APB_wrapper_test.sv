package apb_wrapper_test_pkg;
import apb_wrapper_cfg::*;
import apb_wrapper_env_pkg::*;
import apb_wrapper_sequence_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"  
class apb_wrapper_test extends uvm_test;
`uvm_component_utils(apb_wrapper_test)
apb_wrapper_cfg apb_wrapper_config;
apb_wrapper_env wrapper_env;
reset_sequence reset_seq;
write_sequence wrtie_seq;
read_sequence read_seq;
error_sequence error_seq;
new_transfer new_transfer_seq;
virtual apb_wrapper_if vif;

function new(string name = "apb_wrapper_test", uvm_component parent = null );        
    super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
reset_seq = reset_sequence::type_id::create("reset_seq");
wrtie_seq = write_sequence::type_id::create("wrtie_seq");
read_seq = read_sequence::type_id::create("read_seq");
error_seq = error_sequence::type_id::create("error_seq");
new_transfer_seq = new_transfer::type_id::create("new_transfer_seq");
wrapper_env = apb_wrapper_env::type_id::create("wrapper_env",this);
apb_wrapper_config = apb_wrapper_cfg::type_id::create("apb_wrapper_config");

if(!uvm_config_db #(virtual apb_wrapper_if) ::get(this ,"", "WRAPPER_IF", apb_wrapper_config.cfg_wrapper_if) )
    `uvm_fatal("build phase", "Test - couldn't get the virtual interface of the wrapper from the uvm_config_db")
apb_wrapper_config.mode = UVM_ACTIVE;
uvm_config_db #(apb_wrapper_cfg)::set(this,"*", "WRAPPER_CFG", apb_wrapper_config);    
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
`uvm_info("run phase", "reset sequence has started", UVM_LOW);
reset_seq.start(wrapper_env.wrapper_agt.apb_wrapper_seqr);
`uvm_info("run phase", "write sequene has started", UVM_LOW);
wrtie_seq.start(wrapper_env.wrapper_agt.apb_wrapper_seqr);
`uvm_info("run phase", "read sequence has started", UVM_LOW);
read_seq.start(wrapper_env.wrapper_agt.apb_wrapper_seqr);
`uvm_info("run phase", "new transfer sequence is stared", UVM_LOW);
new_transfer_seq.start(wrapper_env.wrapper_agt.apb_wrapper_seqr);
`uvm_info("run phase", "error sequence has started", UVM_LOW);
error_seq.start(wrapper_env.wrapper_agt.apb_wrapper_seqr);
// the last sequence is operating correctly but it will increment the error counter as the error handling isn't implemented in the GM

phase.drop_objection(this);
endtask

endclass //apb_master_test extends superClass

endpackage

