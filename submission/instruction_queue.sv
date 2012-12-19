//Programmer:	Tong Zhang
//Date:		12/11/2012
//Purpose:	instruction queue, with valid bit, ready bit, op code, 
//		destination, source left, source right and branch ID. 
//		It issue four, write two new, and do the shift every cycle

module instruction_queue #(parameter des = 'd4, source1 = 'd4, source2 = 'd4, immediate = 'd5,
			   branch_id = 'd3, total_in = 4 + des + source1 + source2,
			   total_out = total_in + branch_id + 'd1 + immediate )
   (
    input 		       clk,
    input 		       rst,
   
    input [2:0] 	       entry_in_1, //inputs from entry_select
    input [2:0] 	       entry_in_2,
    input [2:0] 	       entry_in_3,
    input [2:0] 	       entry_in_4,
   
    input [2:0] 	       shift_entry1, //inputs from shift_amount
    input [2:0] 	       shift_entry2,
    input [2:0] 	       shift_entry3,
    input [2:0] 	       shift_entry_rest, 

    //	input	ins_new_en,		
    input 		       ins_new_1_vld, //inputs of the entire pipeline to indicate whether the instructions fetched into the pipeline are valid
    input 		       ins_new_2_vld,
   
    input [3:0] 	       ins_new_1_addr, //inputs from new_ins_cal for instruction allocation
    input [3:0] 	       ins_new_2_addr,

    input 		       flush_en, //inputs from branch_ctrl
    input [2:0] 	       flush_id,

    input [des-1:0] 	       ins_1_des, //inputs from decoder
    input [source1-1:0]        ins_1_s1,
    input [source2-1:0]        ins_1_s2,
    input [3:0] 	       ins_1_op,
    input [immediate-1:0]      ins_1_ime,

    input [des-1:0] 	       ins_2_des,
    input [source1-1:0]        ins_2_s1,
    input [source2-1:0]        ins_2_s2,
    input [3:0] 	       ins_2_op,
    input [immediate-1:0]      ins_2_ime,

    output reg 		       entry_full,
    output reg 		       entry_empty,
    output reg 		       branch_full,

    output reg 		       out_1_vld,
    output reg [des-1:0]       out_1_des,
    output reg [source1-1:0]   out_1_s1,
    output reg [source2-1:0]   out_1_s2,
    output reg [3:0] 	       out_1_op,
    output reg [branch_id-1:0] out_1_branch,
    output reg [immediate-1:0] out_1_ime,

    output reg 		       out_2_vld,
    output reg [des-1:0]       out_2_des,
    output reg [source1-1:0]   out_2_s1,
    output reg [source2-1:0]   out_2_s2,
    output reg [3:0] 	       out_2_op,
    output reg [branch_id-1:0] out_2_branch,
    output reg [immediate-1:0] out_2_ime,

    output reg 		       out_3_vld,
    output reg [des-1:0]       out_3_des,
    output reg [source1-1:0]   out_3_s1,
    output reg [source2-1:0]   out_3_s2,
    output reg [3:0] 	       out_3_op,
    output reg [branch_id-1:0] out_3_branch,
    output reg [immediate-1:0] out_3_ime,

    output reg 		       out_4_vld,
    output reg [des-1:0]       out_4_des,
    output reg [source1-1:0]   out_4_s1,
    output reg [source2-1:0]   out_4_s2,
    output reg [3:0] 	       out_4_op,
    output reg [branch_id-1:0] out_4_branch,
    output reg [immediate-1:0] out_4_ime
    );

   reg [total_out-1:0] 	       entry_0;
   reg [total_out-1:0] 	       entry_1;
   reg [total_out-1:0] 	       entry_2;
   reg [total_out-1:0] 	       entry_3;
   reg [total_out-1:0] 	       entry_4;
   reg [total_out-1:0] 	       entry_5;
   reg [total_out-1:0] 	       entry_6;
   reg [total_out-1:0] 	       entry_7;
   reg [total_out-1:0] 	       entry_8;
   reg [total_out-1:0] 	       entry_9;
   reg [total_out-1:0] 	       entry_10;
   reg [total_out-1:0] 	       entry_11;
   reg [total_out-1:0] 	       entry_12;
   reg [total_out-1:0] 	       entry_13;
   reg [total_out-1:0] 	       entry_14;
   reg [total_out-1:0] 	       entry_15;

   //	logic	[total_out-1:0]	reg_tmp1;
   reg [3:0] 		       branch_id_cnt;
   logic [2:0] 		       branch_id_ins1;
   logic [2:0] 		       branch_id_ins2;


   /////////////////////////////////////////////////////////////////////////////////////
   //Output selected entries	Function 1: deallocation

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  begin
	     out_1_vld <= 'd0;
	     out_1_des <= 'd0;
	     out_1_s1 <= 'd0;
	     out_1_s2 <= 'd0;
	     out_1_op <= 'd0;
	     out_1_branch <= 'd0;
	     out_1_ime <= 'd0;
	  end
	else if (entry_in_1 == 'd0)
	  begin
	     if (~entry_0[total_out-1])
	       begin
		  out_1_vld <= 'd0;
		  out_1_des <= 'd0;
		  out_1_s1 <= 'd0;
		  out_1_s2 <= 'd0;
		  out_1_op <= 'd0;
		  out_1_branch <= 'd0;
		  out_1_ime <= 'd0;
	       end
	     else
	       begin
		  out_1_vld <= 'd1;
		  out_1_des <= entry_0[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_1_s1 <= entry_0[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_1_s2 <= entry_0[immediate+branch_id+source2-1:immediate+branch_id];
		  out_1_op <= entry_0[total_out-2:total_out-5];
		  out_1_branch <= entry_0[immediate+branch_id-1:immediate];
		  out_1_ime <= entry_0[immediate-1:0];
	       end
	  end
	else if (entry_in_1 == 'd1)
	  begin
	     if (~entry_1[total_out-1])
	       begin
		  out_1_vld <= 'd0;
		  out_1_des <= 'd0;
		  out_1_s1 <= 'd0;
		  out_1_s2 <= 'd0;
		  out_1_op <= 'd0;
		  out_1_branch <= 'd0;
		  out_1_ime <= 'd0;
	       end
	     else
	       begin
		  out_1_vld <= 'd1;
		  out_1_des <= entry_1[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_1_s1 <= entry_1[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_1_s2 <= entry_1[immediate+branch_id+source2-1:immediate+branch_id];
		  out_1_op <= entry_1[total_out-2:total_out-5];
		  out_1_branch <= entry_1[immediate+branch_id-1:immediate];
		  out_1_ime <= entry_1[immediate-1:0];
	       end
	  end
	else if (entry_in_1 == 'd2)
	  begin
	     if (~entry_2[total_out-1])
	       begin
		  out_1_vld <= 'd0;
		  out_1_des <= 'd0;
		  out_1_s1 <= 'd0;
		  out_1_s2 <= 'd0;
		  out_1_op <= 'd0;
		  out_1_branch <= 'd0;
		  out_1_ime <= 'd0;
	       end
	     else
	       begin
		  out_1_vld <= 'd1;
		  out_1_des <= entry_2[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_1_s1 <= entry_2[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_1_s2 <= entry_2[immediate+branch_id+source2-1:immediate+branch_id];
		  out_1_op <= entry_2[total_out-2:total_out-5];
		  out_1_branch <= entry_2[immediate+branch_id-1:immediate];
		  out_1_ime <= entry_2[immediate-1:0];
	       end
	  end
	else if (entry_in_1 == 'd3)
	  begin
	     if (~entry_3[total_out-1])
	       begin
		  out_1_vld <= 'd0;
		  out_1_des <= 'd0;
		  out_1_s1 <= 'd0;
		  out_1_s2 <= 'd0;
		  out_1_op <= 'd0;
		  out_1_branch <= 'd0;
		  out_1_ime <= 'd0;
	       end
	     else
	       begin
		  out_1_vld <= 'd1;
		  out_1_des <= entry_3[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_1_s1 <= entry_3[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_1_s2 <= entry_3[immediate+branch_id+source2-1:immediate+branch_id];
		  out_1_op <= entry_3[total_out-2:total_out-5];
		  out_1_branch <= entry_3[immediate+branch_id-1:immediate];
		  out_1_ime <= entry_3[immediate-1:0];
	       end
	  end
	else if (entry_in_1 == 'd4)
	  begin
	     if (~entry_4[total_out-1])
	       begin
		  out_1_vld <= 'd0;
		  out_1_des <= 'd0;
		  out_1_s1 <= 'd0;
		  out_1_s2 <= 'd0;
		  out_1_op <= 'd0;
		  out_1_branch <= 'd0;
		  out_1_ime <= 'd0;
	       end
	     else
	       begin
		  out_1_vld <= 'd1;
		  out_1_des <= entry_4[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_1_s1 <= entry_4[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_1_s2 <= entry_4[immediate+branch_id+source2-1:immediate+branch_id];
		  out_1_op <= entry_4[total_out-2:total_out-5];
		  out_1_branch <= entry_4[immediate+branch_id-1:immediate];
		  out_1_ime <= entry_4[immediate-1:0];
	       end
	  end
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  begin
	     out_2_vld <= 'd0;
	     out_2_des <= 'd0;
	     out_2_s1 <= 'd0;
	     out_2_s2 <= 'd0;
	     out_2_op <= 'd0;
	     out_2_branch <= 'd0;
	     out_2_ime <= 'd0;
	  end
	else if (entry_in_2 == 'd1)
	  begin
	     if (~entry_1[total_out-1])
	       begin
		  out_2_vld <= 'd0;
		  out_2_des <= 'd0;
		  out_2_s1 <= 'd0;
		  out_2_s2 <= 'd0;
		  out_2_op <= 'd0;
		  out_2_branch <= 'd0;
		  out_2_ime <= 'd0;
	       end
	     else
	       begin
		  out_2_vld <= 'd1;
		  out_2_des <= entry_1[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_2_s1 <= entry_1[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_2_s2 <= entry_1[immediate+branch_id+source2-1:immediate+branch_id];
		  out_2_op <= entry_1[total_out-2:total_out-5];
		  out_2_branch <= entry_1[immediate+branch_id-1:immediate];
		  out_2_ime <= entry_1[immediate-1:0];
	       end
	  end
	else if (entry_in_2 == 'd2)
	  begin
	     if (~entry_2[total_out-1])
	       begin
		  out_2_vld <= 'd0;
		  out_2_des <= 'd0;
		  out_2_s1 <= 'd0;
		  out_2_s2 <= 'd0;
		  out_2_op <= 'd0;
		  out_2_branch <= 'd0;
		  out_2_ime <= 'd0;
	       end
	     else
	       begin
		  out_2_vld <= 'd1;
		  out_2_des <= entry_2[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_2_s1 <= entry_2[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_2_s2 <= entry_2[immediate+branch_id+source2-1:immediate+branch_id];
		  out_2_op <= entry_2[total_out-2:total_out-5];
		  out_2_branch <= entry_2[immediate+branch_id-1:immediate];
		  out_2_ime <= entry_2[immediate-1:0];
	       end
	  end
	else if (entry_in_2 == 'd3)
	  begin
	     if (~entry_3[total_out-1])
	       begin
		  out_2_vld <= 'd0;
		  out_2_des <= 'd0;
		  out_2_s1 <= 'd0;
		  out_2_s2 <= 'd0;
		  out_2_op <= 'd0;
		  out_2_branch <= 'd0;
		  out_2_ime <= 'd0;
	       end
	     else
	       begin
		  out_2_vld <= 'd1;
		  out_2_des <= entry_3[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_2_s1 <= entry_3[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_2_s2 <= entry_3[immediate+branch_id+source2-1:immediate+branch_id];
		  out_2_op <= entry_3[total_out-2:total_out-5];
		  out_2_branch <= entry_3[immediate+branch_id-1:immediate];
		  out_2_ime <= entry_3[immediate-1:0];
	       end
	  end
	else if (entry_in_2 == 'd4)
	  begin
	     if (~entry_4[total_out-1])
	       begin
		  out_2_vld <= 'd0;
		  out_2_des <= 'd0;
		  out_2_s1 <= 'd0;
		  out_2_s2 <= 'd0;
		  out_2_op <= 'd0;
		  out_2_branch <= 'd0;
		  out_2_ime <= 'd0;
	       end
	     else
	       begin
		  out_2_vld <= 'd1;
		  out_2_des <= entry_4[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_2_s1 <= entry_4[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_2_s2 <= entry_4[immediate+branch_id+source2-1:immediate+branch_id];
		  out_2_op <= entry_4[total_out-2:total_out-5];
		  out_2_branch <= entry_4[immediate+branch_id-1:immediate];
		  out_2_ime <= entry_4[immediate-1:0];
	       end
	  end
	else if (entry_in_2 == 'd5)
	  begin
	     if (~entry_5[total_out-1])
	       begin
		  out_2_vld <= 'd0;
		  out_2_des <= 'd0;
		  out_2_s1 <= 'd0;
		  out_2_s2 <= 'd0;
		  out_2_op <= 'd0;
		  out_2_branch <= 'd0;
		  out_2_ime <= 'd0;
	       end
	     else
	       begin
		  out_2_vld <= 'd1;
		  out_2_des <= entry_5[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_2_s1 <= entry_5[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_2_s2 <= entry_5[immediate+branch_id+source2-1:immediate+branch_id];
		  out_2_op <= entry_5[total_out-2:total_out-5];
		  out_2_branch <= entry_5[immediate+branch_id-1:immediate];
		  out_2_ime <= entry_5[immediate-1:0];
	       end
	  end

     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  begin
	     out_3_vld <= 'd0;
	     out_3_des <= 'd0;
	     out_3_s1 <= 'd0;
	     out_3_s2 <= 'd0;
	     out_3_op <= 'd0;
	     out_3_branch <= 'd0;
	     out_3_ime <= 'd0;
	  end
	else if (entry_in_3 == 'd2)
	  begin
	     if (~entry_2[total_out-1])
	       begin
		  out_3_vld <= 'd0;
		  out_3_des <= 'd0;
		  out_3_s1 <= 'd0;
		  out_3_s2 <= 'd0;
		  out_3_op <= 'd0;
		  out_3_branch <= 'd0;
		  out_3_ime <= 'd0;
	       end
	     else
	       begin
		  out_3_vld <= 'd1;
		  out_3_des <= entry_2[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_3_s1 <= entry_2[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_3_s2 <= entry_2[immediate+branch_id+source2-1:immediate+branch_id];
		  out_3_op <= entry_2[total_out-2:total_out-5];
		  out_3_branch <= entry_2[immediate+branch_id-1:immediate];
		  out_3_ime <= entry_2[immediate-1:0];
	       end
	  end
	else if (entry_in_3 == 'd3)
	  begin
	     if (~entry_3[total_out-1])
	       begin
		  out_3_vld <= 'd0;
		  out_3_des <= 'd0;
		  out_3_s1 <= 'd0;
		  out_3_s2 <= 'd0;
		  out_3_op <= 'd0;
		  out_3_branch <= 'd0;
		  out_3_ime <= 'd0;
	       end
	     else
	       begin
		  out_3_vld <= 'd1;
		  out_3_des <= entry_3[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_3_s1 <= entry_3[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_3_s2 <= entry_3[immediate+branch_id+source2-1:immediate+branch_id];
		  out_3_op <= entry_3[total_out-2:total_out-5];
		  out_3_branch <= entry_3[immediate+branch_id-1:immediate];
		  out_3_ime <= entry_3[immediate-1:0];
	       end
	  end
	else if (entry_in_3 == 'd4)
	  begin
	     if (~entry_4[total_out-1])
	       begin
		  out_3_vld <= 'd0;
		  out_3_des <= 'd0;
		  out_3_s1 <= 'd0;
		  out_3_s2 <= 'd0;
		  out_3_op <= 'd0;
		  out_3_branch <= 'd0;
		  out_3_ime <= 'd0;
	       end
	     else
	       begin
		  out_3_vld <= 'd1;
		  out_3_des <= entry_4[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_3_s1 <= entry_4[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_3_s2 <= entry_4[immediate+branch_id+source2-1:immediate+branch_id];
		  out_3_op <= entry_4[total_out-2:total_out-5];
		  out_3_branch <= entry_4[immediate+branch_id-1:immediate];
		  out_3_ime <= entry_4[immediate-1:0];
	       end
	  end
	else if (entry_in_3 == 'd5)
	  begin
	     if (~entry_5[total_out-1])
	       begin
		  out_3_vld <= 'd0;
		  out_3_des <= 'd0;
		  out_3_s1 <= 'd0;
		  out_3_s2 <= 'd0;
		  out_3_op <= 'd0;
		  out_3_branch <= 'd0;
		  out_3_ime <= 'd0;
	       end
	     else
	       begin
		  out_3_vld <= 'd1;
		  out_3_des <= entry_5[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_3_s1 <= entry_5[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_3_s2 <= entry_5[immediate+branch_id+source2-1:immediate+branch_id];
		  out_3_op <= entry_5[total_out-2:total_out-5];
		  out_3_branch <= entry_5[immediate+branch_id-1:immediate];
		  out_3_ime <= entry_5[immediate-1:0];
	       end
	  end
	else if (entry_in_3 == 'd6)
	  begin
	     if (~entry_6[total_out-1])
	       begin
		  out_3_vld <= 'd0;
		  out_3_des <= 'd0;
		  out_3_s1 <= 'd0;
		  out_3_s2 <= 'd0;
		  out_3_op <= 'd0;
		  out_3_branch <= 'd0;
		  out_3_ime <= 'd0;
	       end
	     else
	       begin
		  out_3_vld <= 'd1;
		  out_3_des <= entry_6[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_3_s1 <= entry_6[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_3_s2 <= entry_6[immediate+branch_id+source2-1:immediate+branch_id];
		  out_3_op <= entry_6[total_out-2:total_out-5];
		  out_3_branch <= entry_6[immediate+branch_id-1:immediate];
		  out_3_ime <= entry_6[immediate-1:0];
	       end
	  end

     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  begin
	     out_4_vld <= 'd0;
	     out_4_des <= 'd0;
	     out_4_s1 <= 'd0;
	     out_4_s2 <= 'd0;
	     out_4_op <= 'd0;
	     out_4_branch <= 'd0;
	     out_4_ime <= 'd0;
	  end
	else if (entry_in_4 == 'd3)
	  begin
	     if (~entry_3[total_out-1])
	       begin
		  out_4_vld <= 'd0;
		  out_4_des <= 'd0;
		  out_4_s1 <= 'd0;
		  out_4_s2 <= 'd0;
		  out_4_op <= 'd0;
		  out_4_branch <= 'd0;
		  out_4_ime <= 'd0;
	       end
	     else
	       begin
		  out_4_vld <= 'd1;
		  out_4_des <= entry_3[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_4_s1 <= entry_3[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_4_s2 <= entry_3[immediate+branch_id+source2-1:immediate+branch_id];
		  out_4_op <= entry_3[total_out-2:total_out-5];
		  out_4_branch <= entry_3[immediate+branch_id-1:immediate];
		  out_4_ime <= entry_3[immediate-1:0];
	       end
	  end
	else if (entry_in_4 == 'd4)
	  begin
	     if (~entry_4[total_out-1])
	       begin
		  out_4_vld <= 'd0;
		  out_4_des <= 'd0;
		  out_4_s1 <= 'd0;
		  out_4_s2 <= 'd0;
		  out_4_op <= 'd0;
		  out_4_branch <= 'd0;
		  out_4_ime <= 'd0;
	       end
	     else
	       begin
		  out_4_vld <= 'd1;
		  out_4_des <= entry_4[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_4_s1 <= entry_4[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_4_s2 <= entry_4[immediate+branch_id+source2-1:immediate+branch_id];
		  out_4_op <= entry_4[total_out-2:total_out-5];
		  out_4_branch <= entry_4[immediate+branch_id-1:immediate];
		  out_4_ime <= entry_4[immediate-1:0];
	       end
	  end
	else if (entry_in_4 == 'd5)
	  begin
	     if (~entry_5[total_out-1])
	       begin
		  out_4_vld <= 'd0;
		  out_4_des <= 'd0;
		  out_4_s1 <= 'd0;
		  out_4_s2 <= 'd0;
		  out_4_op <= 'd0;
		  out_4_branch <= 'd0;
		  out_4_ime <= 'd0;
	       end
	     else
	       begin
		  out_4_vld <= 'd1;
		  out_4_des <= entry_5[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_4_s1 <= entry_5[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_4_s2 <= entry_5[immediate+branch_id+source2-1:immediate+branch_id];
		  out_4_op <= entry_5[total_out-2:total_out-5];
		  out_4_branch <= entry_5[immediate+branch_id-1:immediate];
		  out_4_ime <= entry_5[immediate-1:0];
	       end
	  end
	else if (entry_in_4 == 'd6)
	  begin
	     if (~entry_6[total_out-1])
	       begin
		  out_4_vld <= 'd0;
		  out_4_des <= 'd0;
		  out_4_s1 <= 'd0;
		  out_4_s2 <= 'd0;
		  out_4_op <= 'd0;
		  out_4_branch <= 'd0;
		  out_4_ime <= 'd0;
	       end
	     else
	       begin
		  out_4_vld <= 'd1;
		  out_4_des <= entry_6[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_4_s1 <= entry_6[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_4_s2 <= entry_6[immediate+branch_id+source2-1:immediate+branch_id];
		  out_4_op <= entry_6[total_out-2:total_out-5];
		  out_4_branch <= entry_6[immediate+branch_id-1:immediate];
		  out_4_ime <= entry_6[immediate-1:0];
	       end
	  end
	else if (entry_in_4 == 'd7)
	  begin
	     if (~entry_7[total_out-1])
	       begin
		  out_4_vld <= 'd0;
		  out_4_des <= 'd0;
		  out_4_s1 <= 'd0;
		  out_4_s2 <= 'd0;
		  out_4_op <= 'd0;
		  out_4_branch <= 'd0;
		  out_4_ime <= 'd0;
	       end
	     else
	       begin
		  out_4_vld <= 'd1;
		  out_4_des <= entry_7[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1];
		  out_4_s1 <= entry_7[immediate+branch_id+source2+source1-1:immediate+branch_id+source2];
		  out_4_s2 <= entry_7[immediate+branch_id+source2-1:immediate+branch_id];
		  out_4_op <= entry_7[total_out-2:total_out-5];
		  out_4_branch <= entry_7[immediate+branch_id-1:immediate];
		  out_4_ime <= entry_7[immediate-1:0];
	       end
	  end

     end


   ///////////////////////////////////////////////////////////////////////////////////////
   //Calculate the current branch ID

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  branch_id_cnt <= 'd0;
	else if (ins_1_op == 'b0001 && ins_2_op == 'b0001 && ins_new_1_vld && ins_new_2_vld)
	  branch_id_cnt <= branch_id_cnt + 'd2;
	else if ((ins_1_op == 'b0001 && ins_new_1_vld && (ins_2_op != 'b0001 || ~ins_new_1_vld) ) || 
		 ((ins_1_op != 'b0001 || ~ins_new_1_vld) && ins_new_2_vld && ins_2_op == 'b0001))
	  branch_id_cnt <= branch_id_cnt + 'd1;
	else if (~entry_0[total_out-1] && ~entry_1[total_out-1]
		 && ~entry_2[total_out-1] && ~entry_3[total_out-1]
		 && ~entry_4[total_out-1] && ~entry_5[total_out-1]
		 && ~entry_6[total_out-1] && ~entry_7[total_out-1]
		 && ~entry_8[total_out-1] && ~entry_9[total_out-1]
		 && ~entry_10[total_out-1] && ~entry_11[total_out-1]
		 && ~entry_12[total_out-1] && ~entry_13[total_out-1]
		 && ~entry_14[total_out-1] && ~entry_15[total_out-1])
	  branch_id_cnt <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  branch_full <= 'd0;
	else if (branch_id_cnt == 'd6 || branch_id_cnt == 'd7)
	  branch_full <= 'd1;
	else if (entry_empty)
	  branch_full <= 'd0;
     end

   always_comb
     begin
	if (ins_new_1_vld && ins_new_2_vld)
	  begin
	     if (ins_1_op == 'b0001)
	       begin
		  if (ins_2_op == 'b0001)
		    begin
		       branch_id_ins1 = branch_id_cnt + 'd1;
		       branch_id_ins2 = branch_id_cnt + 'd2;
		    end
		  else
		    begin
		       branch_id_ins1 = branch_id_cnt + 'd1;
		       branch_id_ins2 = branch_id_ins1;
		    end
	       end
	     else
	       begin
		  if (ins_2_op == 'b0001)
		    begin
		       branch_id_ins1 = branch_id_cnt;
		       branch_id_ins2 = branch_id_cnt + 'd1;
		    end
		  else
		    begin
		       branch_id_ins1 = branch_id_cnt;
		       branch_id_ins2 = branch_id_cnt;
		    end
	       end
	  end
	else if (ins_new_1_vld && ~ins_new_2_vld)
	  begin
	     if (ins_1_op == 'b0001)
	       begin
		  branch_id_ins1 = branch_id_cnt + 'd1;
		  branch_id_ins2 = 'd0;
	       end
	     else
	       begin
		  branch_id_ins1 = branch_id_cnt;
		  branch_id_ins2 = 'd0;
	       end
	  end
	else
	  begin
	     branch_id_ins1 = 'd0;
	     branch_id_ins2 = 'd0;
	  end
     end

   ////////////////////////////////////////////////////////////////////////////
   //Shift entries and write in new instructions //Function 2 3 & 4: shift, new instruction allocation and flush respectively

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_0 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd0)
	  begin
	     entry_0[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_0[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_0[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_0[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_0[total_out-2:total_out-5] <= ins_1_op;
	     entry_0[immediate-1:0] <= ins_1_ime;
	     entry_0[total_out-1] <= 'd1;
	  end
	else if (entry_0[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry1 == 'd1)
	       entry_0 <= entry_1;
	     else if (shift_entry2 == 'd2)
	       entry_0 <= entry_2;
	     else if (shift_entry3 == 'd3)
	       entry_0 <= entry_3;
	     else if (shift_entry_rest == 'd4)
	       entry_0 <= entry_4;
	  end
	else if (flush_en && flush_id <= entry_0[immediate+branch_id-1:immediate])
	  entry_0 <= 'd0;
     end


   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_1 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd1)
	  begin
	     entry_1[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_1[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_1[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_1[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_1[total_out-2:total_out-5] <= ins_1_op;
	     entry_1[immediate-1:0] <= ins_1_ime;
	     entry_1[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd1)
	  begin
	     entry_1[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_1[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_1[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_1[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_1[total_out-2:total_out-5] <= ins_2_op;
	     entry_1[immediate-1:0] <= ins_2_ime;
	     entry_1[total_out-1] <= 'd1;
	  end
	else if (entry_1[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry2 == 'd1)
	       entry_1 <= entry_2;
	     else if (shift_entry3 == 'd2)
	       entry_1 <= entry_3;
	     else if (shift_entry_rest == 'd3)
	       entry_1 <= entry_4;
	     else if (shift_entry_rest == 'd4)
	       entry_1 <= entry_5;
	  end
	else if (flush_en && flush_id <= entry_1[immediate+branch_id-1:immediate])
	  entry_1 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_2 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd2)
	  begin
	     entry_2[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_2[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_2[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_2[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_2[total_out-2:total_out-5] <= ins_1_op;
	     entry_2[immediate-1:0] <= ins_1_ime;
	     entry_2[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd2)
	  begin
	     entry_2[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_2[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_2[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_2[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_2[total_out-2:total_out-5] <= ins_2_op;
	     entry_2[immediate-1:0] <= ins_2_ime;
	     entry_2[total_out-1] <= 'd1;
	  end
	else if (entry_2[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry3 == 'd1)
	       entry_2 <= entry_3;
	     else if (shift_entry_rest == 'd2)
	       entry_2 <= entry_4;
	     else if (shift_entry_rest == 'd3)
	       entry_2 <= entry_5;
	     else if (shift_entry_rest == 'd4)
	       entry_2 <= entry_6;
	  end
	else if (flush_en && flush_id <= entry_2[immediate+branch_id-1:immediate])
	  entry_2 <= 'd0;
     end


   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_3 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd3)
	  begin
	     entry_3[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_3[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_3[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_3[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_3[total_out-2:total_out-5] <= ins_1_op;
	     entry_3[immediate-1:0] <= ins_1_ime;
	     entry_3[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd3)
	  begin
	     entry_3[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_3[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_3[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_3[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_3[total_out-2:total_out-5] <= ins_2_op;
	     entry_3[immediate-1:0] <= ins_2_ime;
	     entry_3[total_out-1] <= 'd1;
	  end
	else if (entry_3[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_3 <= entry_4;
	     else if (shift_entry_rest == 'd2)
	       entry_3 <= entry_5;
	     else if (shift_entry_rest == 'd3)
	       entry_3 <= entry_6;
	     else if (shift_entry_rest == 'd4)
	       entry_3 <= entry_7;
	  end
	else if (flush_en && flush_id <= entry_3[immediate+branch_id-1:immediate])
	  entry_3 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_4 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd4)
	  begin
	     entry_4[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_4[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_4[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_4[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_4[total_out-2:total_out-5] <= ins_1_op;
	     entry_4[immediate-1:0] <= ins_1_ime;
	     entry_4[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd4)
	  begin
	     entry_4[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_4[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_4[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_4[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_4[total_out-2:total_out-5] <= ins_2_op;
	     entry_4[immediate-1:0] <= ins_2_ime;
	     entry_4[total_out-1] <= 'd1;
	  end
	else if (entry_4[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_4 <= entry_5;
	     else if (shift_entry_rest == 'd2)
	       entry_4 <= entry_6;
	     else if (shift_entry_rest == 'd3)
	       entry_4 <= entry_7;
	     else if (shift_entry_rest == 'd4)
	       entry_4 <= entry_8;
	  end
	else if (flush_en && flush_id <= entry_4[immediate+branch_id-1:immediate])
	  entry_4 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_5 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd5)
	  begin
	     entry_5[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_5[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_5[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_5[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_5[total_out-2:total_out-5] <= ins_1_op;
	     entry_5[immediate-1:0] <= ins_1_ime;
	     entry_5[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd5)
	  begin
	     entry_5[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_5[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_5[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_5[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_5[total_out-2:total_out-5] <= ins_2_op;
	     entry_5[immediate-1:0] <= ins_2_ime;
	     entry_5[total_out-1] <= 'd1;
	  end
	else if (entry_5[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_5 <= entry_6;
	     else if (shift_entry_rest == 'd2)
	       entry_5 <= entry_7;
	     else if (shift_entry_rest == 'd3)
	       entry_5 <= entry_8;
	     else if (shift_entry_rest == 'd4)
	       entry_5 <= entry_9;
	  end
	else if (flush_en && flush_id <= entry_5[immediate+branch_id-1:immediate])
	  entry_5 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_6 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd6)
	  begin
	     entry_6[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_6[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_6[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_6[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_6[total_out-2:total_out-5] <= ins_1_op;
	     entry_6[immediate-1:0] <= ins_1_ime;
	     entry_6[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd6)
	  begin
	     entry_6[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_6[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_6[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_6[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_6[total_out-2:total_out-5] <= ins_2_op;
	     entry_6[immediate-1:0] <= ins_2_ime;
	     entry_6[total_out-1] <= 'd1;
	  end
	else if (entry_6[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_6 <= entry_7;
	     else if (shift_entry_rest == 'd2)
	       entry_6 <= entry_8;
	     else if (shift_entry_rest == 'd3)
	       entry_6 <= entry_9;
	     else if (shift_entry_rest == 'd4)
	       entry_6 <= entry_10;
	  end
	else if (flush_en && flush_id <= entry_6[immediate+branch_id-1:immediate])
	  entry_6 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_7 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd7)
	  begin
	     entry_7[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_7[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_7[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_7[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_7[total_out-2:total_out-5] <= ins_1_op;
	     entry_7[immediate-1:0] <= ins_1_ime;
	     entry_7[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd7)
	  begin
	     entry_7[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_7[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_7[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_7[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_7[total_out-2:total_out-5] <= ins_2_op;
	     entry_7[immediate-1:0] <= ins_2_ime;
	     entry_7[total_out-1] <= 'd1;
	  end
	else if (entry_7[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_7 <= entry_8;
	     else if (shift_entry_rest == 'd2)
	       entry_7 <= entry_9;
	     else if (shift_entry_rest == 'd3)
	       entry_7 <= entry_10;
	     else if (shift_entry_rest == 'd4)
	       entry_7 <= entry_11;
	  end
	else if (flush_en && flush_id <= entry_7[immediate+branch_id-1:immediate])
	  entry_7 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_8 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd8)
	  begin
	     entry_8[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_8[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_8[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_8[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_8[total_out-2:total_out-5] <= ins_1_op;
	     entry_8[immediate-1:0] <= ins_1_ime;
	     entry_8[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd8)
	  begin
	     entry_8[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_8[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_8[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_8[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_8[total_out-2:total_out-5] <= ins_2_op;
	     entry_8[immediate-1:0] <= ins_2_ime;
	     entry_8[total_out-1] <= 'd1;
	  end
	else if (entry_8[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_8 <= entry_9;
	     else if (shift_entry_rest == 'd2)
	       entry_8 <= entry_10;
	     else if (shift_entry_rest == 'd3)
	       entry_8 <= entry_11;
	     else if (shift_entry_rest == 'd4)
	       entry_8 <= entry_12;
	  end
	else if (flush_en && flush_id <= entry_8[immediate+branch_id-1:immediate])
	  entry_8 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_9 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd9)
	  begin
	     entry_9[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_9[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_9[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_9[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_9[total_out-2:total_out-5] <= ins_1_op;
	     entry_9[immediate-1:0] <= ins_1_ime;
	     entry_9[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd9)
	  begin
	     entry_9[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_9[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_9[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_9[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_9[total_out-2:total_out-5] <= ins_2_op;
	     entry_9[immediate-1:0] <= ins_2_ime;
	     entry_9[total_out-1] <= 'd1;
	  end
	else if (entry_9[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_9 <= entry_10;
	     else if (shift_entry_rest == 'd2)
	       entry_9 <= entry_11;
	     else if (shift_entry_rest == 'd3)
	       entry_9 <= entry_12;
	     else if (shift_entry_rest == 'd4)
	       entry_9 <= entry_13;
	  end
	else if (flush_en && flush_id <= entry_9[immediate+branch_id-1:immediate])
	  entry_9 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_10 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd10)
	  begin
	     entry_10[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_10[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_10[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_10[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_10[total_out-2:total_out-5] <= ins_1_op;
	     entry_10[immediate-1:0] <= ins_1_ime;
	     entry_10[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd10)
	  begin
	     entry_10[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_10[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_10[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_10[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_10[total_out-2:total_out-5] <= ins_2_op;
	     entry_10[immediate-1:0] <= ins_2_ime;
	     entry_10[total_out-1] <= 'd1;
	  end
	else if (entry_10[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_10 <= entry_11;
	     else if (shift_entry_rest == 'd2)
	       entry_10 <= entry_12;
	     else if (shift_entry_rest == 'd3)
	       entry_10 <= entry_13;
	     else if (shift_entry_rest == 'd4)
	       entry_10 <= entry_14;
	  end
	else if (flush_en && flush_id <= entry_10[immediate+branch_id-1:immediate])
	  entry_10 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_11 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd11)
	  begin
	     entry_11[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_11[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_11[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_11[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_11[total_out-2:total_out-5] <= ins_1_op;
	     entry_11[immediate-1:0] <= ins_1_ime;
	     entry_11[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd11)
	  begin
	     entry_11[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_11[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_11[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_11[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_11[total_out-2:total_out-5] <= ins_2_op;
	     entry_11[immediate-1:0] <= ins_2_ime;
	     entry_11[total_out-1] <= 'd1;
	  end
	else if (entry_11[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_11 <= entry_12;
	     else if (shift_entry_rest == 'd2)
	       entry_11 <= entry_13;
	     else if (shift_entry_rest == 'd3)
	       entry_11 <= entry_14;
	     else if (shift_entry_rest == 'd4)
	       entry_11 <= entry_15;
	  end
	else if (flush_en && flush_id <= entry_11[immediate+branch_id-1:immediate])
	  entry_11 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_12 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd12)
	  begin
	     entry_12[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_12[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_12[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_12[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_12[total_out-2:total_out-5] <= ins_1_op;
	     entry_12[immediate-1:0] <= ins_1_ime;
	     entry_12[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd12)
	  begin
	     entry_12[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_12[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_12[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_12[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_12[total_out-2:total_out-5] <= ins_2_op;
	     entry_12[immediate-1:0] <= ins_2_ime;
	     entry_12[total_out-1] <= 'd1;
	  end
	else if (entry_12[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_12 <= entry_13;
	     else if (shift_entry_rest == 'd2)
	       entry_12 <= entry_14;
	     else if (shift_entry_rest == 'd3)
	       entry_12 <= entry_15;
	     else if (shift_entry_rest == 'd4)
	       entry_12 <= 'd0;
	  end
	else if (flush_en && flush_id <= entry_12[immediate+branch_id-1:immediate])
	  entry_12 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_13 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd13)
	  begin
	     entry_13[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_13[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_13[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_13[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_13[total_out-2:total_out-5] <= ins_1_op;
	     entry_13[immediate-1:0] <= ins_1_ime;
	     entry_13[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd13)
	  begin
	     entry_13[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_13[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_13[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_13[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_13[total_out-2:total_out-5] <= ins_2_op;
	     entry_13[immediate-1:0] <= ins_2_ime;
	     entry_13[total_out-1] <= 'd1;
	  end
	else if (entry_13[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_13 <= entry_14;
	     else if (shift_entry_rest == 'd2)
	       entry_13 <= entry_15;
	     else if (shift_entry_rest == 'd3)
	       entry_13 <= 'd0;
	     else if (shift_entry_rest == 'd4)
	       entry_13 <= 'd0;
	  end
	else if (flush_en && flush_id <= entry_13[immediate+branch_id-1:immediate])
	  entry_13 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_14 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd14)
	  begin
	     entry_14[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_14[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_14[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_14[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_14[total_out-2:total_out-5] <= ins_1_op;
	     entry_14[immediate-1:0] <= ins_1_ime;
	     entry_14[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd14)
	  begin
	     entry_14[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_14[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_14[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_14[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_14[total_out-2:total_out-5] <= ins_2_op;
	     entry_14[immediate-1:0] <= ins_2_ime;
	     entry_14[total_out-1] <= 'd1;
	  end
	else if (entry_14[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_14 <= entry_15;
	     else if (shift_entry_rest == 'd2)
	       entry_14 <= 'd0;
	     else if (shift_entry_rest == 'd3)
	       entry_14 <= 'd0;
	     else if (shift_entry_rest == 'd4)
	       entry_14 <= 'd0;
	  end
	else if (flush_en && flush_id <= entry_14[immediate+branch_id-1:immediate])
	  entry_14 <= 'd0;
     end

   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  entry_15 <= 'd0;
	else if (~flush_en && ins_new_1_vld && ins_new_1_addr == 'd15)
	  begin
	     entry_15[immediate+branch_id-1:immediate] <= branch_id_ins1;
	     entry_15[immediate+branch_id+source2-1:immediate+branch_id] <= ins_1_s2;
	     entry_15[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_1_s1;
	     entry_15[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_1_des;
	     entry_15[total_out-2:total_out-5] <= ins_1_op;
	     entry_15[immediate-1:0] <= ins_1_ime;
	     entry_15[total_out-1] <= 'd1;
	  end
	else if (~flush_en && ins_new_2_vld && ins_new_2_addr == 'd15)
	  begin
	     entry_15[immediate+branch_id-1:immediate] <= branch_id_ins2;
	     entry_15[immediate+branch_id+source2-1:immediate+branch_id] <= ins_2_s2;
	     entry_15[immediate+branch_id+source2+source1-1:immediate+branch_id+source2] <= ins_2_s1;
	     entry_15[immediate+branch_id+source2+source1+des-1:immediate+branch_id+source2+source1] <= ins_2_des;
	     entry_15[total_out-2:total_out-5] <= ins_2_op;
	     entry_15[immediate-1:0] <= ins_2_ime;
	     entry_15[total_out-1] <= 'd1;
	  end
	else if (entry_15[total_out-1] && ~flush_en)
	  begin
	     if (shift_entry_rest == 'd1)
	       entry_15 <= 'd0;
	     else if (shift_entry_rest == 'd2)
	       entry_15 <= 'd0;
	     else if (shift_entry_rest == 'd3)
	       entry_15 <= 'd0;
	     else if (shift_entry_rest == 'd4)
	       entry_15 <= 'd0;
	  end
	else if (flush_en && flush_id <= entry_15[immediate+branch_id-1:immediate])
	  entry_15 <= 'd0;
     end


   always_ff @ (posedge clk or posedge rst)
     begin
	if (rst)
	  begin
	     entry_full <= 'd0;
	     entry_empty <= 'd1;
	  end
	else if (entry_0[total_out-1] && entry_1[total_out-1]
		 && entry_2[total_out-1] && entry_3[total_out-1]
		 && entry_4[total_out-1] && entry_5[total_out-1]
		 && entry_6[total_out-1] && entry_7[total_out-1]
		 && entry_8[total_out-1] && entry_9[total_out-1]
		 && entry_10[total_out-1] && entry_11[total_out-1]
		 && entry_12[total_out-1] && entry_13[total_out-1])
	  begin
	     entry_full <= 'd1;
	  end
	else if (~entry_0[total_out-1] && ~entry_1[total_out-1]
		 && ~entry_2[total_out-1] && ~entry_3[total_out-1]
		 && ~entry_4[total_out-1] && ~entry_5[total_out-1]
		 && ~entry_6[total_out-1] && ~entry_7[total_out-1]
		 && ~entry_8[total_out-1] && ~entry_9[total_out-1]
		 && ~entry_10[total_out-1] && ~entry_11[total_out-1]
		 && ~entry_12[total_out-1] && ~entry_13[total_out-1]
		 && ~entry_14[total_out-1] && ~entry_15[total_out-1])
	  entry_empty <= 'd1;
	else if (entry_0[total_out-1] || entry_1[total_out-1]
		 || entry_2[total_out-1] || entry_3[total_out-1]
		 || entry_4[total_out-1] || entry_5[total_out-1]
		 || entry_6[total_out-1] || entry_7[total_out-1]
		 || entry_8[total_out-1] || entry_9[total_out-1]
		 || entry_10[total_out-1] || entry_11[total_out-1]
		 || entry_12[total_out-1] || entry_13[total_out-1]
		 || entry_14[total_out-1] || entry_15[total_out-1])
	  entry_empty <= 'd0;
	else if (~entry_0[total_out-1] && ~entry_1[total_out-1]
		 && ~entry_2[total_out-1] && ~entry_3[total_out-1]
		 && ~entry_4[total_out-1] && ~entry_5[total_out-1]
		 && ~entry_6[total_out-1] && ~entry_7[total_out-1]
		 && ~entry_8[total_out-1] && ~entry_9[total_out-1]
		 && ~entry_10[total_out-1] && ~entry_11[total_out-1]
		 && ~entry_12[total_out-1] && ~entry_13[total_out-1]
		 && ~entry_14[total_out-1] && ~entry_15[total_out-1])
	  entry_full <= 'd0;
     end




endmodule
