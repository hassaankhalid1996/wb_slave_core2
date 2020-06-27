
class driver;
	virtual intf vif;
	mailbox gen2driv;

	function new(virtual intf vif,mailbox gen2driv);
		this.vif = vif;
		this.gen2driv = gen2driv;
	endfunction

	task reset;
		$display("[ DRIVER ] ----- Reset Started -----");
		vif.reset <= 1;
		vif.rd_en <= 0;
		vif.wr_en <= 0;
		vif.addr  <= 0;
		vif.wdata <= 0;
		@(posedge vif.clk);
		@(posedge vif.clk);
		vif.reset <= 0;
		$display("[ DRIVER ] ----- Reset Ended   -----");
	endtask

	task main;
		transaction trans;
		gen2driv.get(trans);
		@(posedge vif.clk);
		vif.wr_en <= 1;
		vif.addr  <= trans.addr;
		vif.wdata <= trans.wdata;
		@(posedge vif.clk);
		vif.wr_en <= 0;
		@(posedge vif.clk);
		trans.display_write("[ Driver Write ]");
	endtask

endclass
