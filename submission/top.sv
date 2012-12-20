`timescale 1ns/1ns

module top();

   bit clk = 0;
   always #5 clk = ~clk;

   initial $vcdpluson;

   top_pipeline_interface IFC(clk);
   top_pipeline dut(IFC.top_pipeline_dut); 
   testbench bench(IFC.top_pipeline_bench);

endmodule //top