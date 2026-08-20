module sat_counter (
    input wire clk,
    input wire rst,
    input wire up,
    input wire down,
    output reg [3:0] count
);
    // Design this module yourself, following the pattern from Task 3/4:
    // a combinational block (a wire) computes the next value of count,
    // and a sequential block registers it on the clock edge.
    //
    // Behavior:
    //   - synchronous rst forces count to 0, overriding everything else
    //   - if up=1 and down=0: count increments, but saturates at 15 (stays
    //     at 15 instead of wrapping to 0)
    //   - if down=1 and up=0: count decrements, but saturates at 0 (stays
    //     at 0 instead of wrapping to 15)
    //   - if up and down are equal (00 or 11): count holds its value

    reg [3:0] next_c;
    always@ (*) begin
        if (up == 1 && down == 0) begin
            if (next_c != 4'b1111) 
                next_c = count + 1;
        end
        else if (down == 1 && up == 0) begin
            if (next_c != 4'b0000)
                next_c = count - 1;
        end
        else begin
            next_c = count;
        end
    end

    always@ (posedge clk) begin
        if (rst) count <= 0;
        else count <= next_c;
    end
endmodule
