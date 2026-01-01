import shared_pkg::*;
interface apb_master_if(PCLK);
 //Global siganls
    input PCLK;
    logic PRESETn;
 //Ports from external system
    logic [ADDR_WIDTH-1:0] addr;
    logic wr,start_transfer;
    logic [DATA_WIDTH-1:0] wdata;
    logic [DATA_WIDTH-1:0] rdata;
    logic slverr;

 //Ports from APB Slave
    logic PREADY, PSLVERR;
    logic [DATA_WIDTH-1:0] PRDATA;
    logic [ADDR_WIDTH-1:0] PADDR;
    logic PSEL, PENABLE, PWRITE;
    logic [DATA_WIDTH-1:0] PWDATA;

 //Output Ports from the golden model
    logic gm_PSEL, gm_PENABLE, gm_PWRITE;
    logic [ADDR_WIDTH-1:0] gm_PADDR;
    logic [DATA_WIDTH-1:0] gm_PWDATA;
endinterface //apb_master_if