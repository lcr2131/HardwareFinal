module cam_test();

    parameter DATA_WIDTH = 5;
    parameter DATA_SIZE = (1 << DATA_WIDTH);

    reg clk;
    reg rst;
    reg read;
    reg write;
    reg search;
    reg [DATA_WIDTH - 1 : 0] write_index;
    reg [DATA_SIZE - 1 : 0] write_data;
    reg [DATA_SIZE - 1 : 0] search_data;
    reg [DATA_WIDTH - 1 : 0] read_index;

    wire [DATA_WIDTH - 1 : 0] search_index;
    wire [DATA_SIZE - 1 : 0] read_value;
    wire search_valid;
    wire read_valid;

    cam cam_top_1 (.clk, .rst, .write, .write_index, .write_data,
                 .search_data, .search_index, .read_index, .read,
                 .search, .read_value, .search_valid, .read_valid);

    initial begin

	$vcdpluson;

        // Beginning of time.  Reset is on.
        clk = 0;
        rst = 1;
        search_data = 0;
        search = 0;
        write_data = 7;
        write_index = 9;
        write = 0;
        read_index = 9;
        read = 0;
 
        // Wait a clock cycle.
        #1 clk = 1;
        #1 clk = 0;
        rst = 0;

        // Done with reset.  Wait a cycle.
        #1 clk = 1;       
        #1 clk = 0;       
        #1 $display("search_index should be 31.  It is: %d", search_index);
        $display("search valid should be 0.  It is: %d", search_valid);

        // Write the value 7 to address 9.  Search for 7.
        // Read from address 9.
        write = 1;
        #1 clk = 1;
        read = 1;
        search = 1;
        search_data = 7;
        #1 clk = 0;
        #1 $display("search_index should 9.  It is: %d", search_index);
        $display("search valid should be 1.  It is: %d", search_valid);
        $display("read_value should be 7.  It is: %d", read_value);
        $display("read_valid should be 1.  It is: %d", read_valid);
    end

endmodule
