
`include "environment_0034.sv"

program test(intf i_intf);
	environment env;

	initial begin
		env = new(i_intf);
		env.run();
	end
endprogram
