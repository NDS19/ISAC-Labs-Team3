
module multiplier_iterative(
    input clk,
    input logic valid_in, //input that determines if we want to actually multiply
    //the inputs together
    input logic[31:0] a,
    input logic[31:0] b,
    output logic valid_out,
    output logic[63:0] r
);
    logic[31:0] mp, mp_next; //multiplier
    logic[63:0] mc, mc_next; //multiplicand, will be shifted
    logic[63:0] acc, acc_next; //register where we store the product and make
    //repeat additions
    logic[5:0] i, i_next; //iterates through all of the bits we need to go through
    //6 bits since we need to represent 32
    //used for indexing

    // Note: using @(*) to get around reported bug in iverilog:
    //  multiplier_iterative_v0.v:15: sorry: constant selects in always_*
    //processes are not currently supported (all bits will be included).
    always @(*) begin
        if (valid_in == 1) begin
        //initialising/resetting values in the beginning
            mp_next = a;
            mc_next = b;
            acc_next = 0;
            i_next = 0;
        end
        else if (i <= 32) begin
            acc_next = acc + ( mp[0] ? mc : 0 );
            //if the current bit of the multiplier is 1, add the current mc otherwise do nothing
            mp_next = mp>>1; //right shift the multiplier so we are looking at the next bit
            mc_next = mc<<1; //left shift the multiplicand to the left so that
            //if we add anything, it will work properly
            i_next = i + 1;
            //increment i_next so that i increments with it (since they are assigned together)
        end
    end

    //combinatorial logic is performed first then we perform the clocked
    //operations here in the always_ff block
    always_ff @(clk) begin
        mp_next <= mp;
        mc <= mc_next;
        acc <= acc_next;
        i <= i_next;
        if (i==32) begin
            r <= acc_next;
            valid_out <= 1; //once we've calculated the correct output, valid_out
            //goes out and stays high until valid_in is set to 1
        end
        else begin
            valid_out <= 0;
        end
    end
endmodule
