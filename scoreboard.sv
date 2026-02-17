class scoreboard;
  transaction act,exp;
  mailbox rm2scb;
  mailbox mon2scb;
  bit [7:0] act_data,exp_data;
  function new(mailbox rm2scb,mailbox mon2scb);
    this.rm2scb=rm2scb;
    this.mon2scb=mon2scb;
  endfunction
  
  task main();
    forever begin
      fork
        rm2scb.get(exp);
        mon2scb.get(act);
      join
      
      act_data=act.dataout;
        exp_data=exp.dataout; 
      if(act_data==exp_data)
        act.display("Comparison Sucess");
      else
        act.display("Comparison Failure");
    end
  endtask
endclass
