import shared_pkg::*;
interface apb_slave_if(PCLK);
input PCLK;
logic PRESETn;
logic [ADDR_WIDTH-1:0] PADDR;
logic PSEL, PENABLE, PWRITE, valid, error;
logic [DATA_WIDTH-1:0] PWDATA, rddata;

logic [ADDR_WIDTH-1:0] addr;
logic PREADY, PSLVERR, wren;
logic [DATA_WIDTH-1:0] PRDATA, wrdata;
logic sel;

endinterface //apb_slave_if