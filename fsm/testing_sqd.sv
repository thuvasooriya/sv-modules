module det_1011 ( input clk,
                  input rstn,
                  input in,
                  output out );
  
  parameter IDLE 	= 0,
  			S1 		= 1,
  			S10 	= 2,
  			S101 	= 3,
  			S1011 	= 4;
  
  reg [2:0] cur_state, next_state;
  
  assign out = cur_state == S1011 ? 1 : 0;
  
  always @ (posedge clk) begin
    if (!rstn)
      	cur_state <= IDLE;
     else 
     	cur_state <= next_state;
  end
  
  always @ (cur_state or in) begin
    case (cur_state)
      IDLE : begin
        if (in) next_state = S1;
        else next_state = IDLE;
      end
      
      S1: begin
`ifdef BUG_FIX_1        
        // Designer assumed that if next input is 1,
        // state should start from IDLE. But he forgot
        // that it should stay in same state since it
        // already matched part of the pattern which 
        // is the starting "1"        
        if (in) next_state = S1;
`else
        if (in) next_state = IDLE;
`endif        
        else 	next_state = S10;
      end
      
      S10 : begin
        if (in) next_state = S101;        
        else 	next_state = IDLE;
      end
      
      S101 : begin
        if (in) next_state = S1011;
`ifdef BUG_FIX_2        
        // Designer assumed that if next input is 0, 
        // then pattern fails to match and should
        // restart. But he forgot that S101 followed
        // by 0 actually matches part of the pattern
        // which is "10" and only "11" is remaining
        // So it should actually go back to S10        
		else 	next_state = S10;
`else        
        else 	next_state = IDLE;
`endif        
      end
      
      S1011: begin
`ifdef BUG_FIX_3       
        // Designer assumed next state should always
        // be IDLE since the pattern has matched. But
        // he forgot that if next input is 1, it is
        // already the start of another sequence and
        // instead should go to S1.        
        if (in) next_state = S1; 
	`ifdef BUG_FIX_4        
        // Designer forgot again that if next input is 0
        // then pattern still matches "10" and should
        // go to S10 instead of IDLE.
        else    next_state = S10;
    `else
        else    next_state = IDLE;
	`endif
`else
       	next_state = IDLE;
`endif        
      end
    endcase
  end
endmodule
