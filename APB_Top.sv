module APB_TOP(PCLK, PRESETn, BADDR, BWRITE, BWDATA, start_transfer, BRDATA, BERR);
parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;

//Global inputs
input PCLK, PRESETn;

//Master Ports;
input [ADDR_WIDTH-1:0] BADDR;
input BWRITE, start_transfer;
input [DATA_WIDTH-1:0] BWDATA;
output [DATA_WIDTH-1:0] BRDATA;
output BERR;

 //internal signals between master and slave
logic [ADDR_WIDTH-1:0] PADDR;
logic PSEL, PENABLE, PWRITE;
logic [DATA_WIDTH-1:0] PWDATA;
logic PREADY, PSLVERR;
logic [DATA_WIDTH-1:0] PRDATA;

//Master Instant
apb_master master_dut (PCLK, PRESETn, PADDR, PSEL, PENABLE, PWRITE, PWDATA, PREADY, PRDATA, PSLVERR, BADDR, BWRITE, BWDATA, start_transfer, BRDATA, BERR);

//Slave Instant
apb_slave slave_dut (PCLK, PRESETn, PADDR, PSEL, PENABLE, PWRITE, PWDATA, PREADY, PRDATA, PSLVERR);

endmodule