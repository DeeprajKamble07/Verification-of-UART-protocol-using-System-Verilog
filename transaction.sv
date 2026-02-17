class transaction;
  rand bit wen,clr_rdy;
  rand bit [7:0] datain;
  bit busy,ready;
  bit [7:0] dataout;
  
  function void display(string name);
    $display("[%0s] wen=%0b clr_rdy=%0b datain=%0h busy=%0b ready=%0b dataout=%0h",name,wen,clr_rdy,datain,busy,ready,dataout);
  endfunction
endclass
