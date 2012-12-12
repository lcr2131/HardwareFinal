///////////////////////////////////////////////////////////////////////////////////////////////////
//	Team member:	Tong Zhang, Chaoying Kang, Shuying Fan					//
//	Module function:	CAM module for each row, containing 32 CAM cells		//
//	Modification Date:	October 1, 2012							//
//												//
//////////////////////////////////////////////////////////////////////////////////////////////////
module cam_row #(parameter DATA_WIDTH = 5,
			parameter DATA_SIZE = (1 << DATA_WIDTH))
(
	input clk,
	input rst,
	input search_en,
	input [DATA_SIZE - 1 : 0]	search_data,
	input [DATA_SIZE - 1 : 0]	data_in,
	input write_en,
	input read_en,
	output logic search_match,
	output [DATA_SIZE - 1 : 0]	 read_result_row,
	output logic read_vld_row
	
);
	reg [DATA_SIZE - 1 : 0]	search_match_bit;
	reg [DATA_SIZE - 1 : 0]	read_vld_bit;

generate for (genvar iter = 0 ; iter < DATA_SIZE ; iter ++)
begin
	cam_cell cam_row_iter
	(
		.clk,
		.rst,
		.search_en,
		.write_en,
		.read_en,
		.search_bit(search_data[iter]),
		.data_input(data_in[iter]),
		.search_match(search_match_bit[iter]),
		.read_result(read_result_row[iter]),
		.read_vld(read_vld_bit[iter])
	);
end
endgenerate

assign search_match = &search_match_bit[DATA_SIZE - 1 : 0];

assign read_vld_row = &read_vld_bit[DATA_SIZE - 1 : 0];

endmodule
