
class scoreboard;
	//int no_of_errors;
	mailbox mon2scb;
	//mailbox gen2scb;
    int transaction_count;	//transaction counter
	
	bit [32:0] mem[16];
	function new(mailbox mon2scb);
		this.mon2scb = mon2scb;
		//this.gen2scb = gen2scb;
                 foreach(mem[i]) mem[i]=32'd0;
	endfunction
			
	task run;
		transaction mtrans;
	 forever
		begin
		     mon2scb.get(mtrans);
		     if(mtrans.write_enable)  mem[mtrans.address] = mtrans.data_in;
			
		     else if(!mtrans.write_enable) begin
				if (mem[mtrans.address] != mtrans.data_out)
            			$display("[SCB-FAIL]  Data :: Expected = %0h Actual = %0h",mem[mtrans.address],mtrans.data_out);        
        			else 
            			$display("[SCB-PASS] Data :: Expected = %0h Actual = %0h",mem[mtrans.address],mtrans.data_out);
        		 	end
		end
		transaction_count++;
	endtask
endclass



