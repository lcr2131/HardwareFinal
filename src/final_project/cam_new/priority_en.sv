///////////////////////////////////////////////////////////////////////////////////////////////////
//	Team member:	Tong Zhang, Chaoying Kang, Shuying Fan					//
//	Module function:	Priority encoder with search_valid generation			//
//	Modification Date:	October 1, 2012							//
//												//
//////////////////////////////////////////////////////////////////////////////////////////////////

module priority_en
(
	input [31:0]	p_i,
//	input		en,
	output logic [4:0]	p_o,
	output logic search_valid
);

//logic p_o;

always_comb
begin
casex (p_i)
	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxx1:	begin p_o = 'd0; search_valid = 'd1;  end
	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx10:	begin p_o = 'd1; search_valid = 'd1; end
	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x100:	begin p_o = 'd2; search_valid = 'd1; end
	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_1000:	begin p_o = 'd3; search_valid = 'd1; end
	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxx1_0000:	begin p_o = 'd4; search_valid = 'd1; end
	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xx10_0000:	begin p_o = 'd5; search_valid = 'd1; end
	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_x100_0000:	begin p_o = 'd6; search_valid = 'd1; end
	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxxx_1000_0000:	begin p_o = 'd7; search_valid = 'd1; end
	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xxx1_0000_0000:	begin p_o = 'd8; search_valid = 'd1; end
	32'bxxxx_xxxx_xxxx_xxxx_xxxx_xx10_0000_0000:	begin p_o = 'd9; search_valid = 'd1; end
	32'bxxxx_xxxx_xxxx_xxxx_xxxx_x100_0000_0000:	begin p_o = 'd10; search_valid = 'd1;  end
	32'bxxxx_xxxx_xxxx_xxxx_xxxx_1000_0000_0000:	begin p_o = 'd11; search_valid = 'd1;  end
	32'bxxxx_xxxx_xxxx_xxxx_xxx1_0000_0000_0000:	begin p_o = 'd12; search_valid = 'd1;  end
	32'bxxxx_xxxx_xxxx_xxxx_xx10_0000_0000_0000:	begin p_o = 'd13; search_valid = 'd1;  end
	32'bxxxx_xxxx_xxxx_xxxx_x100_0000_0000_0000:	begin p_o = 'd14; search_valid = 'd1;  end
	32'bxxxx_xxxx_xxxx_xxxx_1000_0000_0000_0000:	begin p_o = 'd15; search_valid = 'd1;  end
	32'bxxxx_xxxx_xxxx_xxx1_0000_0000_0000_0000:	begin p_o = 'd16; search_valid = 'd1;  end
	32'bxxxx_xxxx_xxxx_xx10_0000_0000_0000_0000:	begin p_o = 'd17; search_valid = 'd1;  end
	32'bxxxx_xxxx_xxxx_x100_0000_0000_0000_0000:	begin p_o = 'd18; search_valid = 'd1;  end
	32'bxxxx_xxxx_xxxx_1000_0000_0000_0000_0000:	begin p_o = 'd19; search_valid = 'd1;  end
	32'bxxxx_xxxx_xxx1_0000_0000_0000_0000_0000:	begin p_o = 'd20; search_valid = 'd1;  end
	32'bxxxx_xxxx_xx10_0000_0000_0000_0000_0000:	begin p_o = 'd21; search_valid = 'd1;  end
	32'bxxxx_xxxx_x100_0000_0000_0000_0000_0000:	begin p_o = 'd22; search_valid = 'd1;  end
	32'bxxxx_xxxx_1000_0000_0000_0000_0000_0000:	begin p_o = 'd23; search_valid = 'd1;  end
	32'bxxxx_xxx1_0000_0000_0000_0000_0000_0000:	begin p_o = 'd24; search_valid = 'd1;  end
	32'bxxxx_xx10_0000_0000_0000_0000_0000_0000:	begin p_o = 'd25; search_valid = 'd1;  end
	32'bxxxx_x100_0000_0000_0000_0000_0000_0000:	begin p_o = 'd26; search_valid = 'd1;  end
	32'bxxxx_1000_0000_0000_0000_0000_0000_0000:	begin p_o = 'd27; search_valid = 'd1;  end
	32'bxxx1_0000_0000_0000_0000_0000_0000_0000:	begin p_o = 'd28; search_valid = 'd1;  end
	32'bxx10_0000_0000_0000_0000_0000_0000_0000:	begin p_o = 'd29; search_valid = 'd1;  end
	32'bx100_0000_0000_0000_0000_0000_0000_0000:	begin p_o = 'd30; search_valid = 'd1;  end
	32'b1000_0000_0000_0000_0000_0000_0000_0000:	begin p_o = 'd31; search_valid = 'd1;  end
	32'b0000_0000_0000_0000_0000_0000_0000_0000:	begin p_o = 'd31; search_valid = 'd0;  end
	default:	begin p_o = 'x; search_valid = 'd0; end
endcase
end

endmodule
