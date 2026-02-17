class reference;
  transaction trans,exp;
  mailbox drv2rm;
  mailbox rm2scb;
  
  function new(mailbox drv2rm,mailbox rm2scb);
    this.drv2rm=drv2rm;
    this.rm2scb=rm2scb;
  endfunction
  
  task main();
    trans=new();
    exp=new();
    forever begin
      drv2rm.get(trans);
      exp.dataout = trans.datain; 
      rm2scb.put(exp);
    end
  endtask 
endclass
