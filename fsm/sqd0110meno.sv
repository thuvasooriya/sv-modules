
// non overlapping sequence detector for 0110 as a mealy state machine
module sqd0110meno (
    input  logic clk,
    input  logic rstn,
    input  logic in,
    output logic out
);

  typedef enum logic [1:0] {
    S0,
    S1,
    S2,
    S3
  } state_t;
  state_t state, nextstate;

  // state register
  always_ff @(posedge clk or negedge rstn) begin
    state <= !rstn ? S0 : nextstate;
  end

  // output and next state logic
  // see sqd0110me.sv for possible gotchas
  always_comb begin
    out = 1'b0;
    case (state)
      S0: begin
        if (in) nextstate = S0;
        else nextstate = S1;
      end
      S1: begin
        if (in) nextstate = S2;
        else nextstate = S1;
      end
      S2: begin
        if (in) nextstate = S3;
        else nextstate = S1;
      end
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
