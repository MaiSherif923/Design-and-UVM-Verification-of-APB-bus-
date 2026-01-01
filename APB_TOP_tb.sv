module top_tb;
parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;
typedef enum bit [2:0] {Normal_op, wait_read, wait_write, error_t} test;
test tests;
//Global inputs
bit PCLK, PRESETn;

//Master Ports;
bit [ADDR_WIDTH-1:0] addr_m;
bit wr_en_m, start_transfer;
bit [DATA_WIDTH-1:0] wrdata_m;
logic [DATA_WIDTH-1:0] rdata_m;
logic slverr;

bit valid, error;
bit [ADDR_WIDTH-1:0] addr_s;
logic [DATA_WIDTH-1:0] rdata_s;
logic wr_en_s;
logic [DATA_WIDTH-1:0] wrdata_s;
logic sel;


//DUT Instantiation
 APB_TOP DUT (PCLK, PRESETn, addr_m, wr_en_m, wrdata_m, start_transfer, rdata_m, slverr, valid, error, addr_s, rdata_s, wr_en_s, wrdata_s, sel);

//Clock Generation
initial begin
    PCLK = 0;
    forever #5 PCLK = ~ PCLK;
end

//Stimulus generation
initial begin
reset;
//normal operation
tests = Normal_op;
wr_en_m = 1;
start_transfer = 1;
addr_m = { (ADDR_WIDTH-5)'(0), 3'd1, 2'b00 };

wrdata_m = $random;
@(negedge PCLK);
valid=1;
start_transfer = 0;
repeat(3) @(negedge PCLK);

//error test
tests = error_t;
wr_en_m = 0;
valid =0;
start_transfer = 1;
addr_m = { {(ADDR_WIDTH-5){1'b1}}, 3'd1, 2'b01 };

wrdata_m = $random;
rdata_s = $random;
@(negedge PCLK);
start_transfer = 0;
 @(negedge PCLK);
 valid=1;
repeat(2) @(negedge PCLK);

wr_en_m = 1;
start_transfer = 1;
addr_m = { {(ADDR_WIDTH-5){1'b1}}, 3'd1, 2'b00 };

wrdata_m = $random;
@(negedge PCLK);
start_transfer = 0;
repeat(3) @(negedge PCLK);
/*
tests = Normal_op;
start_transfer = 1;
@(negedge PCLK);
start_transfer = 0;
repeat(2) @(negedge PCLK);
start_transfer = 1;

@(negedge PCLK);
start_transfer = 0;
@(negedge PCLK);
@(negedge PCLK);

//wait read
tests = wait_read;
start_transfer = 1;
addr_m = {4,2'b00};
@(negedge PCLK);
start_transfer = 0;
@(negedge PCLK);
@(negedge PCLK);

repeat(2) @(negedge PCLK);

//wait write 
tests = wait_write;
start_transfer = 1;
wrdata_m = $random;
wr_en_m =1;
@(negedge PCLK);
start_transfer = 0;
@(negedge PCLK);
@(negedge PCLK);
repeat(2) @(negedge PCLK);

//error
tests = error_t;
start_transfer = 1;
wrdata_m = $random;
wr_en_m =1;
@(negedge PCLK);
start_transfer = 0;
@(negedge PCLK);
@(negedge PCLK);
valid =1;
error=1;
repeat(2) @(negedge PCLK);
//wait after error
tests = wait_write;
start_transfer = 1;
wrdata_m = $random;
wr_en_m =1;
@(negedge PCLK);
start_transfer = 0;
@(negedge PCLK);
@(negedge PCLK);
valid =1;
repeat(2) @(negedge PCLK);
*/
$stop;
end

task reset;
    PRESETn = 0;
    addr_m = 0;
    wr_en_m = 0;
    wrdata_m = $random;
    start_transfer = 0;
    @(negedge PCLK);
    PRESETn = 1;
endtask 

endmodule