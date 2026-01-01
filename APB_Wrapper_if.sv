import shared_pkg::*;
interface apb_wrapper_if(PCLK);
//Global Ports
input PCLK;
logic PRESETn;

//Master Ports "from external system" apb bridge for example
logic [ADDR_WIDTH-1:0] BADDR;
logic BWRITE, start_transfer;
logic [DATA_WIDTH-1:0] BWDATA;
logic [DATA_WIDTH-1:0] BRDATA;
logic BERR;

//Signals from golden model
logic [DATA_WIDTH-1:0] BRDATA_gm;
// logic BERR_gm;
// logic [3:0] SSTRB;
// logic [2:0] SPROT;

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
// logic [DATA_WIDTH-1:0] PRDATA_gm;

endinterface //apb_wrapper_if
