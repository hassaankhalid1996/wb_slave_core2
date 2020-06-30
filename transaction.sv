class transaction;
		
	randc bit [15:0]address;
	randc bit [31:0]data_out;
	randc bit [31:0]data_in;
	randc bit [3:0]select_bank;
	randc bit write_enable;
	
	//write enable
	constraint read_write_constraint { 
	address < 16;
	address >= 0;
	};
	

	function new (bit [15:0]address, bit [31:0]data_out, bit [31:0]data_in, bit [3:0]select_bank, bit write_enable);
		this.address = address;
		this.data_in = data_in; 
		this.select_bank = select_bank; 
		this.write_enable = write_enable;
		this.data_out = data_out;
	endfunction
	
	function display ();
		$display("address = %d, data_out = %d, data_in = %d, select_bank = %d, bitwrite_enable = %d",address, data_out, data_in, select_bank, write_enable);
	endfunction
endclass
