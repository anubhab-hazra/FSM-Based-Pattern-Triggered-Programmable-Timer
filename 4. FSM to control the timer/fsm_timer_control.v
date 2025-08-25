module timer_control (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
    
    parameter[3:0] idle=0,s1=1,s11=2,s110=3,shift0=4 /*also s1101*/ ,shift1=5,shift2=6,shift3=7,Count=8,Wait=9;
    reg[3:0] state,next_state;
    
    always@(*) begin
        case(state)
            idle: next_state<= (reset)? s1:((data)? s1:idle);  //if reset and got data
            s1: next_state<= (data)? s11:idle;
            s11: next_state<= (data)? s11:s110;
            s110: next_state<= (data)? shift0:idle;
            shift0: next_state<= shift1;
            shift1: next_state<= shift2;
            shift2: next_state<= shift3;
            shift3: next_state<= Count;
            Count: next_state<= (done_counting)? Wait:Count;
            Wait: next_state<= (ack)? idle:Wait;
        endcase
    end
    
    always@(posedge clk) begin
        if(reset) state<=idle;
        else state<=next_state;
    end
    
    assign shift_ena= (state==shift0 | state==shift1 | state==shift2 | state==shift3)? 1:0;
    assign counting= (state==Count)? 1:0;
    assign done= (state==Wait)? 1:0;
    
endmodule
