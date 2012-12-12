///////////////////////////////////////////////////////////////////////////////////////////////////
//	Team member:	Tong Zhang, Chaoying Kang, Shuying Fan					//
//	Module function:	Decoder								//
//	Modification Date:	October 1, 2012							//
//												//
//////////////////////////////////////////////////////////////////////////////////////////////////

module dec
(
	input [4:0]	d_i,
	input en,
	output logic [31:0]	d_o
);

//assign d_o = (en) ? (1 << d_i) : 'd0;

always_comb
begin
	if (en)
	begin
		case (d_i)
			'd0:	d_o = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
			'd1:	d_o = 32'b0000_0000_0000_0000_0000_0000_0000_0010;
			'd2:	d_o = 32'b0000_0000_0000_0000_0000_0000_0000_0100;
			'd3:	d_o = 32'b0000_0000_0000_0000_0000_0000_0000_1000;
			'd4:	d_o = 32'b0000_0000_0000_0000_0000_0000_0001_0000;
			'd5:	d_o = 32'b0000_0000_0000_0000_0000_0000_0010_0000;
			'd6:	d_o = 32'b0000_0000_0000_0000_0000_0000_0100_0000;
			'd7:	d_o = 32'b0000_0000_0000_0000_0000_0000_1000_0000;
			'd8:	d_o = 32'b0000_0000_0000_0000_0000_0001_0000_0000;
			'd9:	d_o = 32'b0000_0000_0000_0000_0000_0010_0000_0000;
			'd10:	d_o = 32'b0000_0000_0000_0000_0000_0100_0000_0000;
			'd11:	d_o = 32'b0000_0000_0000_0000_0000_1000_0000_0000;
			'd12:	d_o = 32'b0000_0000_0000_0000_0001_0000_0000_0000;
			'd13:	d_o = 32'b0000_0000_0000_0000_0010_0000_0000_0000;
			'd14:	d_o = 32'b0000_0000_0000_0000_0100_0000_0000_0000;
			'd15:	d_o = 32'b0000_0000_0000_0000_1000_0000_0000_0000;
			'd16:	d_o = 32'b0000_0000_0000_0001_0000_0000_0000_0000;
			'd17:	d_o = 32'b0000_0000_0000_0010_0000_0000_0000_0000;
			'd18:	d_o = 32'b0000_0000_0000_0100_0000_0000_0000_0000;
			'd19:	d_o = 32'b0000_0000_0000_1000_0000_0000_0000_0000;
			'd20:	d_o = 32'b0000_0000_0001_0000_0000_0000_0000_0000;
			'd21:	d_o = 32'b0000_0000_0010_0000_0000_0000_0000_0000;
			'd22:	d_o = 32'b0000_0000_0100_0000_0000_0000_0000_0000;
			'd23:	d_o = 32'b0000_0000_1000_0000_0000_0000_0000_0000;
			'd24:	d_o = 32'b0000_0001_0000_0000_0000_0000_0000_0000;
			'd25:	d_o = 32'b0000_0010_0000_0000_0000_0000_0000_0000;
			'd26:	d_o = 32'b0000_0100_0000_0000_0000_0000_0000_0000;
			'd27:	d_o = 32'b0000_1000_0000_0000_0000_0000_0000_0000;
			'd28:	d_o = 32'b0001_0000_0000_0000_0000_0000_0000_0000;
			'd29:	d_o = 32'b0010_0000_0000_0000_0000_0000_0000_0000;
			'd30:	d_o = 32'b0100_0000_0000_0000_0000_0000_0000_0000;
			'd31:	d_o = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
		endcase
	end
	else
		d_o = 'd0;
end


endmodule
