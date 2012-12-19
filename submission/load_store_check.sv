//Programmer:	Shuying Fan
//Date:		12/02/2012
//Purpose:	Check if multiple load/store instructions in the four

module load_store_check
  (
   input [3:0] 	op1,
   input [3:0] 	op2,
   input [3:0] 	op3,
   input [3:0] 	op4,

   input logic 	ins1_history,
   input logic 	ins2_history,
   input logic 	ins3_history,
   input logic 	ins4_history,

   output logic ins1_out,
   output logic ins2_out,
   output logic ins3_out,
   output logic ins4_out,

   output logic ins1_swap, //swap signal is used in another module to connect load/store instructions to the fourth ALU.
   output logic ins2_swap,
   output logic ins3_swap, //
   output logic ins4_swap
   );

   always_comb
     begin
	if (ins1_history == 1)
	  begin
	     ins1_out = 'd1;
	     if (op1 == 4'b0010 || op1 == 4'b0100)	// ins1 is the first valid mem instruction
	       begin
		  ins1_swap = 'd0;		//then no instructions need to be swapped no matter what.
		  ins2_swap = 'd0;
		  ins3_swap = 'd0;
		  ins4_swap = 'd0;
		  
		  if (ins2_history == 1)
		    begin
		       if(op2 == 4'b0010 || op2 == 4'b0100)	// if the ins2 is also a history-valid memory instruction, it can't be issued
			 begin
			    ins2_out = 'd0;
			    ins3_out = 'd0;
			    ins4_out = 'd0;
			 end
		       else	// ins2 is a valid non-mem ins
			 begin
			    ins2_out = 'd1;
			    if (ins3_history == 1)
			      begin
				 if (op3 == 4'b0010 || op3 == 4'b0100)	//ins3 is the second history-valid mem ins
				   begin
				      ins3_out = 'd0;
				      ins4_out = 'd0;
				   end
				 else
				   begin
				      ins3_out = 'd1;
				      if (ins4_history == 1)
					begin
					   if (op4 == 4'b0010 || 4'b0100)	//ins4 is the second history-valid mem ins
					     begin
						ins4_out = 'd0;
					     end
					   else
					     begin
						ins4_out = 'd1;
					     end

					end
				      else
					begin
					   ins4_out = 'd0;
					end
				   end
			      end
			    else	//ins1 mem, ins2 non-mem, ins3 invalid
			      begin
				 ins3_out = 'd0;	
				 if (ins4_history == 1)
				   begin
				      if (op4 == 4'b0010 || op4 == 4'b0100)
					begin
					   ins4_out = 'd0;
					end
				      else
					begin
					   ins4_out = 'd1;
					end
				   end
				 else
				   begin
				      ins4_out = 'd0;
				   end
			      end
			 end

		    end
		  else
		    begin
		       ins2_out = 'd0;	//ins2 is not valid in history
		       if (ins3_history == 1)	//ins3 is valid in history
			 begin
			    if (op3 == 4'b0010 || op3 == 4'b0100)
			      begin
				 ins3_out = 'd0;
				 ins4_out = 'd0;
			      end
			    else
			      begin
				 ins3_out = 'd1;
				 if (ins4_history == 1)
				   begin
				      if (op4 == 4'b0010 || op4 == 4'b0100)
					begin
					   ins4_out = 'd0;
					end
				      else
					begin
					   ins4_out = 'd1;
					end
				   end
				 else
				   begin
				      ins4_out = 'd0;
				   end
			      end
			 end
		       else	// both ins2 and ins3 are not valid in history
			 begin
			    ins3_out = 'd0;
			    if (ins4_history == 1)
			      begin
				 if (op4 == 4'b0010 || op4 == 4'b0100)
				   begin
				      ins4_out = 'd0;
				   end
				 else
				   begin
				      ins4_out = 'd1;
				   end
			      end
			    else
			      begin
				 ins4_out = 'd0;	
			      end
			 end
		    end

	       end
	     else         //ins1 is valid in history but is not a memory instruction
	       begin
		  ins1_out = 'd1;
		  if(ins2_history == 1)
		    begin
		       if (op2 == 4'b0010 || op2 ==4'b0100)	//ins2 is the first memory instruction in the four instructions
			 begin
			    ins2_out = 'd1;
			    
			    ins1_swap = 'd1;		//therefore, instructions 1, 2 need to be swapped later.
			    ins2_swap = 'd1;
			    ins3_swap = 'd0;
			    ins4_swap = 'd0;

			    if (ins3_history == 1)
			      begin
				 if (op3 == 4'b0010 || op3 == 4'b0100)	//ins3 is the second mem ins
				   begin
				      ins3_out = 'd0;
				      ins4_out = 'd0;
				   end
				 else
				   begin
				      ins3_out = 'd1;
				      if (ins4_history == 1)
					begin
					   if (op4 == 4'b0010 || op4 == 4'b0100)
					     begin
						ins4_out = 'd0;
					     end
					   else
					     begin
						ins4_out = 'd1;
					     end

					end
				      else
					begin
					   ins4_out = 'd0;
					end
				   end

			      end
			    else	//ins3 is not valid in history
			      begin
				 ins3_out = 'd0;
				 if (ins4_history == 1)
				   begin
				      if (op4 == 4'b0010 || op4 == 4'b0100)
					begin
					   ins4_out = 'd0;
					end
				      else
					begin
					   ins4_out = 'd1;
					end
				   end
				 else
				   begin
				      ins4_out = 'd0;
				   end

			      end

			 end
		       else	//ins2 is valid in history but not a mem ins (same for ins1)
			 begin
			    ins2_out = 'd1;
			    if (ins3_history == 1)
			      begin
				 if (op3 == 4'b0010 || op3 == 4'b0100) 	//ins3 is the first valid mem instr
				   begin
				      ins3_out = 'd1;

				      ins1_swap = 'd1;		//ins1,3 need to be swapped later
				      ins2_swap = 'd0;
				      ins3_swap = 'd1;
				      ins4_swap = 'd0;

				      if (ins4_history == 1)
					begin
					   if (op4 == 4'b0010 || op4 == 4'b0100)
					     begin
						ins4_out = 'd0;
					     end
					   else 
					     begin
						ins4_out = 'd1;
					     end
					end
				      else
					begin
					   ins4_out = 'd0;
					end
				   end
				 else	// ins1,2,3 are not mem ins
				   begin
				      ins3_out = 'd1;
				      if (ins4_history == 1)
					begin
					   ins4_out = 'd1;

					   if (op4 == 4'b0010 || op4 == 4'b0100)
					     begin
						
						ins1_swap = 'd1;
						ins2_swap = 'd0;
						ins3_swap = 'd0;
						ins4_swap = 'd1;

					     end
					   else
					     begin

						ins1_swap = 'd0;
						ins2_swap = 'd0;
						ins3_swap = 'd0;
						ins4_swap = 'd0;

					     end

					end
				      else
					begin
					   ins4_out = 'd0;
					end
				   end

			      end
			    else	// ins3 is not valid in history, ins1, 2 are valid but not mem instructions
			      begin
				 ins3_out = 'd0;
				 if (ins4_history == 1)
				   begin
				      ins4_out = 'd1;

				      if (op4 == 4'b0010 || op4 == 4'b0100)
					begin
					   
					   ins1_swap = 'd1;
					   ins2_swap = 'd0;
					   ins3_swap = 'd0;
					   ins4_swap = 'd1;
					end
				      else
					begin
					   ins1_swap = 'd0;
					   ins2_swap = 'd0;
					   ins3_swap = 'd0;
					   ins4_swap = 'd0;
					end
				   end
				 else
				   begin
				      ins4_out = 'd0;
				      
				      ins1_swap = 'd0;
				      ins2_swap = 'd0;
				      ins3_swap = 'd0;
				      ins4_swap = 'd0;


				   end
			      end
			 end
		    end
		  else	//ins1 is valid, not mem. ins2 is invalid in history
		    begin
		       ins2_out = 'd0;
		       if (ins3_history == 1)
			 begin
			    ins3_out = 'd1;
			    if (op3 == 4'b0010 || op3 == 4'b0100)	//ins3 is the first valid mem ins
			      begin
				 
				 ins1_swap = 'd1;
				 ins2_swap = 'd0;
				 ins3_swap = 'd1;
				 ins4_swap = 'd0;

				 if (ins4_history == 1)
				   begin
				      if (op4 == 4'b0010 || op4 == 4'b0100)
					begin
					   ins4_out = 'd0;
					end
				      else
					begin
					   ins4_out = 'd1;
					end
				   end
				 else
				   begin
				      ins4_out = 'd0;
				   end
			      end
			    else	//ins3 is valid but not mem ins
			      begin
				 if (ins4_history == 1)
				   begin
				      ins4_out = 'd1;

				      if (op4 == 4'b0010 || op4 == 4'b0100)	//ins4 is the first valid mem ins
					begin
					   
					   ins1_swap = 'd1;
					   ins2_swap = 'd0;
					   ins3_swap = 'd0;
					   ins4_swap = 'd1;
					end
				      else
					begin
					   ins1_swap = 'd0;
					   ins2_swap = 'd0;
					   ins3_swap = 'd0;
					   ins4_swap = 'd0;
					end

				   end
				 else
				   begin
				      ins4_out = 'd0;

				      ins1_swap = 'd0;
				      ins2_swap = 'd0;
				      ins3_swap = 'd0;
				      ins4_swap = 'd0;

				   end
			      end
			 end
		       else	// ins1 is valid, not mem. ins2,3 are not valid
			 begin
			    ins3_out = 'd0;
			    if (ins4_history == 1)
			      begin
				 ins4_out = 'd1;

				 if (op4 == 4'b0010 || op4 == 4'b0100)	//ins4 is the first valid mem ins
				   begin
				      
				      ins1_swap = 'd1;
				      ins2_swap = 'd0;
				      ins3_swap = 'd0;
				      ins4_swap = 'd1;
				   end
				 else
				   begin
				      ins1_swap = 'd0;
				      ins2_swap = 'd0;
				      ins3_swap = 'd0;
				      ins4_swap = 'd0;
				   end

			      end
			    else
			      begin
				 ins4_out = 'd0;

				 ins1_swap = 'd0;
				 ins2_swap = 'd0;
				 ins3_swap = 'd0;
				 ins4_swap = 'd0;

			      end
			 end
		    end
	       end
	  end
	else	//ins1 is not valid in history
	  begin
	     ins1_out = 'd0;

	     if (ins2_history == 1)
	       begin
		  ins2_out = 'd1;
		  if (op2 == 4'b0010 || op2 == 4'b0100)
		     
		    begin
		       ins1_swap = 'd1;
		       ins2_swap = 'd1;
		       ins3_swap = 'd0;
		       ins4_swap = 'd0;

		       if (ins3_history == 1)
			 begin
			    if (op3 == 4'b0010 || op3 == 4'b0100)
			      begin
				 ins3_out = 'd0;
				 ins4_out = 'd0;
			      end
			    else	// ins3 is not a mem ins
			      begin
				 ins3_out = 'd1;
				 if (ins4_history == 1)
				   begin
				      if (op4 == 4'b0010 || op4 == 4'b0100)
					begin
					   ins4_out = 'd0;
					end
				      else
					ins4_out = 'd1;
				      begin
				      end
				   end
				 else
				   begin
				      ins4_out = 'd0;
				   end
			      end
			 end
		       else	// ins3 is not valid in history
			 begin
			    ins3_out = 'd0;
			    if (ins4_history == 1)
			      begin
				 if (op4 == 4'b0010 || op4 == 4'b0100)
				   begin
				      ins4_out = 'd0;
				   end
				 else
				   begin
				      ins4_out = 'd1;
				   end
			      end
			    else
			      begin
				 ins4_out = 'd0;
			      end
			 end
		    end
		  else	//ins2 is not a mem instruction
		    begin
		       if (ins3_history == 1)
			 begin
			    ins3_out = 'd1;
			    if (op3 == 4'b0010 || op3 == 4'b0100)
			       
			      begin
				 ins1_swap = 'd1;
				 ins2_swap = 'd0;
				 ins3_swap = 'd1;
				 ins4_swap = 'd0;

				 if (ins4_history == 1)
				   begin
				      if (op4 == 4'b0010 || op4 == 4'b0100)
					begin
					   ins4_out = 'd0;
					end
				      else
					begin
					   ins4_out = 'd1;
					end
				   end
				 else
				   begin
				      ins4_out = 'd0;
				   end
			      end
			    else	// ins3 is not a mem instruction
			      begin
				 if (ins4_history == 1)
				   begin
				      ins4_out = 'd1;

				      if (op4 == 4'b0010 || op4 == 4'b0100)
					begin
					   ins1_swap = 'd1;
					   ins2_swap = 'd0;
					   ins3_swap = 'd0;
					   ins4_swap = 'd1;
					end
				      else
					begin
					   ins1_swap = 'd0;
					   ins2_swap = 'd0;
					   ins3_swap = 'd0;
					   ins4_swap = 'd0;

					end
				   end
				 else
				   begin
				      ins4_out = 'd0;

				      ins1_swap = 'd0;
				      ins2_swap = 'd0;
				      ins3_swap = 'd0;
				      ins4_swap = 'd0;

				   end
			      end
			 end
		       else	//ins3 is not valid in history (at this point, ins 1 is invalid, ins2 is not a mem ins)
			 begin
			    ins3_out = 'd0;
			    if (ins4_history == 1)
			      begin
				 ins4_out = 'd1;

				 if (op4 == 4'b0010 || op4 == 4'b0100)
				   begin
				      ins1_swap = 'd1;
				      ins2_swap = 'd0;
				      ins3_swap = 'd0;
				      ins4_swap = 'd1;							
				   end
				 else
				   begin
				      ins1_swap = 'd0;
				      ins2_swap = 'd0;
				      ins3_swap = 'd0;
				      ins4_swap = 'd0;
				   end

			      end
			    else
			      begin
				 ins4_out = 'd0;
				 ins1_swap = 'd0;
				 ins2_swap = 'd0;
				 ins3_swap = 'd0;
				 ins4_swap = 'd0;

			      end
			 end
		    end
	       end
	     else	//ins2  is invalid in history (ins1 is also invalid)
	       begin
		  ins2_out = 'd0;
		  if (ins3_history == 1)
		    begin
		       ins3_out = 'd1;
		       if (op3 == 4'b0010 || op3 == 4'b0100)
			 begin
			    ins1_swap = 'd1;
			    ins2_swap = 'd0;
			    ins3_swap = 'd1;
			    ins4_swap = 'd0;

			    if (ins4_history == 1)
			      begin
				 if (op4 == 4'b0010 || op4 == 4'b0100)
				   begin
				      ins4_out = 'd0;
				   end
				 else
				   begin
				      ins4_out = 'd1;
				   end
			      end
			    else
			      begin
				 ins4_out = 'd0;
			      end
			 end
		       else	//ins3 is not a mem ins
			 begin
			    if (ins4_history == 1)
			      begin
				 ins4_out = 'd1;

				 if (op4 == 4'b0010 || op4 == 4'b0100)
				   begin
				      ins1_swap = 'd1;
				      ins2_swap = 'd0;
				      ins3_swap = 'd0;
				      ins4_swap = 'd1;
				   end
				 else
				   begin
				      ins1_swap = 'd0;
				      ins2_swap = 'd0;
				      ins3_swap = 'd0;
				      ins4_swap = 'd0;
				   end

			      end
			    else
			      begin
				 ins4_out = 'd0;

				 ins1_swap = 'd0;
				 ins2_swap = 'd0;
				 ins3_swap = 'd0;
				 ins4_swap = 'd0;

			      end
			 end
		    end
		  else	//ins1,2,3, are all invalid in history
		    begin
		       ins3_out = 'd0;
		       if (ins4_history == 1)
			 begin
			    ins4_out = 'd1;
			    if (op4 == 4'b0010 || op4 == 4'b0100)
			      begin
				 ins1_swap = 'd1;
				 ins2_swap = 'd0;
				 ins3_swap = 'd0;
				 ins4_swap = 'd1;
			      end
			    else
			      begin
				 ins1_swap = 'd0;
				 ins2_swap = 'd0;
				 ins3_swap = 'd0;
				 ins4_swap = 'd0;
			      end


			 end
		       else
			 begin
			    ins4_out = 'd0;

			    ins1_swap = 'd0;
			    ins2_swap = 'd0;
			    ins3_swap = 'd0;
			    ins4_swap = 'd0;
			 end
		    end
	       end

	  end

     end
endmodule

