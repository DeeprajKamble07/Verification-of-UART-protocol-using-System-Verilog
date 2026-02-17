module br_gen #(parameter clk_freq=5000000, braud_rate=9600)
  (input clk,rst,output reg tx_en,rx_en);
  
  integer tx_count;
  integer rx_count;
  
  localparam integer tx_div=clk_freq/braud_rate;
  localparam integer rx_div=clk_freq/(braud_rate*16);
  
  always@(posedge clk)
    begin
      if(rst)
        begin
          tx_en<=0;
          rx_en<=0;
          tx_count<=0;
          rx_count<=0;
        end
      
      else
        begin
          
          if(tx_count==tx_div-1)
            begin
              tx_en<=1;
              tx_count<=0;
            end
          else
            begin
              tx_count<=tx_count+1;
              tx_en<=0;
            end
          
          if(rx_count==rx_div-1)
            begin
              rx_en<=1;
              rx_count<=0;
            end
          else
            begin
              rx_count<=rx_count+1;
              rx_en<=0;
            end
        end
    end
endmodule

module uart_tx(input clk,rst,wen,tx_en,input [7:0] datain, output reg tx, output busy);
  
  typedef enum logic [1:0] {idle,start,data,stop} state_t;
  state_t state;
  
  reg [7:0] tx_reg;
  reg [2:0] index;
  
  always@(posedge clk)
    begin
      if(rst)
        begin
          tx<=1'b1;
          tx_reg<=0;
          index<=0;
          state<=idle;
        end
      
      else
        begin
          case(state)
            idle: begin
              tx<=1'b1;
              if(wen)
                begin
                  tx_reg<=datain;
                  index<=0;
                  state<=start;
                end
            end
            
            start: begin
              if(tx_en)
                begin
                  tx<=1'b0;
                  state<=data;
                end
            end
            
            data: begin
              if(tx_en)
                begin
                  tx<=tx_reg[index];
                  if(index==7)
                    begin
                      state<=stop;
                    end
                  else
                    begin
                      index<=index+1;
                    end
                end
            end
            
            stop: begin
              if(tx_en)
                begin
                  tx<=1'b1;
                  state<=idle;
                end
            end
          endcase
        end
    end
  
  assign busy=(state!=idle)? 1'b1:1'b0;
endmodule

module uart_rx(input clk,rst,rx_en,clr_rdy,rx, output reg [7:0] dataout, output reg ready);
  
  reg [3:0] sample;
  reg [2:0] index;
  reg [7:0] rx_reg;
  
  typedef enum logic [1:0] {idle,start,data,stop} state_t;
  state_t state;
  
  always@(posedge clk)
    begin
      if(rst)
        begin
          dataout<=0;
          ready<=0;
          sample<=0;
          index<=0;
          rx_reg<=0;
          state<=idle;
        end
      
      else
        begin
          
          if(clr_rdy)
            begin
              ready<=0;
            end
          
          if(rx_en)
            begin
              case(state)
                idle: begin
                  if(rx==0)
                    begin
                      sample<=0;
                      state<=start;
                    end
                end
                
                start: begin
                  sample<=sample+1;
                  if(sample==7)
                    begin
                      if(rx==0)
                        begin
                          sample<=0;
                          index<=0;
                          state<=data;
                        end
                      else
                        state<=idle;
                    end
                end
                
                data: begin
                  sample<=sample+1;
                  if(sample==15)
                    begin
                      rx_reg[index]<=rx;
                      sample<=0;
                      if(index==7)
                      state<=stop;
                      else
                        index<=index+1;
                    end
                end
                
                stop: begin
                  sample<=sample+1;
                  if(sample==15)
                    begin
                      dataout<=rx_reg;
                      ready<=1;
                      state<=idle;
                    end
                end
              endcase
            end
        end
    end
endmodule


module uart_top(input clk,rst,wen,clr_rdy,input [7:0] datain, output busy,ready,output [7:0] dataout);
  
  wire tx_en,rx_en, tx_line;
  
  br_gen #(5000000,9600) a1(.clk(clk),.rst(rst),.tx_en(tx_en),.rx_en(rx_en));
  uart_tx a2(.clk(clk),.rst(rst),.wen(wen),.tx_en(tx_en),.datain(datain),.tx(tx_line),.busy(busy));
  uart_rx a3(.clk(clk),.rst(rst),.rx_en(rx_en),.clr_rdy(clr_rdy),.rx(tx_line),.dataout(dataout),.ready(ready));
endmodule
                      
