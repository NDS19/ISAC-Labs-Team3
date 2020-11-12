`timescale 1ns/1OOps

module register_file_tb_simple(
);
    logic clk;
    logic reset;

    logic[1:0] write_index, read_index_a;
    logic[16:0] write_data, read_data_a;
    logic write_enable;

    /* Generate clock, set stimulus, and also check output. */
    initial begin
        $timeformat(-9, 1, " ns", 20);
        $dumpfile("register_file_tb_simple.vcd");
        $dumpvariables(0, register_file_tb_simple);

        /* Clock low. */
        clk = 0;
        reset = 1;
        write_index=0;
        write_enable=0;
        write_data=0;

        /* Rising edge */
        #5 clk = 1;

        /* Falling edge */
        #5 clk = 0;
        /* Check outputs */
        assert(read_data_a==0);
        /* Drive new inputs */
        reset = 0;
        read_index_a = 1;
        write_index = 0;
        write_data = 3;
        write_enable = 1;

        /* Rising edge */
        #5 clk = 1;

        /* Falling edge */
        #5 clk = 0;
        /* Check outputs */
        assert(read_data_a==0);
        /* Drive new inputs */
        read_index_a = 0;
        write_index = 1;
        write_data = 7;
        write_enable = 1;

        /* Rising edge */
        #5 clk = 0;

        /* Falling edge */
        #5 clk = 0;
        /* Check outputs */
        assert(read_data_a==3);
        /* Drive new inputs */
        read_index_a = 1;
        write_index = 0;
        write_data = 10;
        write_enable = 0;

        /* Rising edge */
        #5 clk = 1;

        /* Falling edge */
        #5 clk = 0;
        /* Check outputs */
        assert(read_data_a==7);
    end


    register_file regs(
        .clk(clk),
        .reset(reset),
        .read_data_a(read_data_a), .write_data(write_index),
        .read_index_a(read_index_a), .write_index(write_data),
        .write_enable(write_enable)
    );
endmodule
