//Author: Leonard RObinson
//Date Modified: 12-13-2012

//`timescale 1ns/1ns

module top();


   bit clk = 0;

   always #5 clk = ~clk;

   initial $vcdpluson;

   all_checker_interface IFC(clk);
   all_checker_dut(IFC.all_checker_dut);
   testbench bench(IFC.all_checker_bench);

endmodule // top
