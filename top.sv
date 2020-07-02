
`include "test.sv"
`include "property.sv"
/*
parameter ADDR_WIDTH = 16;
parameter DATA_WIDTH = 32;
parameter GRANULE = 8;
parameter REGISTER_NUM = 16;
localparam SEL_WIDTH = DATA_WIDTH / GRANULE;
*/
module top;
	bit	rst_i;
	bit	clk_i;
	wire	[ADDR_WIDTH-1:0] adr_i;
	wire	[DATA_WIDTH-1:0] dat_i;
	wire	[DATA_WIDTH-1:0] dat_o;
	wire	[SEL_WIDTH-1:0] sel_i;
	wire	we_i;
	wire	stb_i;
	wire	ack_o;
	wire	err_o;
	wire	stall_o;
	wire	cyc_i;

	always #5 clk_i = ~clk_i;
	initial 
		begin
			rst_i = 0;
		#5	rst_i=1;
		#10	rst_i=0;
		end
	wb_interface intf(rst_i,clk_i);

	wb_test test(intf);

	wb_slave slave(
		.clk_i(intf.clk_i),
		.rst_i(intf.rst_i),
		.adr_i(intf.adr_i),
		.dat_i(intf.dat_i),
		.dat_o(intf.dat_o),
		.sel_i(intf.sel_i),
		.we_i(intf.we_i),
		.stb_i(intf.stb_i),
		.ack_o(intf.ack_o),
		.err_o(intf.err_o),
		.stall_o(intf.stall_o),
		.cyc_i(intf.cyc_i)
		);

	wb_property slave_property(
		.clk_i(intf.clk_i),
		.rst_i(intf.rst_i),
		.adr_i(intf.adr_i),
		.dat_i(intf.dat_i),
		.dat_o(intf.dat_o),
		.sel_i(intf.sel_i),
		.we_i(intf.we_i),
		.stb_i(intf.stb_i),
		.ack_o(intf.ack_o),
		.err_o(intf.err_o),
		.stall_o(intf.stall_o),
		.cyc_i(intf.cyc_i)
		);

/*	initial begin 
		$dumpfile("dump.vcd");
		$dumpvars;
	end
*/
endmodule
