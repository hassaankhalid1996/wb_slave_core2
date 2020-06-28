
class scoreboard;
	int no_of_errors;
	mailbox mon2scb;
	mailbox gen2scb;
    int transaction_count;	//transaction counter
	transaction gtrans,mtrans;
	bit [32:0] mem[16];
	function new(mailbox mon2scb,mailbox gen2scb);
		this.mon2scb = mon2scb;
		this.gen2scb = gen2scb;
	endfunction
    task collect;
		repeat (transaction_count) begin
			gen2scb.get(gtrans);
			if(gtrans.wr_i) 
            mem[gtrans.adr_i] = gtrans.dat_i;
			end
			
	task main;
		repeat (transaction_count) begin
		mon2scb.get(mtrans);
		if(!mtrans.wr_i) begin
			if(mem[gtrans.adr_i] != mtrans.dat_i); 
            $error("[SCB-FAIL] Addr = %0h,\n\t Data :: Expected = %0h Actual = %0h",gtrans.adr_i,mem[gtrans.adr_i],mtrans.dat_i);
        else 
          $display("[SCB-PASS] Addr = %0h,\n \tData :: Expected = %0h Actual = %0h",gtrans.adr_i,mem[gtrans.adr_i],mtrans.dat_i);
      end
	endtask
    task run;
	fork 
	collect;
	main;'
	join
    end
endclass



