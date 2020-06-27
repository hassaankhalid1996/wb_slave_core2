
class transaction
	#(
	parameter ADDR_WIDTH = 8,
	parameter DATA_WIDTH = 32
	);

	bit opcode;

			bit [ADDR_WIDTH-1:0] addr;
	static	bit [DATA_WIDTH-1:0] wdata;
			bit [DATA_WIDTH-1:0] rdata;

	function new (bit opcode, bit [ADDR_WIDTH-1:0] addr, bit [DATA_WIDTH-1:0] wdata);
		this.opcode = opcode;
		this.addr  = addr;	
		if(opcode) begin
			this.wdata = wdata;
		end
	endfunction

	function void display_write(string name);
		$display("-------------------------");
		$display("- %s ",name);
		$display("-------------------------");
		$display("- addr = %0d, wdata = %0d",addr,wdata);
		$display("-------------------------");
	endfunction

	function void display_read(string name);
		$display("-------------------------");
		$display("- %s ",name);
		$display("-------------------------");
		$display("- addr = %0d, rdata = %0d",addr,rdata);
		$display("-------------------------");
	endfunction

endclass

