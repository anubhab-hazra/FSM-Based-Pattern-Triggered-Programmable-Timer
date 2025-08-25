module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );
    
    parameter[3:0] Idle=0,
    S1=1,
    S11=2,
    S110=3,
    S1101=4, //also Shift0
    Shift1=5,
    Shift2=6,
    Shift3=7,
    COUNT=8,
    DONE=9;
    
    reg[3:0] state,next_state;
    reg[9:0] count_1000;
    
    always@(*) begin
        case(state)
            Idle: next_state= (data)? S1:Idle;
            S1: next_state= (data)? S11:Idle;
            S11: next_state= (data)? S11:S110;
            S110: next_state= (data)? S1101:Idle;
            S1101: next_state=Shift1;
            Shift1: next_state=Shift2;
            Shift2: next_state=Shift3;
            Shift3: next_state=COUNT;
            COUNT: next_state= (count==0 & count_1000==999)? DONE:COUNT;
            DONE: next_state= (ack)? Idle:DONE;
        endcase
    end
    
    //state transition
    always@(posedge clk) begin
        if(reset) state<=Idle;
        else state<=next_state;
    end
    
    //shift in then down counter
    always@(posedge clk) begin
        case(state)
            S1101: count<={count[2:0],data};
            Shift1: count<={count[2:0],data};
            Shift2: count<={count[2:0],data};
            Shift3: count<={count[2:0],data};
            COUNT: begin
                if(count>=0) begin
                    if(count_1000<999)
                        count_1000<=count_1000+1;
                    else begin
                        count<=count-1;
                        count_1000<=0;
                    end
                end
            end
            default: count_1000<=0;
        endcase
    end
    
    assign counting= (state==COUNT)? 1:0;
    assign done= (state==DONE)? 1:0;

endmodule
