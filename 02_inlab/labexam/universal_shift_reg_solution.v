module universal_shift_reg (
    input clk,
    input rst,
    input [1:0] mode,
    input serial_in,
    input [3:0] parallel_in,
    output [3:0] q
);
    // TODO: Implement the universal shift register.
    reg [3:0] q_reg;
    assign q = q_reg;

    always @(posedge clk) begin
        if(rst)  q_reg <= 4'd0000;
        else begin
            case(mode)
                2'b00: q_reg <= q_reg;
                2'b01: q_reg <= {serial_in, q_reg[3:1]};
                2'b10: q_reg <= {q_reg[2:0],serial_in};
                2'b11: q_reg <= parallel_in;
                default: q_reg <= q_reg;
            endcase
        end
    end
endmodule