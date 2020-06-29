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
	bit	rst_i;
	bit	clk_i;
	wire	[ADDR_WIDTH-1:0] adr_i;
	wire	[DATA_WIDTH-1:0] dat_i;
	wire	[DATA_WIDTH-1:0] dat_o;
	wire	we_i;
	wire	stb_i;
	wire	ack_o;
	wire	err_o;
	wire	stall_o;
	wire	cyc_i;

	always #5 clk_i = ~clk_i;

	wb_interface intf(rst_i,clk_i);

	wb_test test(intf);

	wb_slave slave(
		.clk_i(i_intf.clk_i),
		.rst_i(i_intf.rst_i),
		.adr_i(i_intf.adr_i),
		.dat_i(i_intf.dat_i),
		.dat_o(i_intf.dat_o),
		.we_i(i_intf.we_i),
		.stb_i(i_intf.stb_i),
		.ack_o(i_intf.ack_o),
		.err_o(i_intf.err_o),
		.stall_o(i_intf.stall_o),
		.cyc_i(i_intf.cyc_i)
		);

	wb_property slave_property(
		.clk_i(i_intf.clk_i),
		.rst_i(i_intf.rst_i),
		.adr_i(i_intf.adr_i),
		.dat_i(i_intf.dat_i),
		.dat_o(i_intf.dat_o),
		.we_i(i_intf.we_i),
		.stb_i(i_intf.stb_i),
		.ack_o(i_intf.ack_o),
		.err_o(i_intf.err_o),
		.stall_o(i_intf.stall_o),
		.cyc_i(i_intf.cyc_i)
		);
	initial begin 
		$dumpfile("dump.vcd");
		$dumpvars;
	end
endmodule
