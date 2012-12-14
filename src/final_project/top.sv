//Programmer:	Tong Zhang
//Date:		12/11/2012
//Purpose:	Top module for stage 1, connecting pre_calculation_and_queue, all_checker and ins_swap for validation and verification


module top #(parameter des = 4, source1 = 4, source2 = 4, immediate = 4, branch_id = 3, total_in = 4 + des + source1 + source2,total_out = total_in + branch_id + 1 + immediate, reg_num = 16)
();
  

   bit 		clk = 0;
   always #5 clk = ~clk;

   initial $vcdpluson;


	pre_calculation_and_queue_interface i(clk);
	pre_calculation_and_queue q(i.pre_calculation_and_queue_dut); 
	
			

   //all_checker_interface all_checker_IFC(clk);   
   //all_checker	all_checker1(all_checker_IFC.all_checker_dut); 
   //testbench bench(all_checker_IFC.all_checker_bench);
 
endmodule
