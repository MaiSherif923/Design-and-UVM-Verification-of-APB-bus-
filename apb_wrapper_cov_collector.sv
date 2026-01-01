package apb_wrapper_cov_col_pkg;
import apb_wrapper_seqitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh" 
class apb_wrapper_cov_col extends uvm_component;
`uvm_component_utils(apb_wrapper_cov_col)
apb_wrapper_seq_item seq_cov;
uvm_analysis_export #(apb_wrapper_seq_item) cov_export;
uvm_tlm_analysis_fifo #(apb_wrapper_seq_item) cov_fifo;  
covergroup apb_wrapper_cov_gp;
PSEL_ct:coverpoint seq_cov.PSEL {
bins one = {1};
bins zero = {0};
bins seq_no_wait = (0 => 1[*2] => 0);
bins seq_wait = (0 => 1[*3:6] => 0);
}

PENABLE_ct:coverpoint seq_cov.PENABLE {
bins one = {1};
bins zero = {0};
bins seq_no_wait = (0[*2] => 1 => 0);
bins seq_wait = (0[*2] => 1[*2:6] => 0);
}

PWRITE_ct:coverpoint seq_cov.PWRITE;
wr_ct:coverpoint seq_cov.BWRITE;
PRESETn_ct: coverpoint seq_cov.PRESETn;
start_transfer_ct:coverpoint seq_cov.start_transfer;
slverr_ct:coverpoint seq_cov.BERR;
PREADY_ct:coverpoint seq_cov.PREADY{
bins one = {1};
bins zero = {0};
bins seq = (0 => 1 => 0);
}
PSLVERR_ct:coverpoint seq_cov.PSLVERR{
bins one = {1};
bins zero = {0};
bins seq = (0 => 1 => 0);
}
endgroup

function new(string name = "apb_wrapper_cov_col", uvm_component parent = null); 
    super.new(name, parent);
    apb_wrapper_cov_gp = new();
endfunction //new()

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    cov_export = new("cov_export", this);
    cov_fifo = new("cov_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        cov_fifo.get(seq_cov);
        apb_wrapper_cov_gp.sample();
    end
endtask
endclass //apb_wrapper_cov_col extends uvm_component
endpackage