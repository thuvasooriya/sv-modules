// module to add N numbers and convert them to a set of two 7seg outputs
module test_adder #(
    parameter N = 10,
    W = 3
) (
    input logic clk,
    rstn,
    m_ready,
    s_valid,
    input logic [W-1:0] s_data,
    output logic m_valid,
    s_ready,
    output logic [1:0][6:0] m_data
);

    enum logic {
        ADD  = 0,
        IDLE = 1
    }
        next_state, state;

    logic [$clog2(N+1)-1:0] counter_reg;
    logic [W+$clog2(N)-1:0] sum_reg;

    always_comb begin

        // combinational assignments
        m_valid = counter_reg == N;
        s_ready = (!m_valid) | m_ready;  //(m_valid & !m_ready) ? 0 : 1;

        // next_state decoder
        case (state)
            IDLE: next_state = s_valid && m_ready ? ADD : IDLE;
            ADD:  next_state = (counter_reg == N - 1) ? IDLE : ADD;
        endcase

    end

    always_ff @(posedge clk or negedge rstn) begin

        // active low reset
        if (!rstn) begin
            sum_reg <= 0;
            counter_reg <= 0;
            m_data <= {7'h00, 7'h00};
            state <= IDLE;
        end else begin

            state <= next_state;

            // sequential state assignments
            unique case (state)

                // update sum register and increment counter
                ADD: begin
                    counter_reg <= counter_reg + 1;
                    sum_reg <= sum_reg + s_data;
                end

                // check if done and send output signal
                IDLE: m_data <= (m_valid) ? {to7seg(sum_reg / 10), to7seg(sum_reg % 10)} : m_data;

            endcase
        end
    end

endmodule

// digit to 7 segment formatter
function [6:0] to7seg([3:0] digit);
    unique case (digit)
        0: return 7'b1111110;
        1: return 7'b0110000;
        2: return 7'b1101101;
        3: return 7'b1111001;
        4: return 7'b0110011;
        5: return 7'b1011011;
        6: return 7'b1011111;
        7: return 7'b1110000;
        8: return 7'b1111111;
        9: return 7'b1111011;
        default: return 7'b0000000;
    endcase
endfunction
