package apb_wrapper_seqitem_pkg;
import apb_wrapper_cfg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh" 
class apb_wrapper_seq_item extends uvm_sequence_item;
    `uvm_object_utils(apb_wrapper_seq_item)

    rand logic PRESETn;
 //Master Ports "from external system" apb bridge for example 
    rand logic [ADDR_WIDTH-1:0] BADDR;
    rand logic BWRITE, start_transfer;
    rand logic [DATA_WIDTH-1:0] BWDATA;
    logic [DATA_WIDTH-1:0] BRDATA;
    logic BERR;

 //Signals from golden model
    logic [DATA_WIDTH-1:0] BRDATA_gm;
    logic BERR_gm;
    logic [3:0] SSTRB;
    logic [2:0] SPROT;

//DUT internal Signals
logic [ADDR_WIDTH-1:0] PADDR;
logic PSEL, PENABLE, PWRITE;
logic [DATA_WIDTH-1:0] PWDATA;
logic PREADY, PSLVERR;
logic [DATA_WIDTH-1:0] PRDATA;

//GM internal Signals
logic [ADDR_WIDTH-1:0] PADDR_gm;
logic PSEL_gm, PENABLE_gm, PWRITE_gm;
logic [DATA_WIDTH-1:0] PWDATA_gm;
logic PREADY_gm, PSLVERR_gm;
logic [DATA_WIDTH-1:0] PRDATA_gm;


//  counter to count number of cycles of one transfer
    int cntr;   

   constraint reset_ct {PRESETn dist {1:=98, 0:=2};}
   constraint start_transfer_ct {
    if (cntr == 0 && PRESETn) 
        start_transfer == 1;
    else 
        start_transfer == 0;
            }

    constraint write_ct {
        if (cntr == 0) 
            BWRITE == 1; 
        else 
            BWRITE == 0;
    }
    constraint read_ct {
       if (cntr == 0) 
        soft BWRITE == 0; 
        else 
        soft BWRITE == 1;
    }

// constraint SSTRB_ct {if(!BWRITE) SSTRB == 4'b0000; else SSTRB == 4'b1111;}
// constraint SPROT_ct {SPROT == 3'b000;}
constraint addr_ct_with_err {soft BADDR dist {[0:1024] := 90, [1025:$] := 10};}
constraint addr_ct {BADDR dist {[0:1024] := 100, [1025:$] := 0};}

constraint new_trasfere {
    if (cntr == 0 && PRESETn) {
    soft start_transfer == 1;

    }
    else if (cntr ==1 ){
    soft start_transfer == 0;
    
    }
else if (cntr >1) {
    
    soft start_transfer == $random;
}
else {
    
    soft start_transfer == 0;
}
}
    

    function void post_randomize();
        if (cntr == 3 || !PRESETn)
            cntr = 0;
        else
            cntr = cntr + 1;    
    endfunction

    function new(string name = "apb_wrapper_seq_item");
        super.new(name);
    endfunction 

    function string convert2string();
        return $sformatf ("%s PRESETn = %0d, BADDR = %0h, BWRITE = %0b, start_transfer = %0b, BWDATA = %0h, BRDATA = %0h, BERR = %0b, PSLVERR = %0b",
        super.convert2string(),PRESETn, BADDR, BWRITE, start_transfer, BWDATA, BRDATA, BERR, PSLVERR);
    endfunction

    function string convert2string_dut_internal();
        return $sformatf ("%s PADDR = %0h, PSEL = %0b, PENABLE = %0b, PWRITE = %0b, PWDATA = %0h, PREADY = %0b, PSLVERR = %0b, PRDATA = %0h",
        super.convert2string(),PADDR, PSEL, PENABLE, PWRITE, PWDATA, PREADY, PSLVERR, PRDATA);
    endfunction

    function string convert2string_gm_internal();
         return $sformatf ("%s PADDR_gm = %0h, PSEL_gm = %0b, PENABLE_gm = %0b, PWRITE_gm = %0b, PWDATA_gm = %0h, PREADY_gm = %0b, PSLVERR_gm = %0b, PRDATA_gm = %0h",
        super.convert2string(),PADDR_gm, PSEL_gm, PENABLE_gm, PWRITE_gm, PWDATA_gm, PREADY_gm, PSLVERR_gm, PRDATA_gm);  
    endfunction
endclass 
endpackage