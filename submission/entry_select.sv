//Programmer:	Tong Zhang
//Date:		12/10/2012
//Purpose:	Selecting index for the four entries of issue queue for the next cycle

module entry_select
(
	input ins_in_1,		//these are the control signal sent back from the checkers
	input ins_in_2,	 
	input ins_in_3,	
	input ins_in_4,	
	
	output logic [2:0]	index_out_1,
	output logic [2:0]	index_out_2,
	output logic [2:0]	index_out_3,
	output logic [2:0]	index_out_4
);

always_comb
case ({ins_in_4,ins_in_3,ins_in_2,ins_in_1})
	'b0000:	
	begin
		index_out_1 = 'd0;
		index_out_2 = 'd1;
		index_out_3 = 'd2;
		index_out_4 = 'd3;
	end
	'b0001:	
	begin
		index_out_1 = 'd1;
		index_out_2 = 'd2;
		index_out_3 = 'd3;
		index_out_4 = 'd4;
	end
	'b0010:	
	begin
		index_out_1 = 'd0;
		index_out_2 = 'd2;
		index_out_3 = 'd3;
		index_out_4 = 'd4;
	end
	'b0011:	
	begin
		index_out_1 = 'd2;
		index_out_2 = 'd3;
		index_out_3 = 'd4;
		index_out_4 = 'd5;
	end
	'b0100:	
	begin
		index_out_1 = 'd0;
		index_out_2 = 'd1;
		index_out_3 = 'd3;
		index_out_4 = 'd4;
	end
	'b0101:	
	begin
		index_out_1 = 'd1;
		index_out_2 = 'd3;
		index_out_3 = 'd4;
		index_out_4 = 'd5;
	end
	'b0110:	
	begin
		index_out_1 = 'd0;
		index_out_2 = 'd3;
		index_out_3 = 'd4;
		index_out_4 = 'd5;
	end
	'b0111:	
	begin
		index_out_1 = 'd3;
		index_out_2 = 'd4;
		index_out_3 = 'd5;
		index_out_4 = 'd6;
	end
	'b1000:	
	begin
		index_out_1 = 'd0;
		index_out_2 = 'd1;
		index_out_3 = 'd2;
		index_out_4 = 'd4;
	end
	'b1001:	
	begin
		index_out_1 = 'd1;
		index_out_2 = 'd2;
		index_out_3 = 'd4;
		index_out_4 = 'd5;
	end
	'b1010:	
	begin
		index_out_1 = 'd0;
		index_out_2 = 'd2;
		index_out_3 = 'd4;
		index_out_4 = 'd5;
	end
	'b1011:	
	begin
		index_out_1 = 'd2;
		index_out_2 = 'd4;
		index_out_3 = 'd5;
		index_out_4 = 'd6;
	end
	'b1100:	
	begin
		index_out_1 = 'd0;
		index_out_2 = 'd1;
		index_out_3 = 'd4;
		index_out_4 = 'd5;
	end
	'b1101:	
	begin
		index_out_1 = 'd1;
		index_out_2 = 'd4;
		index_out_3 = 'd5;
		index_out_4 = 'd6;
	end
	'b1110:	
	begin
		index_out_1 = 'd0;
		index_out_2 = 'd4;
		index_out_3 = 'd5;
		index_out_4 = 'd6;
	end
	'b1111:	
	begin
		index_out_1 = 'd4;
		index_out_2 = 'd5;
		index_out_3 = 'd6;
		index_out_4 = 'd7;
	end
	default
	begin
		index_out_1 = 'd0;
		index_out_2 = 'd0;
		index_out_3 = 'd0;
		index_out_4 = 'd0;
	end
endcase



endmodule
