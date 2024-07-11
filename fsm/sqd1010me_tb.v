// test bench for overlapping mealy sequence detector for 1010
module sqd1010me_tb ();
  reg clk, rst_n, x;
  wire z;

  // extract data provider for sequence detectors to a separate module
  // and implemnt assertions specific to the testing modules
  sqd1010me sd (
      clk,
      rst_n,
      x,
      z
  );

  initial clk = 0;
  always #2 clk = ~clk;

  initial begin
    x = 0;
    #1 rst_n = 0;
    #2 rst_n = 1;

    #3 x = 1;
    #4 x = 1;
    #4 x = 0;
    #4 x = 1;
    #4 x = 0;
    #4 x = 1;
    #4 x = 0;
    #4 x = 1;
    #4 x = 1;
    #4 x = 1;
    #4 x = 0;
    #4 x = 1;
    #4 x = 0;
    #4 x = 1;
    #4 x = 0;
    #10;
    $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end
endmodule
