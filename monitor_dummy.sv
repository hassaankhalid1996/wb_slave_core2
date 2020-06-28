class monitor;
	mailbox mon2scb;
	int no_ack;
	int no_err;
	virtual wb_interface interf;      //interface                  
	function new(wb_interface interf,mailbox mon2scb);
		this.interf = interf;
		this.mon2scb = mon2scb;
	endfunction

	task main;
		transaction trans;
		trans = new();
	    @(posedge interf);
			if(interf.wr_i && interf.stb_i)begin			/// write 
				@(posedge interf);
				wait(interf.ack_o||err_o);
				if (interf.ack_o) no_ack++;
				else no_err++;
				trans.dat_in      <= interf.dat_i;     
				trans.select_bank <= interf.sel_i;
				trans.address     <= interf.adr_i;
				trans.write_enable<= interf.wr_i;
				end
			else if( !interf.wr_i && interf.stb_i)begin // read
				@(posedge interf);
				wait(interf.ack_o||err_o);
				if (interf.ack_o) no_ack++;
				else no_err++;
				trans.dat_out     <= interf.dat_o;     
				trans.select_bank <= interf.sel_i;
				trans.address     <= interf.adr_i;
				trans.write_enable<= interf.wr_i;
				end
		mon2scb.put(trans);
		$display("[ Monitor Read ]");
	endtask

endclass


