//Programmer:	Tong Zhang
//Date:		12/12/2012
//Purpose:	Register file, read data for up to eight source registers, and write back up to four register back

module register_file(register_file_interface.register_file_dut d);

   //reg0 is always 0. It can appear in the source part of an instruction. therefore reading from reg0 should be allowed
   reg	[31:0] reg1;
   reg [31:0]  reg2;
   reg [31:0]  reg3;
   reg [31:0]  reg4;
   reg [31:0]  reg5;
   reg [31:0]  reg6;
   reg [31:0]  reg7;
   reg [31:0]  reg8;
   reg [31:0]  reg9;
   reg [31:0]  reg10;
   reg [31:0]  reg11;
   reg [31:0]  reg12;
   reg [31:0]  reg13;
   reg [31:0]  reg14;
   reg [31:0]  reg15;

   logic [31:0] temp11;
   logic [31:0] temp12;
   logic [31:0] temp21;
   logic [31:0] temp22;
   logic [31:0] temp31;
   logic [31:0] temp32;
   logic [31:0] temp41;
   logic [31:0] temp42;


   assign d.ins1_op = d.in_1_op;
   assign d.ins2_op = d.in_2_op;
   assign d.ins3_op = d.in_3_op;
   assign d.ins4_op = d.in_4_op;
   assign d.ins1_bid = d.in_1_branch;
   assign d.ins2_bid = d.in_2_branch;
   assign d.ins3_bid = d.in_3_branch;
   assign d.ins4_bid = d.in_4_branch;
   assign d.ins1_addr = d.in_1_ime;
   assign d.ins2_addr = d.in_2_ime;
   assign d.ins3_addr = d.in_3_ime;
   assign d.ins4_addr = d.in_4_ime;
   assign d.ins1_data1 = temp11;
   assign d.ins1_data2 = temp12;
   assign d.ins2_data1 = temp21;
   assign d.ins2_data2 = temp22;
   assign d.ins3_data1 = temp31;
   assign d.ins3_data2 = temp32;
   assign d.ins4_data1 = temp41;
   assign d.ins4_data2 = temp42;

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)		//what does this rst mean? why don't we reset the output data?
	  begin
	     d.out_1_vld <= 'd0;
	     d.out_2_vld <= 'd0;
	     d.out_3_vld <= 'd0;
	     d.out_4_vld <= 'd0;
	     d.out_1_des <= 'd0;
	     d.out_2_des <= 'd0;
	     d.out_3_des <= 'd0;
	     d.out_4_des <= 'd0;
	     d.out_1_op  <= 'd0;
	     d.out_2_op  <= 'd0;
	     d.out_3_op  <= 'd0;
	     d.out_4_op  <= 'd0;
	     d.out_1_branch <= 'd0;
	     d.out_2_branch <= 'd0;
	     d.out_3_branch <= 'd0;
	     d.out_4_branch <= 'd0;
	     d.out_1_ime <= 'd0;
	     d.out_2_ime <= 'd0;
	     d.out_3_ime <= 'd0;
	     d.out_4_ime <= 'd0;
	  end
	else 
	  begin
	     d.out_1_vld <= d.in_1_vld;
	     d.out_2_vld <= d.in_2_vld;
	     d.out_3_vld <= d.in_3_vld;
	     d.out_4_vld <= d.in_4_vld;
	     d.out_1_des <= d.in_1_des;	//for a branch ins which has no des, what should the out_des be?
	     d.out_2_des <= d.in_2_des;
	     d.out_3_des <= d.in_3_des;
	     d.out_4_des <= d.in_4_des;
	     d.out_1_op  <= d.in_1_op;
	     d.out_2_op  <= d.in_2_op;
	     d.out_3_op  <= d.in_3_op;
	     d.out_4_op  <= d.in_4_op;
	     d.out_1_branch <= d.in_1_branch;
	     d.out_2_branch <= d.in_2_branch;
	     d.out_3_branch <= d.in_3_branch;
	     d.out_4_branch <= d.in_4_branch;
	     d.out_1_ime <= d.in_1_ime;
	     d.out_2_ime <= d.in_2_ime;
	     d.out_3_ime <= d.in_3_ime;
	     d.out_4_ime <= d.in_4_ime;
	  end
     end


   always_comb
     begin
	case(d.in_1_s1)
	  'd1:	temp11 = reg1;
	  'd2:	temp11 = reg2;
	  'd3:	temp11 = reg3;
	  'd4:	temp11 = reg4;
	  'd5:	temp11 = reg5;
	  'd6:	temp11 = reg6;
	  'd7:	temp11 = reg7;
	  'd8:	temp11 = reg8;
	  'd9:	temp11 = reg9;
	  'd10:	temp11 = reg10;
	  'd11:	temp11 = reg11;
	  'd12:	temp11 = reg12;
	  'd13:	temp11 = reg13;
	  'd14:	temp11 = reg14;
	  'd15:	temp11 = reg15;
	  default temp11 = 'd0;
	endcase
     end

   always_comb
     begin
	case(d.in_1_s2)
	  'd1:	temp12 = reg1;
	  'd2:	temp12 = reg2;
	  'd3:	temp12 = reg3;
	  'd4:	temp12 = reg4;
	  'd5:	temp12 = reg5;
	  'd6:	temp12 = reg6;
	  'd7:	temp12 = reg7;
	  'd8:	temp12 = reg8;
	  'd9:	temp12 = reg9;
	  'd10:	temp12 = reg10;
	  'd11:	temp12 = reg11;
	  'd12:	temp12 = reg12;
	  'd13:	temp12 = reg13;
	  'd14:	temp12 = reg14;
	  'd15:	temp12 = reg15;
	  default temp12 = 'd0;
	endcase
     end

   always_comb
     begin
	case(d.in_2_s1)
	  'd1:	temp21 = reg1;
	  'd2:	temp21 = reg2;
	  'd3:	temp21 = reg3;
	  'd4:	temp21 = reg4;
	  'd5:	temp21 = reg5;
	  'd6:	temp21 = reg6;
	  'd7:	temp21 = reg7;
	  'd8:	temp21 = reg8;
	  'd9:	temp21 = reg9;
	  'd10:	temp21 = reg10;
	  'd11:	temp21 = reg11;
	  'd12:	temp21 = reg12;
	  'd13:	temp21 = reg13;
	  'd14:	temp21 = reg14;
	  'd15:	temp21 = reg15;
	  default temp21 = 'd0;
	endcase
     end

   always_comb
     begin
	case(d.in_2_s2)
	  'd1:	temp22 = reg1;
	  'd2:	temp22 = reg2;
	  'd3:	temp22 = reg3;
	  'd4:	temp22 = reg4;
	  'd5:	temp22 = reg5;
	  'd6:	temp22 = reg6;
	  'd7:	temp22 = reg7;
	  'd8:	temp22 = reg8;
	  'd9:	temp22 = reg9;
	  'd10:	temp22 = reg10;
	  'd11:	temp22 = reg11;
	  'd12:	temp22 = reg12;
	  'd13:	temp22 = reg13;
	  'd14:	temp22 = reg14;
	  'd15:	temp22 = reg15;
	  default temp22 = 'd0;
	endcase
     end

   always_comb
     begin
	case(d.in_3_s1)
	  'd1:	temp31 = reg1;
	  'd2:	temp31 = reg2;
	  'd3:	temp31 = reg3;
	  'd4:	temp31 = reg4;
	  'd5:	temp31 = reg5;
	  'd6:	temp31 = reg6;
	  'd7:	temp31 = reg7;
	  'd8:	temp31 = reg8;
	  'd9:	temp31 = reg9;
	  'd10:	temp31 = reg10;
	  'd11:	temp31 = reg11;
	  'd12:	temp31 = reg12;
	  'd13:	temp31 = reg13;
	  'd14:	temp31 = reg14;
	  'd15:	temp31 = reg15;
	  default temp31 = 'd0;
	endcase
     end

   always_comb
     begin
	case(d.in_3_s2)
	  'd1:	temp32 = reg1;
	  'd2:	temp32 = reg2;
	  'd3:	temp32 = reg3;
	  'd4:	temp32 = reg4;
	  'd5:	temp32 = reg5;
	  'd6:	temp32 = reg6;
	  'd7:	temp32 = reg7;
	  'd8:	temp32 = reg8;
	  'd9:	temp32 = reg9;
	  'd10:	temp32 = reg10;
	  'd11:	temp32 = reg11;
	  'd12:	temp32 = reg12;
	  'd13:	temp32 = reg13;
	  'd14:	temp32 = reg14;
	  'd15:	temp32 = reg15;
	  default temp32 = 'd0;
	endcase
     end

   always_comb
     begin
	case(d.in_4_s1)
	  'd1:	temp41 = reg1;
	  'd2:	temp41 = reg2;
	  'd3:	temp41 = reg3;
	  'd4:	temp41 = reg4;
	  'd5:	temp41 = reg5;
	  'd6:	temp41 = reg6;
	  'd7:	temp41 = reg7;
	  'd8:	temp41 = reg8;
	  'd9:	temp41 = reg9;
	  'd10:	temp41 = reg10;
	  'd11:	temp41 = reg11;
	  'd12:	temp41 = reg12;
	  'd13:	temp41 = reg13;
	  'd14:	temp41 = reg14;
	  'd15:	temp41 = reg15;
	  default temp41 = 'd0;
	endcase
     end

   always_comb
     begin
	case(d.in_4_s2)
	  'd1:	temp42 = reg1;
	  'd2:	temp42 = reg2;
	  'd3:	temp42 = reg3;
	  'd4:	temp42 = reg4;
	  'd5:	temp42 = reg5;
	  'd6:	temp42 = reg6;
	  'd7:	temp42 = reg7;
	  'd8:	temp42 = reg8;
	  'd9:	temp42 = reg9;
	  'd10:	temp42 = reg10;
	  'd11:	temp42 = reg11;
	  'd12:	temp42 = reg12;
	  'd13:	temp42 = reg13;
	  'd14:	temp42 = reg14;
	  'd15:	temp42 = reg15;
	  default temp42 = 'd0;
	endcase
     end


   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  begin
	     d.out_1_s1_data <= 'd0;
	     d.out_1_s2_data <= 'd0;
	  end
	else if (d.in_1_op == 'b0100 || d.in_1_op == 'b0010)
	  begin
	     d.out_1_s1_data <= temp11;
	     d.out_1_s2_data <= 'd0;
	  end
	else
	  begin
	     d.out_1_s1_data <= temp11;
	     d.out_1_s2_data <= temp12;
	  end
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  begin
	     d.out_2_s1_data <= 'd0;
	     d.out_2_s2_data <= 'd0;
	  end
	else
	  begin
	     d.out_2_s1_data <= temp21;
	     d.out_2_s2_data <= temp22;
	  end
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  begin
	     d.out_3_s1_data <= 'd0;
	     d.out_3_s2_data <= 'd0;
	  end
	else
	  begin
	     d.out_3_s1_data <= temp31;
	     d.out_3_s2_data <= temp32;
	  end
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  begin
	     d.out_4_s1_data <= 'd0;
	     d.out_4_s2_data <= 'd0;
	  end
	else
	  begin
	     d.out_4_s1_data <= temp41;
	     d.out_4_s2_data <= temp42;
	  end
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg1 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd1)
	  reg1 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd1)
	  reg1 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd1)
	  reg1 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd1)
	  reg1 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg2 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd2)
	  reg2 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd2)
	  reg2 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd2)
	  reg2 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd2)
	  reg2 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg3 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd3)
	  reg3 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd3)
	  reg3 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd3)
	  reg3 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd3)
	  reg3 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg4 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd4)
	  reg4 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd4)
	  reg4 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd4)
	  reg4 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd4)
	  reg4 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg5 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd5)
	  reg5 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd5)
	  reg5 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd5)
	  reg5 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd5)
	  reg5 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg6 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd6)
	  reg6 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd6)
	  reg6 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd6)
	  reg6 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd6)
	  reg6 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg7 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd7)
	  reg7 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd7)
	  reg7 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd7)
	  reg7 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd7)
	  reg7 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg8 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd8)
	  reg8 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd8)
	  reg8 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd8)
	  reg8 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd8)
	  reg8 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg9 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd9)
	  reg9 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd9)
	  reg9 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd9)
	  reg9 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd9)
	  reg9 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg10 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd10)
	  reg10 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd10)
	  reg10 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd10)
	  reg10 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd10)
	  reg10 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg11 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd11)
	  reg11 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd11)
	  reg11 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd11)
	  reg11 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd11)
	  reg11 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg12 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd12)
	  reg12 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd12)
	  reg12 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd12)
	  reg12 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd12)
	  reg12 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg13 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd13)
	  reg13 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd13)
	  reg13 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd13)
	  reg13 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd13)
	  reg13 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg14 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd14)
	  reg14 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd14)
	  reg14 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd14)
	  reg14 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd14)
	  reg14 <= d.back_4_data;
     end

   always_ff @ (posedge d.clk or posedge d.rst)
     begin
	if (d.rst)
	  reg15 <= 'd0;
	else if (d.back_1_vld && d.back_1_des == 'd15)
	  reg15 <= d.back_1_data;
	else if (d.back_2_vld && d.back_2_des == 'd15)
	  reg15 <= d.back_2_data;
	else if (d.back_3_vld && d.back_3_des == 'd15)
	  reg15 <= d.back_3_data;
	else if (d.back_4_vld && d.back_4_des == 'd15)
	  reg15 <= d.back_4_data;
     end



endmodule

