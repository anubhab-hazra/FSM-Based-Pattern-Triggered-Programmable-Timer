module top_module (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q);
    
    reg[3:0] Q;
    always@(posedge clk) begin
        if(shift_ena) Q<={Q[2:0],data};
        else if(count_ena) Q<=Q-1;
    end
    
    assign q=Q;

endmodule
