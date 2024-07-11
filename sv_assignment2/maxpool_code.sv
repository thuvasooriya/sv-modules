// hardware design for 2X2 maxpooling ThuvaS

package types;
  typedef enum {
    S1,
    S2,
    S3
  } type_state_t;
endpackage

module maxpool
  import types::*;
#(
    parameter R = 4,
    W = 8
) (
    input logic clk,
    rstn,

    input logic s_valid,
    output logic s_ready,
    input logic [R-1:0][W-1:0] s_data,

    output logic m_valid,
    input logic m_ready,
    output logic [R/2-1:0][W-1:0] m_data
);

  type_state_t state = S1;  // initialize state to first state

  // use nonblocking assignments for sequential logic
  always_ff @(posedge clk or negedge rstn) begin
    if (~rstn) state <= S1;
    else begin
      case (state)
        S1: if (s_valid && s_ready) state <= S2;
        S2: if (s_valid && s_ready) state <= S3;
        S3: if (m_ready) state <= S1;
      endcase
    end
    m_valid <= (state == S3);
  end

  genvar r;
  for (r = 0; r < R / 2; r++) begin
    max_2x2 #(
        .W(W)
    ) UNIT (
        .clk(clk),
        .en(s_ready && s_valid),
        .rstn(rstn),
        .state(state),
        .s_data({s_data[2*r], s_data[2*r+1]}),
        .m_data(m_data[r])
    );
  end

  // use combinational logic for s_ready assignment
  assign s_ready = m_ready && state != S3;

endmodule


module max_2x2

  import types::*;
#(
    parameter W = 8
) (
    input logic clk,
    rstn,
    en,
    input type_state_t state,
    input logic [1:0][W-1:0] s_data,
    output logic [W-1:0] m_data
);

  logic [W-1:0] comp_in_1, comp_in_2, comp_out;
  logic [W-1:0] max_1, max_2;

  // use nonblocking assignments for sequential logic
  always_ff @(posedge clk) begin
    if (en) begin
      case (state)
        S1: max_1 <= comp_out;
        S2: max_2 <= comp_out;
      endcase
    end
    if (state == S3) m_data <= comp_out;
  end

  // use combinational logic for comp_in assignment
  always_comb begin
    case (state)
      S1, S2: {comp_in_1, comp_in_2} = {s_data[0], s_data[1]};
      S3: {comp_in_1, comp_in_2} = {max_1, max_2};
    endcase
    // use ternary operator for readability
    comp_out = (comp_in_1 > comp_in_2) ? comp_in_1 : comp_in_2;  // unsigned
  end

endmodule

