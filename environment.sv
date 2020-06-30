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
		this.drv = new(gen2drv,intf);
		this.mon = new(mon2scb,intf);
		this.scb = new(gen2scb,mon2scb);
	
	endfunction

	task run();
//		fork
			drv.reset();
			gen.write_specific_addr(4);
			drv.SC_pipelined();
			gen.read_specific_addr(4);
			drv.SC_pipelined();
			
			mon.main();
			scb.run();

			$finish;
//		join
	endtask
endclass
