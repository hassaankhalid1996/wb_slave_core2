// files to be included 

class environment;

	mailbox gen2drv;
	mailbox gen2scb;
	mailbox mon2scb;

	generator gen;
	driver drv;
	monitor mon;
	scoreboard scb;

	function new(virtual intr rinf);
		
		this.gen2drv = new();
		this.gen2scb = new();
		this.mon2scb = new();
		
		this.gen = new(gen2drv,gen2scb);
		this.drv = new(gen2drv,rinf);
		this.mon = new(mon2scb,rinf);
		this.scb = new(gen2scb,mon2scb);
	
	endfunction

	task run();
		fork
		
// define tasks to run here

		join
	endtask
endclass
