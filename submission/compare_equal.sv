////////////////////////////////////////////////////////////////////////////
////	Module Name: compare_equal					////
////	Programmer: Shuying Fan						////
////	Date: 12/13							////
////	Function: Compare the two source registers for branches		////
////////////////////////////////////////////////////////////////////////////

//the branch we need to deal with for this pipeline design is bne. if not equal, we jump. the branch prediction strategy is "not taken"


module compare_equal	#(parameter data_width = 'd32)
   (
    input [3:0] 	   ins1_op,
    input [data_width-1:0] ins1_data1,
    input [data_width-1:0] ins1_data2,

    input [3:0] 	   ins2_op,
    input [data_width-1:0] ins2_data1,
    input [data_width-1:0] ins2_data2,

    input [3:0] 	   ins3_op,
    input [data_width-1:0] ins3_data1,
    input [data_width-1:0] ins3_data2,

    input [3:0] 	   ins4_op,
    input [data_width-1:0] ins4_data1,
    input [data_width-1:0] ins4_data2,

    output logic 	   bne1,
    output logic 	   bne2,
    output logic 	   bne3,
    output logic 	   bne4
    );


   always_comb
     begin
	if (ins1_op != 'b0001)	//if ins1 is not a branch, this valid signal is 0
	  bne1 = 'd0;
	else
	  begin
	     if (ins1_data1 == ins1_data2)	//means branch predict correctly
	       bne1 = 'd0;
	     else
	       bne1 = 'd1;
	  end


	if (ins2_op != 'b0001)	
	  bne2 = 'd0;
	else
	  begin
	     if (ins2_data1 == ins2_data2)	
	       bne2 = 'd0;
	     else
	       bne2 = 'd1;
	  end

	if (ins3_op != 'b0001)	
	  bne3 = 'd0;
	else
	  begin
	     if (ins3_data1 == ins3_data2)	
	       bne3 = 'd0;
	     else
	       bne3 = 'd1;
	  end

	if (ins4_op != 'b0001)	
	  bne4 = 'd0;
	else
	  begin
	     if (ins4_data1 == ins4_data2)
	       bne4 = 'd0;
	     else
	       bne4 = 'd1;
	  end

     end



endmodule
