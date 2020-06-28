
`include "wb_core_2_environment.sv"

program wb_test(intf i_intf);
	environment env;

	initial begin
		env = new(i_intf);
		env.run();
	end
endprogram
