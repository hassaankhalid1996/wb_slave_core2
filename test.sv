
`include "environment.sv"

program wb_test(wb_interface intf);
	environment env;

	initial begin
		env = new(intf);
		env.run();
	end
endprogram
