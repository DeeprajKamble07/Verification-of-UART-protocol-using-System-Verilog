class driver;
  virtual intf.drvmod vif;
  mailbox gen2drv;
  mailbox drv2scb;
  mailbox drv2rm;
  transaction trans;
  
  function new(virtual intf.drvmod vif,mailbox gen2drv,mailbox drv2scb,mailbox drv2rm);
    this.vif=vif;
    this.gen2drv=gen2drv;
    this.drv2scb=drv2scb;
    this.drv2rm=drv2rm;
  endfunction
  
  task rst_phase();
    vif.drvcb.rst<=1;
    vif.drvcb.wen<=0;
    vif.drvcb.clr_rdy<=0;
    repeat(5) @(posedge vif.clk);
    vif.drvcb.rst<=0;
  endtask
  
  task main();
    rst_phase();
    forever begin
      gen2drv.get(trans);
      send(trans);
      drv2scb.put(trans);
      drv2rm.put(trans);
    end
  endtask
  
  task send(transaction trans);
  @(posedge vif.clk);
  vif.drvcb.datain <= trans.datain;
  vif.drvcb.wen    <= 1;

  @(posedge vif.clk);
  vif.drvcb.wen <= 0;

  wait(vif.drvcb.busy);     
  wait(vif.drvcb.ready);    

  trans.display("DRV");

  @(posedge vif.clk);
  vif.drvcb.clr_rdy <= 1;
  @(posedge vif.clk);
  vif.drvcb.clr_rdy <= 0;
endtask

endclass
