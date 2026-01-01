package apb_wrapper_sb_pkg;
import apb_wrapper_seqitem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh" 
class apb_wrapper_sb extends uvm_scoreboard;
`uvm_component_utils(apb_wrapper_sb)
apb_wrapper_seq_item seq_sb;
uvm_analysis_export #(apb_wrapper_seq_item) sb_export;
uvm_tlm_analysis_fifo #(apb_wrapper_seq_item) sb_fifo;    

int correct_cnt = 0;
int error_cnt = 0;
function new(string name = "apb_wrapper_sb", uvm_component parent = null); 
    super.new(name, parent);
endfunction //new()


function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb_export = new("sb_export", this);
    sb_fifo = new("sb_fifo", this);
endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    sb_export.connect(sb_fifo.analysis_export);
endfunction

task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever begin
    sb_fifo.get(seq_sb);    
    ref_check(seq_sb);  
    end
  
endtask

function void ref_check(apb_wrapper_seq_item chk_seq);
 bit en;

  if (!uvm_config_db#(bit)::get(this, "", "sb_enable", en)) begin
    // `uvm_fatal("ref_check", "Could not get sb_enable from uvm_config_db");
en = 1; // default
  end
  if (!en)
    return;
    if((chk_seq.PSEL != chk_seq.PSEL_gm) || (chk_seq.PENABLE != chk_seq.PENABLE_gm) || (chk_seq.PWRITE != chk_seq.PWRITE_gm) || (chk_seq.PADDR != chk_seq.PADDR_gm) || (chk_seq.PWDATA != chk_seq.PWDATA_gm) || (chk_seq.PREADY != chk_seq.PREADY_gm) /*|| (chk_seq.PSLVERR != chk_seq.PSLVERR_gm)  || (chk_seq.PRDATA != chk_seq.PRDATA_gm)*/ /*|| (chk_seq.BERR != chk_seq.BERR_gm) */ /*|| (chk_seq.BRDATA != chk_seq.BRDATA_gm)*/)
    begin
        `uvm_error("run_phase", $sformatf("Comparison failed, Transaction recieved by the DUT: %s While the ref PSEL_gm =%0b, PENABLE_gm = %0b, PWRITE_gm = %0b, PADDR_gm = %0h, PWDATA_gm = %0h, PREADY_gm = %0b, PSLVERR_gm = %0b, PRDATA_gm = %0h,  BRDATA_gm = %0h", 
        chk_seq.convert2string(), chk_seq.PSEL_gm, chk_seq.PENABLE_gm, chk_seq.PWRITE_gm, chk_seq.PADDR_gm, chk_seq.PWDATA_gm, chk_seq.PREADY_gm, chk_seq.PSLVERR_gm, chk_seq.PRDATA_gm,  chk_seq.BRDATA_gm));
        error_cnt = error_cnt + 1;
    end
    else begin
        `uvm_info("run_phase", $sformatf("Comparison Successed,Transaction recieved by the DUT: %sWhile the ref PSEL_gm =%0b, PENABLE_gm = %0b, PWRITE_gm = %0b, PADDR_gm = %0h, PWDATA_gm = %0h, PREADY_gm = %0b, PSLVERR_gm = %0b, BRDATA_gm = %0h", chk_seq.convert2string(), chk_seq.PSEL_gm, chk_seq.PENABLE_gm, chk_seq.PWRITE_gm, chk_seq.PADDR_gm, chk_seq.PWDATA_gm, chk_seq.PREADY_gm, chk_seq.PSLVERR_gm, chk_seq.BRDATA_gm), UVM_MEDIUM);
        correct_cnt = correct_cnt + 1;
    end
endfunction

function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("report_phase", $sformatf("Total successful transaction: %0d", correct_cnt), UVM_LOW);
    `uvm_info("report_phase", $sformatf("Total failed transaction: %0d", error_cnt), UVM_LOW);
endfunction
endclass //apb_wrapper_sb extends uvm_scoreboard
endpackage