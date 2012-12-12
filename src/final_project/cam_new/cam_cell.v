///////////////////////////////////////////////////////////////////////////////////////////////////
//	Programmer:	Tong Zhang								//
//	Module function:	CAM_cell module, realize read, wirte and search for 1-bit data	//
//	Modification Date:	12/09/2012							//
//												//
//////////////////////////////////////////////////////////////////////////////////////////////////

module cam_cell
(
	input clk,
	input rst,
	input search_en,
	input search_bit,
	input data_input,
	input write_en,
	input read_en,
	output logic search_match,
	output logic read_result,
	output logic read_vld
);

//	reg data_saved;
	reg search_vld;
	reg data_o;
	reg data_i;

	reg data_ff;


//read function
always_ff@ (negedge clk or posedge rst)
begin
	if (rst)
		read_result <= 'd0; 
	else if (read_en)
		read_result <= data_ff; 
end

//write function
always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
	begin
		data_ff <= 'd0;
		search_vld <= 'd0;
		read_vld <= 'd0;
	end
	else if (write_en)
	begin
		data_ff <= data_input;
		search_vld <= 'd1;
		read_vld <= 'd1;
	end
end

//search function
//always_comb
//begin
//	assign search_match = (~search_en) ? 'x : ((search_vld && (search_bit == data_ff)) ? 'd1 : 'd0);
//end


always_comb 
begin
	if (search_en)
	begin
		if (search_vld && search_bit == data_ff)
			search_match = 'd1;
		else
			search_match = 'd0;
	end
	else
			search_match = '0;
end


endmodule
