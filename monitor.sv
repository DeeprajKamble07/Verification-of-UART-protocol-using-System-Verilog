class monitor;
  virtual intf.monmod vif;
  mailbox mon2scb;
  transaction trans;
  
  function new(virtual intf.monmod vif, mailbox mon2scb);
    this.vif=vif;
    this.mon2scb=mon2scb;
  endfunction
  
  task main();
    forever begin
      wait(vif.moncb.ready==1);
      trans=new();
      trans.dataout=vif.moncb.dataout;
      trans.ready=vif.moncb.ready;
      trans.busy=vif.moncb.busy;
      trans.display("MON");
      mon2scb.put(trans);
      wait(vif.moncb.ready == 0);
    end
  endtask
endclass
