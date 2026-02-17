`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "reference.sv"
`include "scoreboard.sv"

class enivornment;
  generator gen;
  driver drv;
  monitor mon;
  reference reff;
  scoreboard scb;
  
  mailbox gen2drv;
  mailbox drv2scb;
  mailbox drv2rm;
  mailbox mon2scb;
  mailbox rm2scb;
  
  virtual intf vif;
  
  function new(virtual intf vif);
    this.vif=vif;
    gen2drv=new();
    drv2scb=new();
    drv2rm=new();
    mon2scb=new();
    rm2scb=new();
    
    gen=new(gen2drv);
    drv=new(vif,gen2drv,drv2scb,drv2rm);
    mon=new(vif,mon2scb);
    reff=new(drv2rm,rm2scb);
    scb=new(rm2scb,mon2scb);
  endfunction
  
  task run();
    fork
      gen.main();
      drv.main();
      mon.main();
      reff.main();
      scb.main();
    join
  endtask
endclass
