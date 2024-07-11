// testbench for maxpool module
module maxpool_tb;
  // time unit declaration
  timeunit 1ns / 1ps;

  localparam R = 4;
  localparam W = 8;
  localparam CLK_PERIOD = 10;

  // signal declarations
  logic clk = 0;
  logic rstn = 0;
  logic s_valid = 0;
  logic m_valid;
  logic s_ready;
  logic m_ready = 1;
  logic [R-1:0][W-1:0] s_data;
  logic [R/2-1:0][W-1:0] m_data;

  // DUT instantiation
  maxpool #(
      .R(R),
      .W(W)
  ) dut (
      .*
  );

  // clock generation
  initial forever #(CLK_PERIOD / 2) clk <= ~clk;

  // reset generation
  initial begin
    $dumpfile("");
    $dumpvars;
    // wait for some time before starting the reset
    repeat (2) @(posedge clk);
    // release the reset signal
    #1 rstn = 1;
  end

  int i = 0;
  // input generation
  initial begin
    // wait for the reset to complete
    repeat (2) @(posedge clk);
    // generate input
    while (i < 10) begin
      @(posedge clk);
      if (!s_ready) continue;
      // generate s_data values
      #1
      for (int r = 0; r < R; r++) begin
        s_valid   = 1;
        s_data[r] = $urandom_range(0, 2 ** W);
      end
      i++;
    end
    @(posedge clk) #1 s_valid = 0;
  end
endmodule

