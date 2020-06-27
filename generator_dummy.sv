
class generator;
	transaction trans;
	rand int x;
	rand int y;
	mailbox gen2driv;

	constraint c1 {x > 0;
				   x < 2**8;}

	function new(mailbox gen2driv);
		this.gen2driv = gen2driv;
	endfunction

	task main();
		trans = new(1, x, y);
		gen2driv.put(trans);
	endtask

endclass

