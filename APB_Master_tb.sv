module master_tb;
parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;
typedef enum  bit [1:0] {IDLE, SETUP, ACCESS} state_e;

//Defining port direction
 //Global Signals
    bit PCLK, PRESETn;

 //Ports from external system
    bit [ADDR_WIDTH-1:0] addr;
    bit wr,start_transfer;
    bit [DATA_WIDTH-1:0] wdata;
    logic [DATA_WIDTH-1:0] rdata;
    logic slverr;

 //Ports from APB Slave
    bit PREADY, PSLVERR;
    bit [DATA_WIDTH-1:0] PRDATA;
    logic [ADDR_WIDTH-1:0] PADDR;
    logic PSEL, PENABLE, PWRITE;
    logic [DATA_WIDTH-1:0] PWDATA;

//DUT Instantation
 apb_master dut(.*);

//Clock Generation
initial begin
    PCLK = 0;
    forever begin
        #5 PCLK = ~PCLK;
    end
end

//Stimulus Generation
initial begin
    PRESETn = 0;
    @(negedge PCLK);
    PRESETn = 1;
    //normal operation
    start_transfer = 1;
    @(negedge PCLK);
    start_transfer = 0;
    @(negedge PCLK);
    PREADY = 1;
    @(negedge PCLK);
    //wait
    start_transfer = 1;
    @(negedge PCLK);
    start_transfer = 0;
    PREADY = 0;
    repeat(3)@(negedge PCLK);
    PREADY = 1;
    @(negedge PCLK);

    //error state
    start_transfer = 1;
    @(negedge PCLK);
    start_transfer = 0;
    @(negedge PCLK);
    PREADY = 1;
    PSLVERR =1;
    @(negedge PCLK);
    PSLVERR=0;
    //new transfere
    start_transfer = 1;
    @(negedge PCLK);
    start_transfer = 0;
    @(negedge PCLK);
    PREADY = 1;
    start_transfer = 1;
    @(negedge PCLK);

    //Wait


$stop;
end

initial begin
    forever begin
        addr = $random;
        wr = $random;
        wdata = $random;
        PRDATA = $random;
        @(negedge PCLK);
    end

end

endmodule