interface intf(input clk);
  bit wen,clr_rdy,rst;
  bit [7:0] datain;
  bit busy,ready;
  bit [7:0] dataout;
  
  clocking drvcb @(posedge clk);
    output wen,clr_rdy,rst,datain;
    input busy,ready,dataout;
  endclocking
  
  clocking moncb @(posedge clk);
    input wen,clr_rdy,rst,datain;
    input busy,ready,dataout;
  endclocking
  
  modport drvmod(clocking drvcb,input clk);
    modport monmod(clocking moncb,input clk);
endinterface  
