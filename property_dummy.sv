
module mem_property
	#(
	parameter ADDR_WIDTH = 8,
	parameter DATA_WIDTH = 32
	)
	(
	input logic clk,
	input logic reset,

	//control signals
	input logic [ADDR_WIDTH-1:0]  addr,
	input logic                   wr_en,
	input logic                   rd_en,
	
	//data signals
	input logic [DATA_WIDTH-1:0] wdata,
	input logic [DATA_WIDTH-1:0] rdata
	);

	`ifdef check1
		property check_write_op;
			@(posedge clk) disable iff(reset) $rose(wr_en) |-> !($isunknown(addr) && $isunknown(wdata));
		endproperty

		assert property (check_write_op) 
				$display($stime,"\t\t PASS::check write operation\n");
			else 
				$display($stime,"\t\t FAIL::check write operation\n");
	`endif

	`ifdef check2
		property check_read_op;
			@(posedge clk) disable iff(reset) $rose(rd_en) |-> !($isunknown(addr)) ##1 !($isunknown(rdata));
		endproperty

		assert property (check_read_op) 
				$display($stime,"\t\t PASS::check read operation\n");
			else 
				$display($stime,"\t\t FAIL::check read operation\n");
	`endif

	`ifdef check3
		property check_rd_en;
			@(posedge clk) disable iff(reset) rd_en |-> !wr_en;
		endproperty

		assert property (check_rd_en) 
				$display($stime,"\t\t PASS::check on enables\n");
			else 
				$display($stime,"\t\t FAIL::check on enables\n");
	`endif

	`ifdef check4
		property check_wr_en;
			@(posedge clk) disable iff(reset) wr_en |-> !rd_en;
		endproperty

		assert property (check_wr_en) 
				$display($stime,"\t\t PASS::check on enables\n");
			else 
				$display($stime,"\t\t FAIL::check on enables\n");
	`endif

endmodule
