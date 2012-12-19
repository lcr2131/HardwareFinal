//Programmer:	Tong Zhang
//Date:		12/11/2012
//Purpose:	Top module for stage 1, connecting pre_calculation_and_queue, all_checker and ins_swap for validation and verification


module top #(parameter des = 4, source1 = 4, source2 = 4, immediate = 4, branch_id = 3, total_in = 4 + des + source1 + source2,total_out = total_in + branch_id + 1 + immediate, reg_num = 16)
   ();
   

   bit 		clk = 0;
   always #5 clk = ~clk;

   initial $vcdpluson;

   decode_interface decode_IFC(clk);
   decode decode1(decode_IFC.decode_dut);
   
   pre_calculation_and_queue_interface pre_calculation_and_queue_IFC(clk);
   pre_calculation_and_queue pre_calculation_and_queue1(pre_calculation_and_queue_IFC.pre_calculation_and_queue_dut); 
   
   ins_swap_interface ins_swap_IFC(clk);
   ins_swap ins_swap1(ins_swap_IFC.ins_swap_dut);
   
   register_file_interface register_file_IFC(clk);
   register_file register_file1(register_file_IFC.register_file_dut);

   top_issue_stage_interface top_issue_stage_IFC(clk);
   top_issue_stage top_issue1(top_issue_stage_IFC.top_issue_stage_dut);
   
   
   all_checker_interface all_checker_IFC(clk);   
   all_checker	all_checker1(all_checker_IFC.all_checker_dut); 
   
   testbench bench(
		   decode_IFC.decode_bench,
		   pre_calculation_and_queue_IFC.pre_calculation_and_queue_bench,
		   all_checker_IFC.all_checker_bench,
		   ins_swap_IFC.ins_swap_bench,
		   register_file_IFC.register_file_bench,
		   top_issue_stage_IFC.top_issue_stage_bench
		   );
   
endmodule