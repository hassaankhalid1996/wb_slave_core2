
class scoreboard;
	int no_of_errors;
	mailbox mon2scb;

	function new(mailbox mon2scb);
		this.mon2scb = mon2scb;
	endfunction

	task main;
		transaction trans;
		mon2scb.get(trans);
		if(trans.wdata == trans.rdata)
			$display("Result is as Expected");
		else begin
			no_of_errors = no_of_errors + 1;     
			$error("Wrong Result.\n\tExpeced: %0d Actual: %0d", trans.wdata, trans.rdata);
		end
	endtask

endclass

