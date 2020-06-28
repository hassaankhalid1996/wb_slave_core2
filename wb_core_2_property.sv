	parameter ADDR_WIDTH = 16;
	parameter DATA_WIDTH = 32;
	parameter GRANULE = 8;
	parameter REGISTER_NUM = 16;
	localparam SEL_WIDTH = DATA_WIDTH / GRANULE;

module wb_property (
    input wire rst_i,
    input wire clk_i,
    input wire [ADDR_WIDTH-1:0] adr_i,
    input wire [DATA_WIDTH-1:0] dat_i,
    input reg [DATA_WIDTH-1:0] dat_o,
    input wire we_i,
    input wire stb_i,
    input wire ack_o,
    input wire err_o,
    input wire stall_o,
    input wire cyc_i
);

        /*--------------------------------------------------
        CHECK # 1. ack_o and err_o cannot be high at the same time 
          --------------------------------------------------*/
`ifdef check1
	property ack_o_and_err_o_not_high_at_same_time ;
  		@(posedge clk)disable iff(rst_i)
			(ack_o==1)|-> (err_o!=1);
	endproperty
        
	assert property (ack_o_and_err_o_not_high_at_same_time) 
  		$display($stime,,,"ack_o and err_o cannot be high at the same time check PASSED\n");
  	else 
    	$display($stime,,,"ack_o and err_o cannot be high at the same time check FAILED\n");
`endif
        /*--------------------------------------------------
        CHECK # 2. Slave should responde to stb_i with ack_o assertion test
						assuming no error
          --------------------------------------------------*/
`ifdef check2
	property ack_o_response_to_stb_i_signal;
   		@(posedge clk)disable iff(rst_i || err_o)
			$rose(stb_i)|=> $rose(ack_o==1);
	endproperty
       
	assert property ( ack_o_response_to_stb_i_signal) 
  		$display($stime,,,"ack_o Response to stb_i signal CHECK PASSED\n");
  	else 
    	$display($stime,,,"ack_o Response to stb_i signal CHECK FAILED\n");
`endif
        /*--------------------------------------------------
        CHECK # 3. Reset signal assertion test
          --------------------------------------------------*/
`ifdef check3
	property reset_signal_check;
   		@(posedge clk)
			$rose(rst_i) |-> Ack_o==0 && err_o==0 && stall_o==0;
	endproperty
        
	assert property ( reset_signal_check) 
  		$display($stime,,,"Reset assertion CHECK PASSED\n");
  	else 
    	$display($stime,,,"Reset assertion CHECK FAILED\n");
`endif
 
 /*-----------------------------------------------------
    CHECK # 4. Check if stb_i signal is valid driven while cyc_i is high.
  --------------------------------------------------*/

`ifdef check4
	property stb_i_signal_validity;
   		@(posedge clk)			
			(cyc_i==1) |->  ^(stb_i)==='bx && ^(stb_i)==='bz;
	endproperty
        
	assert property ( stb_i_signal_validity) 
  		$display($stime,,,"stb_i signal valid driven CHECK PASSED\n");
  	else 
    	$display($stime,,,"stb_i signal valid driven CHECK FAILED\n");
`endif

 /*-----------------------------------------------------
    CHECK # 5. Check if stall signal is valid driven while cyc_i is high.
  --------------------------------------------------*/

`ifdef check5
	property stall_o_signal_validity;
   		@(posedge clk)			
			(cyc_i==1) |->  ^(stall_o)==='bx && ^(stall_o)==='bz;
	endproperty
        
	assert property ( stall_o_signal_validity) 
  		$display($stime,,,"stall signal valid driven CHECK PASSED\n");
  	else 
    	$display($stime,,,"stall signal valid driven CHECK FAILED\n");
`endif

/*-----------------------------------------------------
    CHECK # 6. Check if ack signal is valid driven while cyc_i is high.
  --------------------------------------------------*/

`ifdef check6
	property ack_o_signal_validity;
   		@(posedge clk)			
			(cyc_i==1) |->  ^(ack_o)==='bx && ^(ack_o)==='bz;
	endproperty
        
	assert property ( ack_o_signal_validity) 
  		$display($stime,,,"ack signal valid driven CHECK PASSED\n");
  	else 
    	$display($stime,,,"ack signal valid driven CHECK FAILED\n");
`endif

/*-----------------------------------------------------
    CHECK # 7. Check if err signal is valid driven while cyc_i is high.
  --------------------------------------------------*/

`ifdef check7
	property err_o_signal_validity;
   		@(posedge clk)			
			(cyc_i==1) |->  ^(err_o)==='bx && ^(err_o)==='bz;
	endproperty
        
	assert property ( err_o_signal_validity) 
  		$display($stime,,,"err signal valid driven CHECK PASSED\n");
  	else 
    	$display($stime,,,"err signal valid driven CHECK FAILED\n");
`endif

/*-----------------------------------------------------
    CHECK # 8. Check if WE_i signal is valid driven while cyc_i is high.
  --------------------------------------------------*/

`ifdef check8
	property we_i_signal_validity;
   		@(posedge clk)			
			(cyc_i==1) |->  ^(we_i)==='bx && ^(we_i)==='bz;
	endproperty
        
	assert property ( we_i_signal_validity) 
  		$display($stime,,,"we_i signal valid driven CHECK PASSED\n");
  	else 
    	$display($stime,,,"we_i signal valid driven CHECK FAILED\n");
`endif
		
/*-----------------------------------------------------
    CHECK # 9. Check if adr_i is valid while cyc_i is high.
  --------------------------------------------------*/

`ifdef check9
	property adr_i_signal_validity;
   		@(posedge clk)		
			(cyc_i==1) |->  ^(adr_i)==='bx && ^(adr_i)==='bz;
	endproperty
        
	assert property ( adr_i_signal_validity) 
  		$display($stime,,,"adr_i signal valid driven CHECK PASSED\n");
  	else 
    	$display($stime,,,"adr_i signal valid driven CHECK FAILED\n");
`endif

/*-----------------------------------------------------
    CHECK # 10. Check if dat_i is valid while cyc_i is high.
  --------------------------------------------------*/

`ifdef check10
	property dat_i_signal_validity;
   		@(posedge clk)		
			(cyc_i==1) |->  ^(dat_i)==='bx && ^(dat_i)==='bz;
	endproperty
        
	assert property ( dat_i_signal_validity) 
  		$display($stime,,,"dat_i signal valid driven CHECK PASSED\n");
  	else 
    	$display($stime,,,"dat_i signal valid driven CHECK FAILED\n");
`endif
endmodule
