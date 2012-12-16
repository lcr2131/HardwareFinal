interface processor_interface(input bit clk);
   
   logic[31:0]	instruction_1_i;
   logic [31:0] instruction_2_i;
   logic [31:0] data_out_o;
   logic [4:0] 	pc_o;

   clocking cb @(posedge clk);
      output 	instruction_1_i,
		instruction_2_i;
      
      input 	data_out_o,
		pc_o;
   endclocking


   modport dut
     (
      input  clk,
      input  instruction_1_i,
      input  instruction_2_i, 
      output data_out_o,
      output pc_o
      );

   modport bench(clocking cb);

endinterface


