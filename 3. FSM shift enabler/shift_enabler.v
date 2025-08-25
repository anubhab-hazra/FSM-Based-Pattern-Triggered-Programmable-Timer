module shift_enabler (
    input clk,
    input reset,      // Synchronous reset
    output shift_ena);
    
    parameter S0=0,S1=1,S2=2,S3=3,S4=4;
    reg[2:0] state,next_state;
    
    always@(*) begin
        case(state)
            S0: next_state<=(reset)?S1:S0;
            S1: next_state<=S2;
            S2: next_state<=S3;
            S3: next_state<=S4;
            S4: next_state<=S0;
        endcase
    end
    
    always@(posedge clk) begin
        state<=next_state;
    end
    
    assign shift_ena=(state==S1|state==S2|state==S3|state==S4)? 1:0;

endmodule
