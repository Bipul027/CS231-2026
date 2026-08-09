module fourbit_comparator (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire eq,
    output wire gt,
    output wire lt
);

    wire [3:0] e, g, l;
    comparator comp3(a[3], b[3], e[3], g[3], l[3]);
    comparator comp2(a[2], b[2], e[2], g[2], l[2]);
    comparator comp1(a[1], b[1], e[1], g[1], l[1]);
    comparator comp0(a[0], b[0], e[0], g[0], l[0]);

    assign eq = e[3] & e[2] & e[1] & e[0];
    assign gt = (g[3]) | (e[3] & g[2]) | (e[3] & e[2] & g[1]) | (e[3] & e[2] & e[1] & g[0]);
    assign lt = (l[3]) | (e[3] & l[2]) | (e[3] & e[2] & l[1]) | (e[3] & e[2] & e[1] & l[0]);
endmodule