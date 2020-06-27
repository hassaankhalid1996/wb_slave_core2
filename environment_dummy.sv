
`include "transaction_0034.sv"
`include "generator_0034.sv"
`include "driver_0034.sv"
`include "monitor_0034.sv"
`include "scoreboard_0034.sv"

class environment;
	int no_of_errors;

	generator	gen;
	driver		driv;
	monitor		mon;
	scoreboard	scb;

	mailbox gen2driv;
	mailbox mon2scb;

	virtual intf vif;

	function new(virtual intf vif);
		this.vif = vif;

		gen2driv = new();
		mon2scb  = new();

		gen  = new(gen2driv);
		driv = new(vif,gen2driv);
		mon  = new(vif,mon2scb);
		scb  = new(mon2scb);
	endfunction

	task reset_test();
		driv.reset();
		for(int i = 0; i < 2**8; i++) begin
			mon.x = i;
			mon.main();
			mon.remove();
			if(mon.y == 32'hFFFFFFFF)
				$display("Result is as Expected");
			else begin
				no_of_errors = no_of_errors + 1;
				$error("Wrong Result.\n\tExpeced: 32'hFFFFFFFF Actual: %0d", mon.y);
			end
		end
	endtask

	task directed_test();
		for(int i = 0; i < 2**8; i++) begin
			for(int j = 0; j < 2**4; j++) begin
				gen.x = i;
				gen.y = j;
				mon.x = i;

				gen.main();
				driv.main();
				mon.main();
				scb.main();
			end
		end
	endtask

	task random_test();
		for(int i = 0; i < 2**10; i++) begin
			gen.randomize();
			mon.x = gen.x;

			gen.main();
			driv.main();
			mon.main();
			scb.main();
		end
	endtask

	task mid_reset_test();
		for(int i = 0; i < 2**10; i++) begin
			gen.randomize();
			mon.x = gen.x;

			gen.main();
			driv.main();
			mon.main();
			scb.main();

			if (i == 200) begin
				reset_test();
				break;
			end
		end
	endtask

	task run;
		$display("##### Starting Reset Test #####");
		reset_test();
		$display("##### Ending Reset Test #####");
		$display("##### Starting Directed Test #####");
		directed_test();
		$display("##### Ending Directed Test #####");
		$display("##### Starting Random Test #####");
		random_test();
		$display("##### Ending Random Test #####");
		$display("##### Starting Middle Reset Test #####");
		mid_reset_test();
		$display("##### Ending Middle Reset Test #####");
		$display("##### Starting Reset Test #####");
		reset_test();
		$display("##### Ending Reset Test #####");
		$display("***** Total Errors = %0d *****", no_of_errors+scb.no_of_errors);
		$finish;
	endtask

endclass

