//Programmer:	Tong Zhang
//Date:		12/02/2012
//Purpose:	Selecting index for the four entries of issue queue for the next cycle

module entry_select
(
	input [2:0]	ins_in,		//[ins4,ins3,ins2]
	output logic [2:0]	index_out_1,
	output logic [2:0]	index_out_2,
	output logic [2:0]	index_out_3,
	output logic [2:0]	index_out_4
);

always_comb
case (ins_in)
	'd0:	
	begin
		index_out_1 = 'd1;
		index_out_2 = 'd2;
		index_out_3 = 'd3;
		index_out_4 = 'd4;
	end
	'd1:	
	begin
		index_out_1 = 'd2;
		index_out_2 = 'd3;
		index_out_3 = 'd4;
		index_out_4 = 'd5;
	end
	'd2:	
	begin
		index_out_1 = 'd1;
		index_out_2 = 'd3;
		index_out_3 = 'd4;
		index_out_4 = 'd5;
	end
	'd3:	
	begin
		index_out_1 = 'd3;
		index_out_2 = 'd4;
		index_out_3 = 'd5;
		index_out_4 = 'd6;
	end
	'd4:	
	begin
		index_out_1 = 'd1;
		index_out_2 = 'd2;
		index_out_3 = 'd4;
		index_out_4 = 'd5;
	end
	'd5:	
	begin
		index_out_1 = 'd2;
		index_out_2 = 'd4;
		index_out_3 = 'd5;
		index_out_4 = 'd6;
	end
	'd6:	
	begin
		index_out_1 = 'd1;
		index_out_2 = 'd4;
		index_out_3 = 'd5;
		index_out_4 = 'd6;
	end
	'd7:	
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
