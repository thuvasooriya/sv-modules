typedef enum logic [1:0] {
  S0,
  S1,
  S2,
  S3
} state_t;

// non overlapping sequence detector for 0110 as a mealy state machine
module sqd0110meno (
    input  logic clk,
    input  logic rstn,
    input  logic in,
    output logic out
);
  state_t state, nextstate;

  // state register
  always_ff @(posedge clk or negedge rstn) begin
    // if (!rstn) begin
    //   state <= S0;
    // end else begin
    //   state <= nextstate;
    // end
    state <= !rstn ? S0 : nextstate;
  end

  // output and next state logic
  always_comb begin
    out = 1'b0;
    case (state)
      S0: nextstate = in ? S0 : S1;
      S1: nextstate = in ? S2 : S1;
      S2: nextstate = in ? S3 : S1;
      S3: begin
        nextstate = S0;
        out = in ? 1'b0 : 1'b1;
      end
      default: nextstate = S0;
    endcase
  end

endmodule

// TODO:
// 1. code - done
// 2. testbench
// 3. verify
