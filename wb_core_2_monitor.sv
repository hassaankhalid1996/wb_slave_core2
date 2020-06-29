`define monitor interf.monitor 
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
			if(interf.we_i && interf.stb_i&& interf.cyc_i)begin			/// write 
				@(posedge interf);
				wait(interf.ack_o||err_o);
				if (interf.ack_o) no_ack++;
				else no_err++;
				trans.dat_in      <= `monitor.dat_i;        
				trans.select_bank <= `monitor.sel_i;
				trans.address     <= `monitor.adr_i;
				trans.write_enable<= `monitor.we_i;
				end
			else if( !interf.we_i && interf.stb_i && interf.cyc_i)begin // read
				@(posedge interf);
				wait(interf.ack_o||err_o);
				if (interf.ack_o) no_ack++;
				else no_err++;
				trans.dat_out     <= `monitor.dat_o;     
				trans.select_bank <= `monitor.sel_i;
				trans.address     <= `monitor.adr_i;
				trans.write_enable<= `monitor.we_i;
				end
		mon2scb.put(trans);
		$display("[ Monitor Read ]");
	endtask
endclass


