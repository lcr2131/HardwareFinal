////////////////////////////////////////////////////////////////////////////
////	Module Name: branch_priority					////
////	Programmer: Shuying Fan						////
////	Date: 12/13							////
////	Function: pick the first valid mispredicted branch 		////
////////////////////////////////////////////////////////////////////////////

module branch_priority
  (

   input 	      bne1,
   input 	      bne2,
   input 	      bne3,
   input 	      bne4,

   output logic [1:0] pick_branch,
   output logic       flush
   );

   always_comb
     begin 

	/*
	 casex (bne)
	 4'bxxx1:	begin pick_branch = 'd0; flush = 'd1; end	//the first branch is mispredicted.
	 4'bxx10:	begin pick_branch = 'd1; flush = 'd1; end
	 4'bx100:	begin pick_branch = 'd2; flush = 'd1; end
	 4'b1000:	begin pick_branch = 'd3; flush = 'd1; end
	 default: 	begin pick_branch = 'd3; flush = 'd0; end
endcase


	 */

	if (bne1)
	  begin
	     pick_branch = 'd0;
	     flush = 'd1;
	  end
	else
	  begin
	     if(bne2)
	       begin
		  pick_branch = 'd1;
		  flush = 'd1;
	       end
	     else
	       begin
		  if(bne3)
		    begin
		       pick_branch = 'd2;
		       flush = 'd1;
		    end
		  else
		    begin
		       pick_branch = 'd3;
		       flush = 'd1;
		    end
	       end
	     
	  end
     end


endmodule

