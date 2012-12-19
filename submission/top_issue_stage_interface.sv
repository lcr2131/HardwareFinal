interface top_issue_stage_interface(input bit clk);

   //parameter des = 'd4; source1 = 'd4; source2 = 'd4; immediate = 'd5;
   //	branch_id = 'd3; total_in = 4 + des + source1 + source2;
   //	total_out = total_in + branch_id + 'd1 + immediate; 
   //	reg_num = 'd16
   
   logic		rst;
   logic [31:0] 	new_instr1_in;
   logic [31:0] 	new_instr2_in;

   logic		ins_new_1_vld;
   logic		ins_new_2_vld;

   logic		flush_en;
   logic [2:0] 		flush_id;
   logic [15:0] 	flush_reg;


   logic		ins_back_1_vld;			
   logic [3:0] 		ins_back_1_des;
   logic		ins_back_2_vld;
   logic [3:0] 		ins_back_2_des;
   logic		ins_back_3_vld;
   logic [3:0] 		ins_back_3_des;
   logic		ins_back_4_vld;
   logic [3:0] 		ins_back_4_des;
   

   logic		iq_full;
   logic		iq_empty;
   logic		branch_full;

   logic		iq_out_1_vld;
   logic [3:0] 		iq_out_1_des;
   logic [3:0] 		iq_out_1_s1;
   logic [3:0] 		iq_out_1_s2;
   logic [3:0] 		iq_out_1_op;
   logic [2:0] 		iq_out_1_bid;
   logic [4:0] 		iq_out_1_ime;

   logic		iq_out_2_vld;
   logic [3:0] 		iq_out_2_des;
   logic [3:0] 		iq_out_2_s1;
   logic [3:0] 		iq_out_2_s2;
   logic [3:0] 		iq_out_2_op;
   logic [2:0] 		iq_out_2_bid;
   logic [4:0] 		iq_out_2_ime;

   logic		iq_out_3_vld;
   logic [3:0] 		iq_out_3_des;
   logic [3:0] 		iq_out_3_s1;
   logic [3:0] 		iq_out_3_s2;
   logic [3:0] 		iq_out_3_op;
   logic [2:0] 		iq_out_3_bid;
   logic [4:0] 		iq_out_3_ime;
   logic		iq_out_4_vld;
   logic [3:0] 		iq_out_4_des;
   logic [3:0] 		iq_out_4_s1;
   logic [3:0] 		iq_out_4_s2;
   logic [3:0] 		iq_out_4_op;
   logic [2:0] 		iq_out_4_bid;
   logic [4:0] 		iq_out_4_ime;

   clocking top_issue_stage_cb @(posedge clk);
      output 		rst,

			new_instr1_in,
			new_instr2_in,

			ins_new_1_vld,
			ins_new_2_vld,

 			flush_en,

			flush_id,
			flush_reg,


			ins_back_1_vld,			
			ins_back_1_des,
			ins_back_2_vld,
			ins_back_2_des,
			ins_back_3_vld,
			ins_back_3_des,
			ins_back_4_vld,
			ins_back_4_des;
      

      input 		iq_full,
		 	iq_empty,
			branch_full,

			iq_out_1_vld,
			iq_out_1_des,
			iq_out_1_s1,
			iq_out_1_s2,
			iq_out_1_op,
			iq_out_1_bid,
			iq_out_1_ime,

			iq_out_2_vld,
			iq_out_2_des,
			iq_out_2_s1,
			iq_out_2_s2,
			iq_out_2_op,
			iq_out_2_bid,
			iq_out_2_ime,

			iq_out_3_vld,
			iq_out_3_des,
			iq_out_3_s1,
			iq_out_3_s2,
			iq_out_3_op,
			iq_out_3_bid,
			iq_out_3_ime,

			iq_out_4_vld,
			iq_out_4_des,
			iq_out_4_s1,
			iq_out_4_s2,
			iq_out_4_op,
			iq_out_4_bid,
			iq_out_4_ime;
   endclocking

   modport top_issue_stage_dut(
			       input  clk,
			       input  rst,

			       input  new_instr1_in,
			       input  new_instr2_in,

			       input  ins_new_1_vld,
			       input  ins_new_2_vld,

 			       input  flush_en,

			       input  flush_id,
			       input  flush_reg,


			       input  ins_back_1_vld, 
			       input  ins_back_1_des,
			       input  ins_back_2_vld,
			       input  ins_back_2_des,
			       input  ins_back_3_vld,
			       input  ins_back_3_des,
			       input  ins_back_4_vld,
			       input  ins_back_4_des,
   

			       output iq_full,
			       output iq_empty,
			       output branch_full,

			       output iq_out_1_vld,
			       output iq_out_1_des,
			       output iq_out_1_s1,
			       output iq_out_1_s2,
			       output iq_out_1_op,
			       output iq_out_1_bid,
			       output iq_out_1_ime,

			       output iq_out_2_vld,
			       output iq_out_2_des,
			       output iq_out_2_s1,
			       output iq_out_2_s2,
			       output iq_out_2_op,
			       output iq_out_2_bid,
			       output iq_out_2_ime,

			       output iq_out_3_vld,
			       output iq_out_3_des,
			       output iq_out_3_s1,
			       output iq_out_3_s2,
			       output iq_out_3_op,
			       output iq_out_3_bid,
			       output iq_out_3_ime,

			       output iq_out_4_vld,
			       output iq_out_4_des,
			       output iq_out_4_s1,
			       output iq_out_4_s2,
			       output iq_out_4_op,
			       output iq_out_4_bid,
			       output iq_out_4_ime
			       );

   modport top_issue_stage_bench(clocking top_issue_stage_cb);
endinterface

