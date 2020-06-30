
class scoreboard;
	//int no_of_errors;
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
			if(gtrans.write_enable) 
            		mem[gtrans.address] = gtrans.data_in;
	end
	endtask
			
	task main;
		repeat (transaction_count) begin
		mon2scb.get(mtrans);
			if(!mtrans.write_enable) begin
				if (mem[gtrans.address] != mtrans.data_in)
            		$display("[SCB-FAIL]  Data :: Expected = %0h Actual = %0h",mem[gtrans.address],mtrans.data_in);        
        		else 
            		$display("[SCB-PASS] Data :: Expected = %0h Actual = %0h",mem[gtrans.address],mtrans.data_in);
         end
	end
	endtask

    task run;
        begin
	fork 
	collect();
	main();
	join 
       end
    endtask
endclass




