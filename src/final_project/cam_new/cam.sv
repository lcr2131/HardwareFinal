///////////////////////////////////////////////////////////////////////////////////////////////////
//	Team member:	Tong Zhang, Chaoying Kang, Shuying Fan					//
//	Module function:	Top CAM module							//
//	Modification Date:	October 1, 2012							//
//												//
//////////////////////////////////////////////////////////////////////////////////////////////////

module cam #(parameter DATA_SIZE = 32, SIZE = DATA_SIZE*32)
(
	input clk,
	input rst,
	input read,
	input [4:0] read_index,
	input write,
	input [4:0] write_index,
	input [31:0] write_data,
	input search,
	input [31:0] search_data,

	output logic read_valid,
	output logic [31:0] read_value,
	output  search_valid,
	output logic [4:0] search_index
);

//mux
wire [SIZE-1:0] all_data;
wire [DATA_SIZE - 1 : 0] read_data_vld;

mux Mux_read_data (.d_i(all_data), .d_o(read_value), .select(read_index));

mux #(1) mux_read_vld  (.d_i(read_data_vld), .select(read_index), .d_o(read_valid));

//decoder_read
wire [31:0]	wr_en;
dec	dec_w	(
		.d_i(write_index),
		.en(write),
		.d_o(wr_en)
		);

wire [31:0]	re_en;
dec	dec_r	(
		.d_i(read_index),
		.en(read),
		.d_o(re_en)
		);

//cam_row connection
wire [31:0]	search_vld_each_row;
generate for(genvar iter = 0 ; iter < 32; iter++)
begin
	cam_row		cam_row_iter(
					.clk,
					.rst,
					.search_en(search),
					.search_data,
					.data_in(write_data),
					.write_en(wr_en[iter]),
					.read_en(re_en[iter]),
					.search_match(search_vld_each_row[iter]),
					.read_result_row(all_data[DATA_SIZE*(iter + 1) - 1 : DATA_SIZE*iter]),
					.read_vld_row(read_data_vld[iter])
				    );
end
endgenerate

//wire [4:0]	search_index_tmp;
//priority encoder
priority_en	priority_cam	(
					.p_i(search_vld_each_row),
				//	.en(search),
					.p_o(search_index),
					.search_valid
				);


endmodule
