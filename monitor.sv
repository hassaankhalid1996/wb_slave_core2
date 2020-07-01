`define monitor interf.monitor 
class monitor;
	mailbox mon2scb;
	virtual wb_interface interf;      //interface                  
	function new(mailbox mon2scb, virtual wb_interface interf);
		this.interf = interf;
		this.mon2scb = mon2scb;
	endfunction

	task main;
		forever begin
		transaction trans;
			trans = new(0,0,0,15,0);
	   		 @(posedge interf.clk_i);
////////////////////////////////////////// write////////////////////////////////////////
			if(`monitor.we_i && `monitor.stb_i && `monitor.cyc_i)begin			
				@(posedge `monitor.clk_i);
				wait(interf.ack_o);
			    if (interf.stall_o)
				repeat(2) @(posedge `monitor.clk_i);
				trans.data_in     = `monitor.dat_i;        
				trans.select_bank = `monitor.sel_i;
				trans.address     = `monitor.adr_i;
				trans.write_enable= `monitor.we_i;
				$display("Monitor received Write: Address=%0d, select bank=%0d, data_in= %0d\n",trans.address,trans.select_bank,trans.data_in);
				end
////////////////////////////////////////// Read////////////////////////////////////////
			else if( !`monitor.we_i && `monitor.stb_i && `monitor.cyc_i ) begin                
				@(posedge `monitor.clk_i);
				wait(`monitor.ack_o);
				if (`monitor.stall_o)
				repeat(2) @(posedge `monitor.clk_i);
				trans.data_out    = `monitor.dat_o;     
				trans.select_bank = `monitor.sel_i;
				trans.address     = `monitor.adr_i;
				trans.write_enable= `monitor.we_i;
				$display("Monitor Received Read: Address=%0d, select bank=%0d, data_out=%0d\n",trans.address,trans.select_bank,trans.data_out);
				end
		mon2scb.put(trans);
		end
	endtask
endclass
