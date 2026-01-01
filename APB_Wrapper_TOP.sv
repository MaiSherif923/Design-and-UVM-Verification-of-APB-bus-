import apb_wrapper_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module APB_TOP_tb;
bit PCLK;

//Clock Generation
initial begin
    PCLK = 0;
    forever begin
        #1 PCLK = ~PCLK;
    end
end

//instantiations
apb_wrapper_if wrapper_if (PCLK);
APB_TOP DUT (wrapper_if.PCLK, wrapper_if.PRESETn, wrapper_if.BADDR, wrapper_if.BWRITE, wrapper_if.BWDATA, wrapper_if.start_transfer, wrapper_if.BRDATA, wrapper_if.BERR);
APB_Wrapper GM (wrapper_if.PCLK , wrapper_if.PRESETn , wrapper_if.BWRITE , wrapper_if.BADDR , wrapper_if.BWDATA /*, wrapper_if.SSTRB , wrapper_if.SPROT */ , wrapper_if.start_transfer , wrapper_if.BRDATA_gm);

assign wrapper_if.PADDR = DUT.PADDR;
assign wrapper_if.PSEL = DUT.PSEL;
assign wrapper_if.PENABLE = DUT.PENABLE;
assign wrapper_if.PWRITE = DUT.PWRITE;
assign wrapper_if.PWDATA = DUT.PWDATA;
assign wrapper_if.PREADY = DUT.PREADY;
assign wrapper_if.PSLVERR = DUT.PSLVERR;
assign wrapper_if.PRDATA = DUT.PRDATA;

assign wrapper_if.PADDR_gm = GM.PADDR;
assign wrapper_if.PSEL_gm = GM.PSEL;
assign wrapper_if.PENABLE_gm = GM.PENABLE;
assign wrapper_if.PWRITE_gm = GM.PWRITE;
assign wrapper_if.PWDATA_gm = GM.PWDATA;
assign wrapper_if.PREADY_gm = GM.PREADY;
assign wrapper_if.PSLVERR_gm = GM.PSLVERR;

//run_test
initial begin
    uvm_config_db #(virtual apb_wrapper_if)::set(null, "uvm_test_top", "WRAPPER_IF", wrapper_if);
    run_test("apb_wrapper_test");
end 
endmodule