module round_robin_arbiter
(
    input        clk,
    input        reset,
    input  [3:0] req,
    output reg [3:0] grant
);
reg [1:0] pointer, winner;
reg [1:0] next_1, next_2, next_3; // Temporary variables to hold safely wrapped indices

always @(posedge clk)
    begin
        if(reset)
            begin
                pointer <= 0;
            end
        else if(req == 4'b0000)  
            pointer <= pointer;    
        else
            pointer <= winner + 1;    
    end

always @(*)
begin
  grant = 0;  
  winner = pointer;
  
  next_1 = pointer + 2'b1;
  next_2 = pointer + 2'd2;
  next_3 = pointer + 2'd3;

   if(req[pointer]) 
        begin
            grant[pointer] = 1;
            winner = pointer;
        end
    else if(req[next_1])   
        begin
            grant[next_1] = 1;
            winner = next_1;
        end 
    else if(req[next_2])   
        begin
            grant[next_2] = 1;
            winner = next_2;
        end 
    else if(req[next_3])   
        begin
            grant[next_3] = 1;
            winner = next_3;
        end         
end

endmodule