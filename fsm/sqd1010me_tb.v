// test bench for overlapping mealy sequence detector for 1010
`include "sqd1010me.v"

module sqd1010me_tb ();
  reg clk, rstn, in;
  wire out;

  // forloop utils
  integer loop = 20;
  integer i;
  // reg [1:0] dly;
  // making delay only last 1 cycle at most
  reg dly = 1'b0;

  sqd1010me sd (
      .clk (clk),
      .rstn(rstn),
      .in  (in),
      .out (out)
  );

  // clock generation
  always #2 clk = ~clk;

  initial begin
    clk  <= 0;
    rstn <= 0;
    in   <= 0;

    repeat (2) @(posedge clk);  // waiting 2 clock cycles
    rstn <= 1;

    // usual predefined pattern way
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;
    @(posedge clk) in <= 1;
    @(posedge clk) in <= 0;


    // using for loop and urandom
    // NOTE: integer definition should be done above in iverilog -g2005
    // don't use non-blocking assignments in for loop without thinking
    // use of $random is discouraged in favour of $urandom (unsigned)
    for (i = 0; i < loop; i++) begin
      dly = $urandom;  // this must be blocked in order for the for loop to work
      repeat (dly) @(posedge clk);
      in <= $urandom;  // it doesn't matter if this is blocking or not since it's the last one
    end

    repeat (5) @(posedge clk);  // wait for a while
    $display(">>> testbench simulation ends >>>");
    $finish;  // time to end the simulation
  end

  initial begin  // all initial blocks start at the same time and execute in parallel
    $display(">>> testbench simulation begins >>>");
    $dumpfile("waveform.vcd");
    $dumpvars(0, sd);
  end

endmodule

// TODO: outsource data provider for sequence detectors to a separate module
// and implemnt assertions print specific to the testing modules
//

// useful links
// https://stackoverflow.com/questions/33536177/use-of-non-blocking-assignment-in-testbench-verilog
