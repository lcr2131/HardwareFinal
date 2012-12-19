////////////////////////////////////////////////////////////////////////////////////////////
////	Module Name: pc_ctrl								////
////	Programmer: Shuying Fan								////
////	Date: 12/13									////
////	Function: calculate the program counter for the next cycle		   	////
////////////////////////////////////////////////////////////////////////////////////////////



module pc_ctrl	#(parameter branch_addr = 'd5)
(
	input	clk,
	input	rst,

	input	iq_full,
	input	iq_empty,

	input	buffer_full,
	input 	buffer_empty,

	input	bid_full,

	input	flush,
	input	[branch_addr-1:0]	addr,


	output	reg [branch_addr-1:0]	pc

);


always_ff @(posedge clk or posedge rst)
begin
	if (rst)
		pc <= 'd0;
	
	else if (flush)
		pc <= addr;
	
	else if (iq_full || bid_full || buffer_full)
	begin
		if (iq_empty && buffer_empty)
			pc <= pc + 'd8;
	end

	else
		pc <= pc + 'd8;
	


end





endmodule
