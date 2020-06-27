`define driver interf.driver.cb_driver 

class driver;
   
	int transaction_count;            //transaction counter
	virtual wb_interface interf;      //interface 
	mailbox gen2driv;                 //A handle for mailbox object  
    
	function new(virtual wb_interface interf, mailbox gen2driv);
    this.interf = interf;
    this.gen2driv = gen2driv;
	endfunction
	
	int j;
   
	task reset;                     //should be atleast one cycle (Reset task)
		wait(interf.rst_i);
		$display("---------Driver Reset Started---------");
		`driver.adr_i  <= 0;
		`driver.dat_i  <= 0; 
		`driver.sel_i  <= 0;
		`driver.wr_i   <= 0;
		`driver.stb_i  <= 0;
		`driver.cyc_i  <= 0;
		j = 0;
		wait(!interf.rst_i);
		$display("---------Driver Reset Ended---------");
	endtask
    
	
	task SS_pipelined;                     //single cycle pipelined task
		`driver.adr_i  <= trans.address;
		`driver.sel_i  <= trans.select_bank;
		`driver.wr_i   <= trans.write_enable;
		`driver.stb_i  <= 1'b1;
		`driver.cyc_i  <= 1'b1;
		if(trans.write_enable)
			`driver.dat_i  <= trans.data_out; 
		
		
		@(posedge interf.clk_i); 
		wb.stb <= 1'b0;
		
		do
		@(posedge interf.clk_i);
		while(`driver.ack_o == 0 || `driver.err_o == 0);  
		
		
		
		@(posedge interf.clk_i);
		wb.cyc <= 1'b0;
	endtask
	
	
	task Block_pipelined;                     //Block transfer pipelined task
		`driver.stb_i  <= 1'b1;
		`driver.cyc_i  <= 1'b1;
		
		fork 
			drive_data_pack();
			count_ack_err();
		join
			
		@(posedge interf.clk_i);
		`driver.cyc_i <= 1'b0;
	endtask
   
   
   task drive_data_pack;
		transaction trans;
   		for(int i=0;i<transaction_count;i++)
		begin
			 gen2driv.get(trans);
			`driver.adr_i  <= trans.address;
			`driver.sel_i  <= trans.select_bank;
			`driver.wr_i   <= trans.write_enable;

			if(trans.write_enable)
				`driver.dat_i  <= trans.data_out; 
			
			do 
				@(posedge interf.clk_i); 
			while(`driver.stall_o == 0);
			
		end		
		`driver.stb_i <= 1'b0;
	endtask
	
	task count_ack_err;
		while(j < transaction_count);
			begin
				@(posedge interf.clk_i);
					if(`driver.ack_o || `driver.err_o)
						j = j+1;
			end
		
	endtask
          
endclass
