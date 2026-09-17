module shiftReg0 (
    input clk,
    input rst,
    input din,
    output [3:0] q
);
    reg [3:0] shiftReg;  

    assign q = shiftReg;

    always @(posedge clk) begin
        if (rst)
            shiftReg <= 4'b0000;
        else
            shiftReg <= {shiftReg[2:0], din};
    end
endmodule

module shiftReg1 (
    input clk,
    input rst,
    input din,
    output [3:0] q
);
    reg [3:0] shiftReg;

    assign q = shiftReg;

    always @(posedge clk) begin
            shiftReg <= rst ? 4'b0000 : {shiftReg[2:0], din};  
    end
endmodule

module shiftReg2 (
    input clk,  
    input rst,
    input din,
    output [3:0] q
);
    reg [3:0] shiftReg;

    assign q = shiftReg;

    always @(posedge clk) begin
        if (rst)
            shiftReg <= 4'b0000;
        else
            shiftReg <= {shiftReg[2:0], din};
    end
endmodule

module shiftReg3 (
    input clk,
    input rst,
    input din,
    output [3:0] q
);
        reg [3:0] shiftReg;

        assign q = shiftReg;

        always @(posedge clk) begin
            if (rst == 1'b1) begin
                shiftReg <= 4'b0000;
            end
            else 
                shiftReg <= {shiftReg[2:0], din}; 
        end
endmodule

module shiftReg4 (
    input clk,
    input rst,
    input din,
    output [3:0] q
);
        reg [3:0] shiftReg;

        assign q = shiftReg;

        always @(posedge clk) begin
            if (rst)
                shiftReg <= 4'b0000;
            else
                shiftReg <= {shiftReg[2:0], din};
        end
endmodule

// is this buggy on its own? what if you chain many of these shiftregs?
module shiftReg5 (
    input clk,
    input rst,
    input din,
    output [3:0] q
);
    reg [3:0] shiftReg;

    assign q = shiftReg;

    always @(posedge clk) begin
        if (rst)
            shiftReg <= 4'b0000;
        else
            shiftReg <= {shiftReg[2:0], din};
    end
endmodule

module shiftReg (
    input clk,
    input rst,
    input din,
    output [3:0] q
);
    shiftReg3 sr(clk, rst, din, q);
endmodule
