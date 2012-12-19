////////////////////////////////////////////////////////////////////////////////////////////
////	Module Name: cycle_delay							////
////	Programmer: Shuying Fan								////
////	Date: 12/16									////
////	Function: delay flush signal for one cycle					////
////////////////////////////////////////////////////////////////////////////////////////////



module cycle_delay
  (
   input 	    clk,
   input 	    rst,
  
   input 	    flush,
   input [2:0] 	    bid,

   output reg 	    delay,
   output reg [2:0] delay_bid
   );


   //	reg 	tmp;


   always_ff @(posedge clk or posedge rst)
     begin 
	if (rst)
	  begin
	     delay <= 'd0;
	     delay_bid <= 'd0;
	  end

	else if (flush)
	  begin
	     delay <= 'd1;
	     delay_bid <= bid;
	  end
	else
	  delay <= 'd0;
	delay_bid <= 'd0;
	
     end



endmodule
