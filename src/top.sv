//Author:
//Name: top.sv
//Date Created:
//Date Modified:

//`timescale 1ns/1ns

module top();

   bit clk = 0;
   always #5 clk = ~clk;

   initial $vcdpluson;

   processor_interface IFC(clk);
   //   processor dut(IFC.dut); 
   testbench bench(IFC.bench);
   


endmodule //top