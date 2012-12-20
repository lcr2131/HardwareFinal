////////////////////////////////////////////////////////////////////////////////////////////
////	Module Name: branch_delay							////
////	Programmer: Shuying Fan								////
////	Date: 12/16									////
////	Function: delay three cycles in order to completely flush the buffer 		////
////////////////////////////////////////////////////////////////////////////////////////////



module branch_delay
(
	input 		clk,
	input 		rst,
	
	input 		flush,
	input [2:0]	bid,

	output	reg    	  buffer_flush,
	output 	reg [2:0] buffer_bid
);

	reg		delay1;
	reg [2:0]	bid1;
	reg 		delay2;
	reg [2:0]	bid2;

cycle_delay cycle1
(
	.clk,
	.rst,
	.flush,
	.bid,
	.delay(delay1),
	.delay_bid(bid1)
);


cycle_delay cycle2
(
	.clk,
	.rst,
	.flush(delay1),
	.bid(bid1),
	.delay(delay2),
	.delay_bid(bid2)
);

cycle_delay cycle3
(
	.clk,
	.rst,
	.flush(delay2),
	.bid(bid2),
	.delay(buffer_flush),
	.delay_bid(buffer_bid)
);



endmodule
