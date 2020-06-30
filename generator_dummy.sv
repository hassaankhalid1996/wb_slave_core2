class generator; 
	 
	mailbox gen2drv;
	mailbox gen2scb; 
	
// function declaration
	
	function new (mailbox gen2drv , mailbox gen2scb);
		this.gen2drv = gen2drv;
		this.gen2scb = gen2scb; 
	endfunction
	
	task write_specific_addr(bit [15:0] address);
	
/* Description :
This task is designed to write data at the gien specific address 
The data written would be equal to address provided 
*/

		transaction tr; 
		tr = new (address, 0 , address , 4'b1111, 1'b1);
		gen2drv.put(tr);
		gen2scb.put(tr);
		
	endtask 		
	
	task read_specific_addr( bit [15:0] address);
	
/* Description:
This task is for reading data from a specific address.
*/
		transaction tr; 
		tr = new (address, 0 , 0 , 4'b1111, 1'b0);
		gen2drv.put(tr);
		gen2scb.put(tr);
	
	endtask 
	
	task full_block_write ();

/* Description
This task is to write block data in the slave. 
The block size would be 16. 
In this case the data written would also be equal to address provided.
*/
	for (int i = 0 ; i < 16 ; i++)
	begin 
		transaction tr; 
		tr = new (i, 0 , i, 4'b1111, 1'b1);
		gen2drv.put(tr);
		gen2scb.put(tr);
	end 	
	endtask 
	
	task full_block_read ();

/* Description
This task is to read block data in the slave. 
The block size would be 16.
*/
	for (int i = 0 ; i < 16 ; i++)
	begin 
		transaction tr; 
		tr = new (i, 0 , 0, 4'b1111, 1'b0);
		gen2drv.put(tr);
		gen2scb.put(tr);
	end 	
	endtask 
	
	task partial_block_write (int value_less_than_16);
	
	/* Description
This task is to write block data in the slave. 
The block size would be controlled by environment. 
In this case the data written would also be equal to address provided.
*/
	for (int i = 0 ; i < value_less_than_16 ; i++)
	begin 
		transaction tr; 
		tr = new (i, 0 , i, 4'b1111, 1'b1);
		gen2drv.put(tr);
		gen2scb.put(tr);
	end 	
	endtask
	
	task partial_block_read (int value_less_than_16);
	
	/* Description
This task is to read block data in the slave. 
The block size would be controlled by environment. 
*/
	for (int i = 0 ; i < value_less_than_16 ; i++)
	begin 
		transaction tr; 
		tr = new (i, 0 , 0, 4'b1111, 1'b0);
		gen2drv.put(tr);
		gen2scb.put(tr);
	end 	
	endtask
	
	task write_read_random_addr();
	
/* Description
This task write at a random address
and then read from the same random address 
*/
		bit [15:0] i; 
		i = $urandom_range(15,0);
		write_specific_addr(i);
		read_specific_addr(i);
	endtask
	
endclass
