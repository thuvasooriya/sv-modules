// overlapping sequence detector for 0110 as a mealy state machine
module sqd0110me (
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
  always_comb begin
    out = 1'b0;
    case (state)
      // BUG: iverilog doesn't allow ternary operator with 4 state enums
      // S0: nextstate = in ? S0 : S1;
      // S1: nextstate = in ? S2 : S1;
      // S2: nextstate = in ? S3 : S1;
      // S3: begin
      //   nextstate = in ? S0 : S1;  // difference in overlapping
      //   out = in ? 1'b0 : 1'b1;
      // end
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
        if (in) begin
          nextstate = S0;
        end else begin
          nextstate = S1;
        end
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

// related iverilog issues
// https://github.com/steveicarus/iverilog/issues/280
// https://github.com/steveicarus/iverilog/issues/1048
// https://github.com/steveicarus/iverilog/issues/1015
// https://accellera.mantishub.io/view.php?id=1429
//
// below is an extract from confusing standars statements from ieee 1800-2017
// an enum variable or identifier used as part of an expression is
// automatically cast to the base type of the enum declaration
// (either explicitly or using int as the default).
// a cast shall be required for an expression that is assigned to
// an enum variable where the type of the expression is not equivalent to
// the enumeration type of the variable.
