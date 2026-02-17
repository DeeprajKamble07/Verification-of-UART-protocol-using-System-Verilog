
`timescale 1ns/1ns
`include "interface.sv"
`include "test.sv"

module tb;
  logic clk;
  intf intff(clk);
  test tst(intff);
  
 uart_top dut(.clk(intff.clk),.rst(intff.rst),.wen(intff.wen),.clr_rdy(intff.clr_rdy),.datain(intff.datain),.busy(intff.busy),.ready(intff.ready),.dataout(intff.dataout));
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    #500000 $finish;
  end
  
  initial begin
    $dumpfile("dummp.vcd");
    $dumpvars();
  end
endmodule
