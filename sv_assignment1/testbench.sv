module test_adder_tb;
  
  // clock configuration
  logic clk = 0, rstn = 0;
  localparam CLK_PERIOD = 10, N = 10, W = 3;
  initial forever #(CLK_PERIOD/2) clk <= ~clk;
  
  // testbench variables
  logic [W+$clog2(N)-1:0] tb_sum=0;
  logic [1:0][6:0] tb_data; // expected data
  assign tb_data = {to7seg(tb_sum / 10), to7seg(tb_sum % 10)};
  
  // module instantiation
  logic [W-1:0] s_data=0;
  logic [1:0][6:0] m_data;
  logic s_valid=0, s_ready, m_valid, m_ready;
  test_adder dut (.*);
  
  // random data driver
  initial begin
    $dumpfile("dump.vcd"); $dumpvars(0, dut, tb_sum, tb_data);
    @(posedge clk)  #1 rstn <= 1; // active low driver
    #(CLK_PERIOD*1) // delay to compensate
    repeat(N) begin
      @(posedge clk) #1 s_data <= $urandom_range(1,10);
    end
  end

  // assertion
  initial begin
    @(posedge clk) #(CLK_PERIOD*2)
    repeat(N+2) begin
      @(posedge clk) tb_sum = tb_sum + s_data;
      #1 $display("s_data: %d, tb_sum: %d, tb_data: %b, m_data: %b", s_data, tb_sum, tb_data, m_data);
      #1 if(m_valid && m_data) assert (m_data == tb_data) $display("OK, %b", m_data);
      else $error("Expected %b, got %b", tb_data, m_data);
    end
  end
  
  // control signals
  initial begin
    @(posedge clk)  #1 m_ready <= 1;
    @(posedge clk)  #1 s_valid <= 1;
    #(CLK_PERIOD*10)
    @(posedge clk)  #1  s_valid <= 0; s_data <= 0; 
    #(CLK_PERIOD*10)
    @(posedge clk)  #1 s_valid <= 1;
    #(CLK_PERIOD*12)
    $finish();
  end
  
endmodule
