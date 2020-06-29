
class generator; 
	 
	mailbox gen2drv;
	mailbox gen2scb; 
	
	function new (mailbox gen2drv , mailbox gen2scb);
		this.gen2drv = gen2drv;
		this.gen2scb = gen2scb; 
	endfunction
	
	task SS_pipelined_write;	// single cycle pipelined_write at a specific address 
		
		transaction tr; 
		tr = new();
		tr.randomize();
		tr.address = 16'h4;
		tr.write_enable = 1'b1; 
		
		gen2drv.put(tr);
		gen2scb.put(tr);
		
	endtask 		
		
	task SS_pipelined_read; // signle cycle pipeline_read at the above defined specific address 
		transaction tr; 
		tr = new();
		tr.address = 16'h4;
		tr.write_enable = 1'b0;
		
		gen2drv.put(tr);
		gen2scb.put(tr);
		
	endtask 
	
	task block_write (int transaction_count); // block write
	
		for (int i = 0; i < transaction_count ; i++)
		begin
		
			transaction tr; 
			tr = new();
			tr.randomize();
			tr.address = i;
			tr.write_enable = 1'b1; 
			gen2drv.put(tr);
			gen2scb.put(tr);
			
		end 

	enstask 
	
	task block_read (int transaction_count); // block read
	
		for (int i = 0; i < transaction_count ; i++)
		begin
		
			transaction tr; 
			tr = new();
			tr.address = i;
			tr.write_enable = 1'b0; 
			gen2drv.put(tr);
			gen2scb.put(tr);
			
		end 

	enstask 
		
endclass

