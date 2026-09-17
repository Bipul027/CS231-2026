module fourbit_adder (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire cout0, cout1, cout2;
    adder HA1 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(cout0)
    );
    adder HA2 (
        .a(a[1]),
        .b(b[1]),
        .cin(cout0),
        .sum(sum[1]),
        .cout(cout1)
    );
    adder HA3 (
        .a(a[2]),
        .b(b[2]),
        .cin(cout1),
        .sum(sum[2]),
        .cout(cout2)
    );
    adder HA4 (
        .a(a[3]),
        .b(b[3]),
        .cin(cout2),
        .sum(sum[3]),
        .cout(cout)
    );
endmodule