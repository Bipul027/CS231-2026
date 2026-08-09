module comparator (
    input wire a,
    input wire b,
    output wire eq,
    output wire gt,
    output wire lt
);

    assign eq = (a & b) | ((~a) & (~b));
    assign gt = a & (~b);
    assign lt = b & (~a);
endmodule