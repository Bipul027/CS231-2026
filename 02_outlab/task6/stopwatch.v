// TODO: 2-3 sentence written justification goes here.
// Why is `running` a reg? Why is the carry out of sec_ones naturally a
// wire, even though it's computed from values that are themselves regs?

module stopwatch (
    input  wire clk,
    input  wire rst,
    input  wire start_stop,   // one clock-cycle pulse per "button press"
    output reg [3:0] sec_ones,
    output reg [3:0] sec_tens,
    output reg [3:0] min_ones,
    output reg [3:0] min_tens,
    output wire tick_out       // exposes tick_gen's tick for the testbench;
                                // a real stopwatch chip wouldn't need this pin
);
    // Instantiate tick_gen here. Use a small LIMIT (e.g. 4) so the
    // testbench doesn't have to wait forever. Connect its tick output to
    // both your internal logic and to tick_out above.

    tick_gen t(.clk(clk), .rst(rst), .tick(tick_out));

    // running: a reg that toggles every time start_stop pulses high.
    // This is the only piece of state that decides whether anything
    // else in this module is allowed to change.

    reg running;
    always@(posedge clk) begin
        if (rst) running <= 1'b0;
        else if (start_stop) begin
            running = ~running; 
        end
    end

    // Combinational logic: for each digit, decide (a) whether it should
    // roll over back to 0 this tick, and (b) whether it should carry
    // into the next digit. sec_ones rolls over at 10 (0-9) and carries
    // into sec_tens; sec_tens rolls over at 6 (seconds only go 0-59) and
    // carries into min_ones; min_ones rolls over at 10 and carries into
    // min_tens; min_tens rolls over at 6, wrapping the whole stopwatch
    // back to 00:00.
    //

    reg [3:0] next_sec_ones, next_sec_tens, next_min_ones, next_min_tens;
    always@ (*) begin
        next_sec_ones = sec_ones;
        next_sec_tens = sec_tens;
        next_min_ones = min_ones;
        next_min_tens = min_tens;
        
        if (sec_ones == 9) begin
            next_sec_ones = 0;

            if (sec_tens == 5) begin
                next_sec_tens = 0;

                if (min_ones == 9) begin
                    next_min_ones = 0;

                    if (min_tens == 5) begin
                        next_min_tens = 0;
                    end
                    else begin
                        next_min_tens = min_tens + 1;
                    end
                end
                else begin
                    next_min_ones = min_ones + 1;
                end
            end
            else begin
                next_sec_tens = sec_tens + 1;
            end
        end
        else begin
            next_sec_ones = sec_ones + 1;
        end
    end

    // Sequential logic: on posedge clk, if rst is high, zero everything.
    // Otherwise, if running and tick, apply the next values you computed
    // combinationally above. If not running, or no tick this cycle, hold.

    always@ (posedge clk) begin
        if (rst) begin
            sec_ones <= 0;
            sec_tens <= 0;
            min_ones <= 0;
            min_tens <= 0;
        end
        else begin
            if (running && tick_out) begin
                sec_ones <= next_sec_ones;
                sec_tens <= next_sec_tens;
                min_ones <= next_min_ones;
                min_tens <= next_min_tens;
            end
        end
    end

endmodule
