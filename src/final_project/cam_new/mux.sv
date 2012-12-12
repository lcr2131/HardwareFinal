///////////////////////////////////////////////////////////////////////////////////////////////////
//	Team member:	Tong Zhang, Chaoying Kang, Shuying Fan					//
//	Module function:	MUX								//
//	Modification Date:	October 1, 2012							//
//												//
//////////////////////////////////////////////////////////////////////////////////////////////////

module mux #(parameter DATA_SIZE=32, SIZE= (DATA_SIZE*32))
(
	input [4:0] select,
	input [SIZE-1:0] d_i,
	output logic [DATA_SIZE-1:0] d_o
);

//	logic data;

always_comb
begin
case(select)
	'd0: d_o = d_i [DATA_SIZE-1:0];
	'd1: d_o = d_i [DATA_SIZE*2-1:DATA_SIZE];
	'd2: d_o = d_i [DATA_SIZE*3-1:DATA_SIZE*2];
	'd3: d_o = d_i [DATA_SIZE*4-1:DATA_SIZE*3];
	'd4: d_o = d_i [DATA_SIZE*5-1:DATA_SIZE*4];
	'd5: d_o = d_i [DATA_SIZE*6-1:DATA_SIZE*5];
	'd6: d_o = d_i [DATA_SIZE*7-1:DATA_SIZE*6];
	'd7: d_o = d_i [DATA_SIZE*8-1:DATA_SIZE*7];
	'd8: d_o = d_i [DATA_SIZE*9-1:DATA_SIZE*8];
	'd9: d_o = d_i [DATA_SIZE*10-1:DATA_SIZE*9];
	'd10: d_o = d_i [DATA_SIZE*11-1:DATA_SIZE*10];
	'd11: d_o = d_i [DATA_SIZE*12-1:DATA_SIZE*11];
	'd12: d_o = d_i [DATA_SIZE*13-1:DATA_SIZE*12];
	'd13: d_o = d_i [DATA_SIZE*14-1:DATA_SIZE*13];
	'd14: d_o = d_i [DATA_SIZE*15-1:DATA_SIZE*14];
	'd15: d_o = d_i [DATA_SIZE*16-1:DATA_SIZE*15];
	'd16: d_o = d_i [DATA_SIZE*17-1:DATA_SIZE*16];
	'd17: d_o = d_i [DATA_SIZE*18-1:DATA_SIZE*17];
	'd18: d_o = d_i [DATA_SIZE*19-1:DATA_SIZE*18];
	'd19: d_o = d_i [DATA_SIZE*20-1:DATA_SIZE*19];
	'd20: d_o = d_i [DATA_SIZE*21-1:DATA_SIZE*20];
	'd21: d_o = d_i [DATA_SIZE*22-1:DATA_SIZE*21];
	'd22: d_o = d_i [DATA_SIZE*23-1:DATA_SIZE*22];
	'd23: d_o = d_i [DATA_SIZE*24-1:DATA_SIZE*23];
	'd24: d_o = d_i [DATA_SIZE*25-1:DATA_SIZE*24];
	'd25: d_o = d_i [DATA_SIZE*26-1:DATA_SIZE*25];
	'd26: d_o = d_i [DATA_SIZE*27-1:DATA_SIZE*26];		
	'd27: d_o = d_i [DATA_SIZE*28-1:DATA_SIZE*27];		
	'd28: d_o = d_i [DATA_SIZE*29-1:DATA_SIZE*28];		
	'd29: d_o = d_i [DATA_SIZE*30-1:DATA_SIZE*29];		
	'd30: d_o = d_i [DATA_SIZE*31-1:DATA_SIZE*30];		
	'd31: d_o = d_i [DATA_SIZE*32-1:DATA_SIZE*31];
	default d_o = 'x;

endcase
end
endmodule		
		
