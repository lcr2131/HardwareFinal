////////////////////////////////////////////////////////////////////////////////////////////
////	Module Name: pc_ctrl								////
////	Programmer: Shuying Fan								////
////	Date: 12/13									////
////	Function: calculate the program counter for the next cycle		   	////
////////////////////////////////////////////////////////////////////////////////////////////



module pc_ctrl
(
	input	clk,
	input	rst,

	input	vld_1,
	input	vld_2,
	
	input	iq_full,
	input	iq_empty,

	input	buffer_full,
	input 	buffer_empty,

	input	bid_full,

	input	flush,
	input	[4:0]	addr,


	output	reg [4:0]	pc

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
			pc <= pc + 'd2;
	end

	else if (vld_1 && vld_2)
		pc <= pc + 'd2;
	else if (vld_1 && ~vld_2)
		pc <= pc + 'd1;
		
end





endmodule
