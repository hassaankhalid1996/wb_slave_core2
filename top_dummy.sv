
`include "mem_design.sv"
`include "interface_0034.sv"
`include "mem_property_0034.sv"
`include "test_program_0034.sv"

module tbench_top;
	bit clk;
	always #5 clk = ~clk;

	intf i_intf(clk);

	test t1(i_intf);

	memory DUT(
		.clk(i_intf.clk),
		.reset(i_intf.reset),

		.addr(i_intf.addr),
		.wr_en(i_intf.wr_en),
		.rd_en(i_intf.rd_en),

		.wdata(i_intf.wdata),
		.rdata(i_intf.rdata)
		);

	bind memory mem_property membind(
		.clk(i_intf.clk),
		.reset(i_intf.reset),

		.addr(i_intf.addr),
		.wr_en(i_intf.wr_en),
		.rd_en(i_intf.rd_en),

		.wdata(i_intf.wdata),
		.rdata(i_intf.rdata)
		);

	initial begin 
		$dumpfile("dump.vcd");
		$dumpvars;
	end
endmodule
