
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
	int i;
   
	task reset;                     //should be atleast one cycle (Reset task)
		wait(interf.rst_i);
		$display("---------Driver Reset Started---------");
		`driver.adr_i  <= 0;
		`driver.dat_i  <= 0; 
		`driver.sel_i  <= 0;
		`driver.we_i   <= 0;
		`driver.stb_i  <= 0;
		`driver.cyc_i  <= 0;
		j = 0;
		i = 0;
		transaction_count = 0;
		wait(!interf.rst_i);
		$display("---------Driver Reset Ended---------");
	endtask


///////////////////////////////////////Standard Single Cycle Read and Write//////////	
	task SC_Standard;                     //single cycle read and write task
		transaction trans;
		gen2driv.get(trans);
		`driver.adr_i  <= trans.address;
		`driver.sel_i  <= trans.select_bank;
		`driver.we_i   <= trans.write_enable;
		`driver.stb_i  <= 1'b1;
		`driver.cyc_i  <= 1'b1;
		if(trans.write_enable)
			`driver.dat_i  <= trans.data_out; 


		wait(`driver.ack_o == 1 || `driver.err_o == 1);   


		@(posedge interf.clk_i);
		`driver.we_i   <= 1'b0;
		`driver.stb_i  <= 1'b0;
		`driver.cyc_i  <= 1'b0;
	endtask


	task SC_Standard_Multi_Trans;    //Single Cycle Standard call for multiple transfers(block)
  		for(i=0;i<transaction_count;i++)
		begin
			SC_Standard();
			@(posedge interf.clk_i);
			
		end
	endtask
//////////////////////////////////Standard Single Cycle Read and Write Ended///////////


    
///////////////////////////////////////Single Cycle Pipelined Read and Write//////////	
	task SC_pipelined;                     //single cycle pipelined read and write task
		transaction trans;
		gen2driv.get(trans);
		`driver.adr_i  <= trans.address;
		`driver.sel_i  <= trans.select_bank;
		`driver.we_i   <= trans.write_enable;
		`driver.stb_i  <= 1'b1;
		`driver.cyc_i  <= 1'b1;
		if(trans.write_enable)
			`driver.dat_i  <= trans.data_out; 
		
		@(posedge interf.clk_i); 
		`driver.stb_i <= 1'b0;
		
		do
		@(posedge interf.clk_i);
		while(`driver.ack_o == 0 && `driver.err_o == 0);  
		
		`driver.cyc_i <= 1'b0;
	endtask


	task SC_pipelined_Multi_Trans;        //single cycle pipelined call for multiple transfers
  		for(i=0;i<transaction_count;i++)
		begin
			SC_pipelined();
			@(posedge interf.clk_i);
		end
	endtask
//////////////////////////////////Single Cycle Pipelined Read and Write Ended///////////	

	
/////////////////////////////////Block pipelined Read and Write////////////////////////
	task Block_pipelined_Read;                //Block transfer pipelined Read task 
		transaction trans;
		gen2driv.get(trans);	

		@(posedge interf.clk_i);		
		`driver.stb_i  <= 1'b1;
		`driver.cyc_i  <= 1'b1;
		`driver.we_i   <= 1'b0;
		`driver.adr_i  <= trans.address;
		`driver.sel_i  <= trans.select_bank;		
		
			for(i=1;i<transaction_count;i++)
			begin
				gen2driv.get(trans);

$display("Driver: Address:%d,select bank:%d,data_out= %d",trans.address,trans.select_bank, trans.data_out);
			
				@(posedge interf.clk_i);
				`driver.adr_i  <= trans.address;
				`driver.sel_i  <= trans.select_bank;
				while(!(`driver.stall_o))
				begin
					@(posedge interf.clk_i);
					`driver.adr_i  <= trans.address;
					`driver.sel_i  <= trans.select_bank;
				end
			end
		@(posedge interf.clk_i);
		`driver.stb_i  <= 1'b0;
		@(posedge interf.clk_i);
		`driver.cyc_i  <= 1'b0;
		
	endtask
   


	task Block_pipelined_Write;                //Block transfer pipelined Write task 
		transaction trans;
		gen2driv.get(trans);	

		@(posedge interf.clk_i);		
		`driver.stb_i  <= 1'b1;
		`driver.cyc_i  <= 1'b1;
		`driver.we_i   <= 1'b1;
		`driver.adr_i  <= trans.address;
		`driver.sel_i  <= trans.select_bank;		
		
			for(i=1;i<transaction_count;i++)
			begin
				gen2driv.get(trans);

$display("Driver: Address:%d,select bank:%d,data_out= %d",trans.address,trans.select_bank,trans.data_out);
			
				@(posedge interf.clk_i);
				`driver.adr_i  <= trans.address;
				`driver.sel_i  <= trans.select_bank;
				while(!(`driver.stall_o))
				begin
					@(posedge interf.clk_i);
					`driver.adr_i  <= trans.address;
					`driver.sel_i  <= trans.select_bank;
				end
			end
		@(posedge interf.clk_i);
		`driver.stb_i  <= 1'b0;
		@(posedge interf.clk_i);
		`driver.cyc_i  <= 1'b0;
		`driver.we_i   <= 1'b0;
	endtask
   


endclass




