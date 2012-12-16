////////////////////////////////////////////////////////////////////////////////////////////
////	Module Name: branch_mux								////
////	Programmer: Shuying Fan								////
////	Date: 12/13									////
////	Function: pick the branch ID for the first valid mispredicted branch 		////
////////////////////////////////////////////////////////////////////////////////////////////



module branch_mux #(parameter branch_addr = 'd4)
(
	input [2:0]			ins1_bid,
	input [2:0]			ins2_bid,
	input [2:0]			ins3_bid,
	input [2:0]			ins4_bid,

	input [branch_addr-1:0]		ins1_addr,
	input [branch_addr-1:0]		ins2_addr,
	input [branch_addr-1:0]		ins3_addr,
	input [branch_addr-1:0]		ins4_addr,


	input [1:0]			pick_branch,


	output	logic	[2:0]			bid,
	output  logic	[branch_addr-1:0]	addr

);


always_comb
begin


	case (pick_branch)
		'd0: begin bid = ins1_bid; addr = ins1_addr; end
		'd1: begin bid = ins2_bid; addr = ins2_addr; end
		'd2: begin bid = ins3_bid; addr = ins3_addr; end
		'd3: begin bid = ins4_bid; addr = ins4_addr; end

		default begin bid = ins4_bid; addr = ins4_addr; end

	endcase
end

endmodule
