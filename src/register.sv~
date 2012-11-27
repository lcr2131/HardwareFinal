library DWARE,DWARE;
use DWARE.DWpackages.all;
use DWARE.DW_Foundation_comp.all;


module Register(
	input [9:0] read_addr,
	input [9:0] write_addr,
	input [63:0] data_in,
	input logic clk,
	input [1:0] cs_n,
	input [1:0] wr_n,
	input [1:0] rst_n,
	output [63:0] data_out);

	
	DW_ram_r_w_s_dff registerOne(.clk,.rst_n[0],.cs_n[0],.wr_n[0],.rd_addr[4:0],.wr_addr[4:0],.data_in[31:0],.data_out[31:0]);
	DW_ram_r_w_s_dff registerTwo(.clk,.rst_n[1],.cs_n[1],.wr_n[1],.rd_addr[9:5],.wr_addr[9:5],.data_in[63:32],.data_out[63:32]);	 
	

)
