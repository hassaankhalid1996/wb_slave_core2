
class monitor;
	int x;
	int y;
	virtual intf vif;
	mailbox mon2scb;

	function new(virtual intf vif,mailbox mon2scb);
		this.vif = vif;
		this.mon2scb = mon2scb;
	endfunction

	task remove;
		transaction trans;
		mon2scb.get(trans);
	endtask

	task main;
		transaction trans;
		trans = new(0, x, 0);
		@(posedge vif.clk);
		vif.rd_en <= 1;
		vif.addr  <= trans.addr;
		@(posedge vif.clk);
		trans.rdata <= vif.rdata;
		y <= vif.rdata;
		@(posedge vif.clk);
		vif.rd_en <= 0;
		mon2scb.put(trans);
		trans.display_read("[ Monitor Read ]");
	endtask

endclass

