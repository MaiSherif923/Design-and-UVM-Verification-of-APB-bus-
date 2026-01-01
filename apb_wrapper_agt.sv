package apb_wrapper_agt_pkg;
import apb_wrapper_cfg::*;
import apb_wrapper_sqr_pkg::*;
import apb_wrapper_drv_pkg::*;
import apb_wrapper_seqitem_pkg::*;
import apb_wrapper_mon_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh" 
class apb_wrapper_agt extends uvm_agent;
    `uvm_component_utils(apb_wrapper_agt)
    apb_wrapper_drv apb_wrapper_driver;
    apb_wrapper_cfg apb_wrapper_config;
    apb_wrapper_sqr apb_wrapper_seqr;
    apb_wrapper_mon apb_wrapper_monitor;
    uvm_analysis_port #(apb_wrapper_seq_item) agt_ap;
function new(string name = "apb_wrapper_agt", uvm_component parent = null);
    super.new(name, parent);        
endfunction //new()

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(apb_wrapper_cfg)::get(this,"","WRAPPER_CFG",apb_wrapper_config ))
        `uvm_fatal("Build phase","Unable to get config object")
    if(apb_wrapper_config.mode == UVM_ACTIVE) begin
        apb_wrapper_seqr = apb_wrapper_sqr::type_id::create("apb_wrapper_seqr", this);
        apb_wrapper_driver = apb_wrapper_drv::type_id::create("apb_wrapper_drv",this);
    end
  apb_wrapper_monitor = apb_wrapper_mon::type_id::create("apb_wrapper_monitor", this);
 agt_ap = new("agt_ap", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if ( apb_wrapper_config.mode == UVM_ACTIVE)
    begin
        apb_wrapper_driver.drv_wrapper_if = apb_wrapper_config.cfg_wrapper_if;
        apb_wrapper_driver.seq_item_port.connect(apb_wrapper_seqr.seq_item_export);
    end
    apb_wrapper_monitor.mon_wrapper_if = apb_wrapper_config.cfg_wrapper_if;
    apb_wrapper_monitor.mon_ap.connect(agt_ap);
endfunction


endclass //apb_wrapper_agt extends uvm_agent

endpackage