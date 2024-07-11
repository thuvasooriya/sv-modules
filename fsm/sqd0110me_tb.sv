// test bench for overlapping mealy sequence detector for 1010
`include "sqd0110me.sv"

module sqd0110me_tb;
  logic clk;
  logic rstn;
  logic out;
  logic in;

  sqd0110me sd (
      .clk (clk),
      .rstn(rstn),
      .in  (in),
      .out (out)
  );

  // clock generation
  always #2 clk = ~clk;

  logic [15:0] test_sequence = 16'b0110011011000110;
  logic [15:0] expected_output = 16'b0000100010001000;

  initial begin
    clk  <= 0;
    rstn <= 0;
    in   <= 0;

    repeat (2) @(posedge clk);  // waiting 2 clock cycles
    rstn <= 1;

    // apply test sequence
    for (int i = 0; i < 16; i++) begin
      @(posedge clk);
      in = test_sequence[15-i];
    end

    @(posedge clk);

    repeat (5) @(posedge clk);  // wait for a while
    $finish;  // time to end the simulation
  end

  // assert property (@(posedge clk) disable iff (!rstn) in == $past(
  //     test_sequence[15-$past($countones(out))]
  // ) |-> out == ecpected_output[15-$countones(
  //     out
  // )])
  // else $error("assertion failed: incorrect output for input");
  //
  // assert property (@(posedge clk) disable iff (!rstn) $rose(
  //     out
  // ) |-> $past(
  //     in, 1
  // ) == 0 && $past(
  //     in, 2
  // ) == 1 && $past(
  //     in, 3
  // ) == 1 & $past(
  //     in, 4
  // ) == 0)
  // else $error("assertion failed: 0110 not detected correctly");

  initial begin  // all initial blocks start at the same time and execute in parallel
    $dumpfile("waveform.vcd");
    $dumpvars(0, sd);
  end

  initial begin
    // $monitor("time=%t: rstn=%b out=%b state=%s", $time, rstn, in, out, sd.state.name);
  end

endmodule

// TODO: oh i'm tired lot's to do
// fix asserts
// implement random
