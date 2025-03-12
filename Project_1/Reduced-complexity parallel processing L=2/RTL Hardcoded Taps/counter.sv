module counter
#(parameter COUNT = 9)
(
input              clk, reset_n,
output [COUNT-1:0] count
);
reg  [COUNT-1:0] count_reg, count_next;
wire [COUNT-1:0] count_max = 'd469;
always@(posedge clk, negedge reset_n)
begin
  if(!reset_n)
    count_reg <= 0;
  else
    count_reg <= count_next;
end

always@(*)
begin
   if(count_next == count_max) 
      count_next = 0;
  else
    count_next = count_reg +1;  
end

assign count = count_reg;
endmodule