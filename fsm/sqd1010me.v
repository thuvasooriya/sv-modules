// legacy implementation of overlapping mealy sequence detector code,
module sqd1010me (
    input  wire clk,
    input  wire rstn,
    input  wire in,
    output wire out
);

  parameter S0 = 2'h0;  // 1010
  parameter S1 = 2'h1;  // 1
  parameter S2 = 2'h2;  // 10
  parameter S3 = 2'h3;  // 101

  reg [1:0] state, nextstate;

  always @(posedge clk or negedge rstn) begin
    state <= !rstn ? S0 : nextstate;
  end

  // mealy is async to clock but still sequential
  always @(state or in) begin
    case (state)
      S0: nextstate = in ? S1 : S0;
      S1: nextstate = in ? S1 : S2;
      S2: nextstate = in ? S3 : S0;
      S3: nextstate = in ? S1 : S2;
      default: nextstate = S0;
    endcase
  end

  // combinational output logic
  assign out = (state == S3) && (in == 0) ? 1 : 0;

endmodule

// useful discussions
// https://stackoverflow.com/questions/47297001/verilog-error-not-a-valid-l-value
