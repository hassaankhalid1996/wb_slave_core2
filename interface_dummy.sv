
interface intf
	#(
	parameter ADDR_WIDTH = 8,
	parameter DATA_WIDTH = 32
	)
	(input logic clk);

	logic					reset;

	logic [ADDR_WIDTH-1:0]	addr;
	logic					wr_en;
	logic					rd_en;

	logic [DATA_WIDTH-1:0]	wdata;
	logic [DATA_WIDTH-1:0]	rdata;

endinterface

