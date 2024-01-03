module Multiplexers(Rout,Gout,DINout,DIN,R0out,R1out,R2out,R3out,R4out,R5out,R6out,R7out,G,Bus);
input [15:0] DIN,R0out,R1out,R2out,R3out,R4out,R5out,R6out,R7out,G;
input [7:0] Rout;
input Gout,DINout;
output reg [15:0]Bus;
always @(*)
begin
if (DINout==1) Bus=DIN;
else
if (Gout==1) Bus=G;
else
case (Rout)
8'b10000000: Bus=R0out;
8'b01000000: Bus=R1out;
8'b00100000: Bus=R2out;
8'b00010000: Bus=R3out;
8'b00001000: Bus=R4out;
8'b00000100: Bus=R5out;
8'b00000010: Bus=R6out;
8'b00000001: Bus=R7out;
endcase
end
endmodule