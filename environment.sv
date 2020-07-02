`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "scoreboard.sv"
`include "monitor.sv"

class environment;

	mailbox gen2drv;
	mailbox gen2scb;
	mailbox mon2scb;

	generator gen;
	driver drv;
	monitor mon;
	scoreboard scb;

	function new(virtual wb_interface intf);
		
		this.gen2drv = new();
		this.gen2scb = new();
		this.mon2scb = new();
		
		this.gen = new(gen2drv,gen2scb);
		this.drv = new(intf,gen2drv);
		this.mon = new(mon2scb,intf);
		this.scb = new(gen2scb,mon2scb);
	
	endfunction

	task run();
	
		fork
			run_all();
			mon.main();		//starting monitor
			scb.main();
			scb.run();
		join 
	
	endtask 
	
	
	task run_all();
		
		drv.reset();	//reset 
		sc_pl_rw();		//SS_pipeline_R&W
		drv.transaction_count = 0;
		drv.delay();
		
		sc_st_rw();		//SS_standard_R&W
		drv.transaction_count = 0;
		drv.delay();

		bl_pl_rw();		//BL_pipeline_R&W
		drv.transaction_count = 0;
		drv.delay();


		bl_st_rw();		//BL_standard_R&W		
		drv.transaction_count = 0;
		drv.delay();
		$finish;
	endtask
	
/* Description:
This task is for single cycle standard read & write operation
*/

	task sc_st_rw();
		
		gen.write_read_random_addr();
		gen.write_read_random_addr();
		gen.write_read_random_addr();
	
	//The above tasks makes 6 transactions so we need to
	//call the below mentioned function twice for writing & then 
	//reading 
	
		for (int i = 0 ; i < 6 ; i++)
		drv.sc_st_rw();
		
	endtask 
	
/* Description:
This task is for block standard read & write operation
*/

	task bl_st_rw; 
	
	// This sets the block to 16
		drv.delay();
		drv.i = 0;
		drv.transaction_count = 16; 
		gen.full_block_write();
		drv.bl_st_rw();


		drv.delay();
		drv.i = 0;
		gen.full_block_read();
		drv.transaction_count = 16; 
		drv.bl_st_rw();
	// This sets the block to 4

				
		
		drv.transaction_count = 4;
		gen.partial_block_write(4);
		drv.bl_st_rw();
		gen.partial_block_read(4);
		drv.bl_st_rw();
		
	// This sets the block to 11
	
		drv.transaction_count = 11;
		gen.partial_block_write(11);
		drv.bl_st_rw();
		gen.partial_block_read(11);
		drv.bl_st_rw();


	endtask

/* Description:
This task is for single cycle pipeline read & write operation
*/

	task sc_pl_rw;
		gen.write_specific_addr_rand_data(0);
		gen.read_specific_addr(0);	
		gen.write_specific_addr(1);
		gen.read_specific_addr(1);
		gen.write_specific_addr(2);
		gen.read_specific_addr(2);
		gen.write_specific_addr(3);
		gen.read_specific_addr(3);
		gen.write_specific_addr(4);
		gen.read_specific_addr(4);
		gen.write_specific_addr(5);
		gen.read_specific_addr(5);
		gen.write_specific_addr_rand_data(6);
		gen.read_specific_addr(6);
		gen.write_specific_addr_rand_data(7);
		gen.read_specific_addr(7);
		gen.write_specific_addr_rand_data(8);
		gen.read_specific_addr(8);
		gen.write_specific_addr_rand_data(9);
		gen.read_specific_addr(9);
		gen.write_specific_addr_rand_data(10);
		gen.read_specific_addr(10);
		gen.write_specific_addr_rand_data(11);
		gen.read_specific_addr(11);
		gen.write_specific_addr_rand_data(12);
		gen.read_specific_addr(12);
		gen.write_specific_addr_rand_data(13);
		gen.read_specific_addr(13);
		gen.write_specific_addr_rand_data(14);
		gen.read_specific_addr(14);
		gen.write_specific_addr_rand_data(15);
		gen.read_specific_addr(15);
		gen.write_specific_addr_rand_data(17);
		gen.read_specific_addr(17);
		
	//The above tasks makes 8 transactions so we need to
	//call the below mentioned function 8 times for writing & then 
	//reading 
	
		for (int i = 0 ; i < 34 ; i++)
		drv.sc_pl_rw();
	
	endtask

/* Description:
This task is for block pipeline read & write operation
*/
	
	task bl_pl_rw;
	
	// This sets the block to 16
		
		drv.i = 1;
		drv.transaction_count = 16; 
		gen.full_block_write();	
		drv.bl_pl_rw();
	
		drv.delay();
		drv.i = 1;
		drv.transaction_count = 16;
		gen.full_block_read();	
		drv.bl_pl_rw();


	// This sets the block to 2
		drv.delay();
		drv.i = 1;
		drv.transaction_count = 2;
		gen.partial_block_write(2);
		drv.bl_pl_rw();

		drv.delay();
		drv.i = 1;
		drv.transaction_count = 2;
		gen.partial_block_read(2);
		drv.bl_pl_rw();
		
	// This sets the block to 8
		drv.delay();
		drv.i = 1;
		drv.transaction_count = 8;
		gen.partial_block_write(8);
		drv.bl_pl_rw();

				
		drv.delay();
		drv.i = 1;
		drv.transaction_count = 8;
		gen.partial_block_read(8);
		drv.i = 1;
		drv.bl_pl_rw();
		
	endtask
	
endclass
