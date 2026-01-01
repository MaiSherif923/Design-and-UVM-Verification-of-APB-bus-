module apb_slave (PCLK, PRESETn, PADDR, PSEL, PENABLE, PWRITE, PWDATA, PREADY, PRDATA, PSLVERR);
parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;
parameter MEM_DEPTH = 1024;
typedef enum  bit [1:0] {SETUP, ACCESS, ERROR} state_e;

//Defining port direction
input PCLK, PRESETn;
input [ADDR_WIDTH-1:0] PADDR;
input PSEL, PENABLE, PWRITE;
input [DATA_WIDTH-1:0] PWDATA;
//input [STB_WIDTH-1:0] PSTRB;
output reg PREADY, PSLVERR;
output reg [DATA_WIDTH-1:0] PRDATA;

wire error;

//Defining States
state_e cs, ns;

//memory slave
reg [DATA_WIDTH-1:0] mem [MEM_DEPTH-1:0];

assign error = (PADDR >= MEM_DEPTH);

//State Memory
always @(posedge PCLK or negedge PRESETn)
begin
    if( !PRESETn ) 
        cs <= SETUP;
    else
        cs <= ns; 
end

//Next State Logic
always @(*) begin
    case (cs)
        SETUP: begin
          if(PSEL && PENABLE && error)
            ns = ERROR;
          else if (PSEL && PENABLE && !error) 
            ns = ACCESS;
          else
            ns = SETUP;
        end      
        ACCESS: begin
              ns = SETUP;
            end
        ERROR: begin
              ns = SETUP;
       
        end
       default: ns = SETUP;
    endcase
end
/*
//output logic
always @(*) begin
    case (cs)
      SETUP: begin
          if(PENABLE && !error)
          begin 
            PREADY = 1;
            PSLVERR = 0;
          end  
          else begin
            PREADY = 0;
            PSLVERR = 0;      
      end
      end
      ACCESS: begin
            PREADY = 1;
            PSLVERR = 0;
              end
      ERROR: begin
            PREADY = 1;
            PSLVERR = 1;
            end
      default: begin
        PREADY = 0;
        PSLVERR = 0;
      end
    endcase
end
*/

always @(*) begin
  if(error && cs == ERROR && PENABLE) begin
    PREADY = 1;
    PSLVERR = 1;
  end
  else if (!error && cs == SETUP && PENABLE) begin
    PREADY = 1;
    PSLVERR = 0;
  end
  else begin
    PREADY = 0;
    PSLVERR = 0;
  end
end

always @(posedge PCLK or negedge PRESETn) begin
  if(!PRESETn) begin
    PRDATA <= '0;
  end
  else if (PSEL && cs == SETUP && !error) //PSEL only as we will go to the ACCESS state next cycle
  begin
   if(PWRITE)
    mem[PADDR] <= PWDATA;
   else
    PRDATA <= mem[PADDR];
  end    
end


endmodule