//Programmer:	Tong Zhang
//Date:		12/10/2012
//Purpose:	calculation the shifting entry number based on feedback for shifting at next cycle

module shift_amount
  (
   input 	      ins_in_1, //control signals sent back from the checkers
   input 	      ins_in_2, 
   input 	      ins_in_3, 
   input 	      ins_in_4, 

   output logic [2:0] shift_entry1, //the number of entries an instruction need to be shifted
   output logic [2:0] shift_entry2,
   output logic [2:0] shift_entry3,
   output logic [2:0] shift_entry_rest
   );

   always_comb
     case ({ins_in_4,ins_in_3,ins_in_2,ins_in_1})
       'b0000:			//no instruction can be issued int the last cycle
	 begin
	    shift_entry1 = 'd0;
	    shift_entry2 = 'd0;
	    shift_entry3 = 'd0;
	    shift_entry_rest = 'd0;
	 end
       'b0001:
	 begin
	    shift_entry1 = 'd1;
	    shift_entry2 = 'd1;
	    shift_entry3 = 'd1;
	    shift_entry_rest = 'd1;
	 end
       'b0010:
	 begin
	    shift_entry1 = 'd0;
	    shift_entry2 = 'd1;
	    shift_entry3 = 'd1;
	    shift_entry_rest = 'd1;
	 end
       'b0011:
	 begin
	    shift_entry1 = 'd0;
	    shift_entry2 = 'd2;
	    shift_entry3 = 'd2;
	    shift_entry_rest = 'd2;
	 end
       'b0100:
	 begin
	    shift_entry1 = 'd0;
	    shift_entry2 = 'd0;
	    shift_entry3 = 'd1;
	    shift_entry_rest = 'd1;
	 end
       'b0101:
	 begin
	    shift_entry1 = 'd1;
	    shift_entry2 = 'd0;
	    shift_entry3 = 'd2;
	    shift_entry_rest = 'd2;
	 end
       'b0110:
	 begin
	    shift_entry1 = 'd0;
	    shift_entry2 = 'd0;
	    shift_entry3 = 'd2;
	    shift_entry_rest = 'd2;
	 end
       'b0111:
	 begin
	    shift_entry1 = 'd0;
	    shift_entry2 = 'd0;
	    shift_entry3 = 'd3;
	    shift_entry_rest = 'd3;
	 end
       'b1000:
	 begin
	    shift_entry1 = 'd0;
	    shift_entry2 = 'd0;
	    shift_entry3 = 'd0;
	    shift_entry_rest = 'd1;
	 end
       'b1001:
	 begin
	    shift_entry1 = 'd1;
	    shift_entry2 = 'd1;
	    shift_entry3 = 'd0;
	    shift_entry_rest = 'd2;
	 end
       'b1010:
	 begin
	    shift_entry1 = 'd0;
	    shift_entry2 = 'd1;
	    shift_entry3 = 'd0;
	    shift_entry_rest = 'd2;
	 end
       'b1011:
	 begin
	    shift_entry1 = 'd0;
	    shift_entry2 = 'd2;
	    shift_entry3 = 'd0;
	    shift_entry_rest = 'd3;
	 end
       'b1100:
	 begin
	    shift_entry1 = 'd0;
	    shift_entry2 = 'd0;
	    shift_entry3 = 'd0;
	    shift_entry_rest = 'd2;
	 end
       'b1101:
	 begin
	    shift_entry1 = 'd1;
	    shift_entry2 = 'd0;
	    shift_entry3 = 'd0;
	    shift_entry_rest = 'd3;
	 end
       'b1110:
	 begin
	    shift_entry1 = 'd0;
	    shift_entry2 = 'd0;
	    shift_entry3 = 'd0;
	    shift_entry_rest = 'd3;
	 end
       'b1111:
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
