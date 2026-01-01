module APB_Wrapper (
    input PCLK , PRESETn ,
    input SWRITE ,
    input [31:0] SADDR , SWDATA , 
    // input [3:0] SSTRB ,
    // input [2:0] SPROT  ,
    input transfer ,
    output [31:0] PRDATA 
);
wire PSEL , PENABLE , PWRITE ;
wire [31:0] PADDR , PWDATA ;
// wire [3:0] PSTRB ;
// wire [2:0] PPROT ;
wire PREADY , PSLVERR ;

//instantiating our master
APB_Master Master_gm (
    .PCLK (PCLK),
    .PRESETn(PRESETn),
    .SWRITE(SWRITE),
    .SADDR(SADDR),
    .SWDATA(SWDATA),
    .transfer(transfer),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    // .PSTRB(PSTRB),
    // .PPROT(PPROT),
    .PREADY(PREADY),
    .PSLVERR(PSLVERR)
);

//instantiating our slave
APB_Slave Slave_gm (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    // .PSTRB(PSTRB),
    // .PPROT(PPROT),
    .PREADY(PREADY),
    .PSLVERR(PSLVERR),
    .PRDATA(PRDATA)
);
endmodule