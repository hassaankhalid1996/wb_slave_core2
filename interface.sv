
interface wb_interface(
	input logic rst_i,
	input logic clk_i
	);

	parameter ADDR_WIDTH = 16;
	parameter DATA_WIDTH = 32;
	parameter SEL_WIDTH  = 4;

    logic [ADDR_WIDTH-1:0] adr_i;
    logic [DATA_WIDTH-1:0] dat_i; //slave data in
    logic [DATA_WIDTH-1:0] dat_o; //slave data out
    logic [SEL_WIDTH-1:0]  sel_i;
    logic we_i;
    logic stb_i;
    logic ack_o;
    logic err_o;
    logic stall_o;
    logic cyc_i;

	clocking cb_driver @(posedge clk_i); 
		default input #1 output #1;      
		output adr_i;
		output dat_i;
		input  dat_o;
		output sel_i;
		output we_i;
		output stb_i;
		input  ack_o;
		input  err_o;
		input  stall_o;
		output cyc_i;
	endclocking
	
   modport driver(input clk_i,input rst_i,clocking cb_driver);

	clocking cb_slave @(posedge clk_i); 
		default input #1 output #1;      
	    input  adr_i;
		input  dat_i;
		output dat_o;
		input  sel_i;
		input  we_i;
		input  stb_i;
		output ack_o;
		output err_o;
		output stall_o;
		input  cyc_i;
	endclocking
	
   modport slave(input clk_i,input rst_i,clocking cb_slave);


   modport monitor
    (
    input  rst_i,
    input  clk_i,
    input  adr_i,
    input  dat_i,
    input  dat_o,
    input  sel_i,
    input  we_i,
    input  stb_i,
    input  ack_o,
    input  err_o,
    input  stall_o,
    input  cyc_i
	);
///////////////////////////////////Courage Group///////////////////////////////////////////////////

	covergroup cb @(posedge intf.clk_i);
	  
		coverpoint intf.we_i {bins write ={1};bins read ={0};}
	    
		coverpoint  intf.stb_i  {bins slave_not_ready  = {0};  bins Slave_ready = {1};}

		coverpoint  intf.cyc_i  {bins cycle_stop       = {0};  bins cycle_start = {1};}   
		
		coverpoint intf.sel_i {
		    bins byte_transfer= {0};
		    bins halfword_transfer= {1};
		    bins word_transfer= {2};
		    bins more_than_word_transfer = {[3:$]};}
		    
		coverpoint intf.ack_o {bins no_transfer = {0}; bins _transfer = {1};}

		coverpoint intf.adr_i { bins address_0_15[] = {[0:15]};bins address_rest = {[15:$]};} 

		coverpoint intf.dat_i { bins data [4] = {[0:$]};}

	    endgroup
	cb cover_group = new() ;

/////////////////////////////////////////////// end group /////////////////////////////////////////////
endinterface: wb_interface
