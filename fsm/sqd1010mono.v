// legacy implementation of non overlapping moore sequence detector for 1010
module sqd1010mono (
    input  wire clk,
    input  wire rstn,
    input  wire in,
    output reg  out
);

  parameter S0 = 3'h0;  // idle
  parameter S1 = 3'h1;  // 1
  parameter S2 = 3'h2;  // 10
  parameter S3 = 3'h3;  // 101
  parameter S4 = 3'h4;  // 1010

  reg [2:0] state, nextstate;

  always @(posedge clk or negedge rstn) begin
    state <= !rstn ? S0 : nextstate;
  end

  // mealy is async to clock but still sequential
  always @(state or in) begin
    case (state)
      S0: nextstate <= in ? S1 : S0;
      S1: nextstate <= in ? S0 : S2;
      S2: nextstate <= in ? S3 : S0;
      S3: nextstate <= in ? S1 : S4;
      S4: nextstate <= in ? S1 : S0;
      default: nextstate <= S0;
    endcase
    out <= (state == S4) ? 1'b1 : 1'b0;
  end

endmodule
