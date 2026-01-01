package apb_wrapper_env_pkg;
import apb_wrapper_agt_pkg::*;
import apb_wrapper_cov_col_pkg::*;
import apb_wrapper_sb_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh" 
class apb_wrapper_env extends uvm_env;
 `uvm_component_utils(apb_wrapper_env)
  apb_wrapper_agt wrapper_agt;
  apb_wrapper_sb wrapper_sb;
  apb_wrapper_cov_col wrapper_cov;
    function new(string name = "apb_wrapper_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wrapper_agt = apb_wrapper_agt::type_id::create("wrapper_agt", this);
        wrapper_sb = apb_wrapper_sb::type_id::create("wrapper_sb", this);
        wrapper_cov = apb_wrapper_cov_col::type_id::create("wrapper_cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        wrapper_agt.agt_ap.connect(wrapper_sb.sb_export);
        wrapper_agt.agt_ap.connect(wrapper_cov.cov_export);
    endfunction
endclass //apb_wrapper_env extends uvm_env    
endpackage