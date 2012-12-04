//Programmer:	Tong Zhang 
//Date:		12/02/2012 
//Purpose:	calculation the shifting entry number based on feedback for shifting at next cycle 

module shift_amount 
( 
	input [2:0]	ins_in,		//[ins4,ins3,ins2] 

	output logic [2:0]	shift_entry1, 
	output logic [2:0]	shift_entry2, 
	output logic [2:0]	shift_entry3, 
	output logic [2:0]	shift_entry_rest 
); 

always_comb 
case (ins_in) 
	'd0: 
	begin 
		shift_entry1 = 'd1; 
		shift_entry2 = 'd1; 
		shift_entry3 = 'd1; 
		shift_entry_rest = 'd1; 
	end 
	'd1: 
	begin 
		shift_entry1 = 'd0; 
		shift_entry2 = 'd2; 
		shift_entry3 = 'd2; 
		shift_entry_rest = 'd2; 
	end 
	'd2: 
	begin 
		shift_entry1 = 'd1; 
		shift_entry2 = 'd0; 
		shift_entry3 = 'd2; 
		shift_entry_rest = 'd2; 
	end 
	'd3: 
	begin 
		shift_entry1 = 'd0; 
		shift_entry2 = 'd0; 
		shift_entry3 = 'd3; 
		shift_entry_rest = 'd3; 
	end 
	'd4: 
	begin 
		shift_entry1 = 'd1; 
		shift_entry2 = 'd1; 
		shift_entry3 = 'd0; 
		shift_entry_rest = 'd2; 
	end 
	'd5: 
	begin 
		shift_entry1 = 'd0; 
		shift_entry2 = 'd2; 
		shift_entry3 = 'd0; 
		shift_entry_rest = 'd3; 
	end 
	'd6: 
	begin 
		shift_entry1 = 'd1; 
		shift_entry2 = 'd0; 
		shift_entry3 = 'd0; 
		shift_entry_rest = 'd3; 
	end 
	'd7: 
	begin 
		shift_entry1 = 'd0; 
		shift_entry2 = 'd0; 
		shift_entry3 = 'd0; 
		shift_entry_rest = 'd4; 
	end 
	default 
	begin 
		shift_entry1 = 'd0; 
		shift_entry2 = 'd0; 
		shift_entry3 = 'd0; 
		shift_entry_rest = 'd0; 
	end 
endcase 


endmodule
