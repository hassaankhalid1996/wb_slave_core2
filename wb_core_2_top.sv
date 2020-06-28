
`include "wb_core_2_interface.sv"
`include "wb_core_2_transactor.sv"
`include "wb_core_2_generator.sv"
`include "wb_core_2_driver.sv"
`include "wb_core_2_scoreboard.sv"
`include "wb_core_2_monitor.sv"
`include "wb_core_2_environment.sv"
`include "wb_core_2_test.sv"
`include "wb_core_2.sv"
`include "wb_core_2_property.sv"

parameter ADDR_WIDTH = 16;
parameter DATA_WIDTH = 32;
parameter GRANULE = 8;
parameter REGISTER_NUM = 16;
localparam SEL_WIDTH = DATA_WIDTH / GRANULE;
module top;
	bit clk_i;
	bit rst_i;
	[ADDR_WIDTH-1:0] adr_i,
	[DATA_WIDTH-1:0] dat_i,
	[DATA_WIDTH-1:0] dat_o,
	we_i,
	stb_i,
	ack_o,
	err_o,
	stall_o,
	cyc_i

	always #5 clk_i = ~clk_i;

	wb_interface intf(rst_i,clk_i);

	wb_core_2_test test(intf);

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
