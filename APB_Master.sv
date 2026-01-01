module apb_master (PCLK, PRESETn, PADDR, PSEL, PENABLE, PWRITE, PWDATA, PREADY, PRDATA, PSLVERR, BADDR, BWRITE, BWDATA, start_transfer, BRDATA, BERR);
parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;
typedef enum  bit [1:0] {IDLE, SETUP, ACCESS} state_e;

//Defining port direction
 //Global Signals
    input PCLK, PRESETn;

 //Ports from external system
    input [ADDR_WIDTH-1:0] BADDR;
    input BWRITE,start_transfer;
    input [DATA_WIDTH-1:0] BWDATA;
    output reg [DATA_WIDTH-1:0] BRDATA;
    output reg BERR;

 //Ports from APB Slave
    input PREADY, PSLVERR;
    input [DATA_WIDTH-1:0] PRDATA;
    output reg [ADDR_WIDTH-1:0] PADDR;
    output reg PSEL, PENABLE, PWRITE;
    output reg [DATA_WIDTH-1:0] PWDATA;

//Defining States
state_e cs, ns;

//Registers for holding adderess and data signals
reg [ADDR_WIDTH-1:0] addr_reg;
reg [DATA_WIDTH-1:0] wdata_reg;
reg wr_reg;

//State Memory
    always @(posedge PCLK or negedge PRESETn)
    begin
        if(!PRESETn) 
            cs <= IDLE;
        else
            cs <= ns; 
    end

//Next State Logic
    always @(*) begin
        case (cs)
            IDLE: ns = (start_transfer)? SETUP: IDLE;
            SETUP: ns = ACCESS;
            ACCESS: ns = ((PREADY && !start_transfer) || (PSLVERR && PREADY))? IDLE: (PREADY && start_transfer)? SETUP: ACCESS;
            default: ns = IDLE; 
        endcase
    end

//Output Logic
    always @(*) begin
    PADDR   = addr_reg;
    PWRITE  = wr_reg;
    PWDATA  = wdata_reg;
    PSEL = 0;
    PENABLE = 0;
        case (cs)
            IDLE:  begin
                PSEL = 0;
                PENABLE = 0;
            end
            SETUP: begin
                PSEL = 1;
                PENABLE = 0;
            end
            ACCESS: begin
                PSEL = 1;
                PENABLE = 1;
            end
            default: begin
                PSEL = 0;
                PENABLE = 0;
            end
        endcase
    end

//register address, data, write enable for setup phase
always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
        addr_reg  <= 0;
        wdata_reg <= 0;
        wr_reg    <= 0;
    end else if ((cs == IDLE && start_transfer) || (cs == ACCESS && start_transfer && PREADY && ~PSLVERR) ) begin
        addr_reg  <= BADDR;
        wdata_reg <= BWDATA;
        wr_reg    <= BWRITE;
    end
end

// Capture read data and error at end of ACCESS  
always @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
        BRDATA  <= 0;
        BERR <= 0;
    end else if (cs == ACCESS && PREADY) begin
        BRDATA  <= PRDATA;
        BERR <= PSLVERR;
        end
        else 
        BERR <=0;
end


`ifdef SIM
//reset assertions
always_comb begin
    if (!PRESETn)
    begin
        data_from_slave_assertion: assert final (BRDATA == '0)
        else  $display("data_from_slave failed at t = %0t",$time);
        data_from_slave_cvr: cover final (BRDATA == '0);

        slverr_assertion: assert final (BERR == 0)
        else  $display("slverr_assertion failed at t = %0t",$time);
        slverr_cvr: cover final (BERR == 0);    
    end
end

//current state sequence assertion
property fsm_normal_flow;
@(posedge PCLK) disable iff (!PRESETn) ( PRESETn&& start_transfer && (cs == IDLE) |=> (cs == SETUP) ##1 (cs == ACCESS) )
endproperty
fsm_normal_flow_assert: assert property (fsm_normal_flow) else $display("fsm_normal_flow failed");
fsm_normal_flow_cover: cover property (fsm_normal_flow);

property fsm_with_no_wait;
@(posedge PCLK) disable iff (!PRESETn) (cs == ACCESS && PREADY && !start_transfer |=> cs == IDLE);
endproperty
fsm_with_no_wait_assertion: assert property(fsm_with_no_wait) else $display("fsm_with_no_wait failed");
fsm_with_no_wait_cover: cover property (fsm_with_no_wait);

property fsm_with_wait;
@(posedge PCLK) disable iff (!PRESETn) (cs == ACCESS && !PREADY |=> cs == ACCESS);
endproperty
fsm_with_wait_assertion: assert property (fsm_with_wait) else $display("fsm_with_wait failed");
fsm_with_wait_cover: cover property (fsm_with_wait);

property fsm_with_error;
@(posedge PCLK) disable iff (!PRESETn) (cs == ACCESS && PREADY && PSLVERR |=> cs == IDLE);
endproperty
fsm_with_error_assertion: assert property (fsm_with_error) else $display("fsm_with_error failed");
fsm_with_error_cover: cover property(fsm_with_error);

//PADDR, PWRITE, and PWDATA should be stable once PSEL gets high
property stable_signals;
@(posedge PCLK) disable iff (!PRESETn) (PSEL && !PREADY|=> $stable(PADDR) && $stable(PWRITE) && $stable(PWDATA)) ;
endproperty
stable_signals_assertion: assert property (stable_signals) else $display("stable_signals failed");
stable_signals_cover: cover property(stable_signals);

//PSEL and PENABLE assertions
property PSEL_PENABLE_high;
@(posedge PCLK) disable iff (!PRESETn) (cs == IDLE && start_transfer && PRESETn |-> ##1 $rose(PSEL) ##1 $rose(PENABLE));
endproperty
PSEL_PENABLE_assertion: assert property (PSEL_PENABLE_high) else $display("PSEL_PENABLE_high failed");
PSEL_PENABLE_cover: cover property(PSEL_PENABLE_high);

property PSEL_PENABLE_low;
@(posedge PCLK) disable iff (!PRESETn) (cs == ACCESS && ((PREADY && PSLVERR) || PREADY) && !start_transfer |=> $fell(PENABLE) && $fell(PSEL));
endproperty
PSEL_PENABLE_low_assertion: assert property (PSEL_PENABLE_low) else $display("PSEL_PENABLE_low failed");
PSEL_PENABLE_low_cover: cover property (PSEL_PENABLE_low);

property PSEL_high_PENABLE_low;
@(posedge PCLK) disable iff (!PRESETn) (cs == ACCESS && (PREADY) && start_transfer && (!PSLVERR) |=> $fell(PENABLE) && (PSEL));
endproperty
PSEL_high_PENABLE_low_assertion: assert property (PSEL_high_PENABLE_low) else $display("PSEL_high_PENABLE_low failed");
PSEL_high_PENABLE_low_cover: cover property (PSEL_high_PENABLE_low);

`endif 

endmodule

