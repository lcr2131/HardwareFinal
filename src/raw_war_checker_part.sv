//Programmer:	Tong Zhang 
//Date:		12/02/2012 
//Purpose:	For checker after issue queue, checking for war and raw hazards for two instructions 

module raw_war_checker_part #(parameter des = 'd4, source1 = 'd4, source2 = 'd4) 
( 
	input [des-1 : 0] des1, 
	input [des-1 : 0] des2, 
	input [source1-1 : 0] s11, 
	input [source2-1 : 0] s12, 
	input [source1-1 : 0] s21, 
	input [source2-1 : 0] s22, 

	output logic hazard_flag 
); 

//assign hazard_flag = (des1 == s21) || (des1 == s22) || (des2 == s11) || (des2 == s12); 

always_comb 
begin 
	if (((des1 == s21) || (des1 == s22)) && (~des1)) 
		hazard_flag = 'd1; 
	else if (((des2 == s11) || (des2 == s12)) && (~des2)) 
		hazard_flag = 'd1; 
	else 
		hazard_flag = 'd0; 
end 

endmodule
