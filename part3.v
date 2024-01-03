module part3(DIN, Resetn, Clock, Run, Done, BusWires,Tstep_Q,IR,A,G,R0,R1,R2,R3,R4,R5,R6,R7,Tstep_D,I,Out_AddSub,Xreg,Yreg,Rin,Rout,AddSub,Ain,Gin,Gout,DINout,IRin,ADDRin,DOUTin,W_D,incr_pc,DOUT,ADDR,W);
output [15:0] DOUT,ADDR;
output W;
output [15:0] DIN;
input Resetn, Clock, Run;
output Done;
output [15:0] BusWires;
output [2:0]Tstep_Q;
output [2:0]Tstep_D;
output IRin;
output wire [8:0]IR;
output wire [2:0]I;
output wire [7:0]Xreg,Yreg;
output wire [16:0] R2,R3,R4,R5,R6,R7,Out_AddSub;
output wire [16:0] R0,R1,A,G;

output [7:0] Rin,Rout;
output AddSub,Ain,Gin,Gout,DINout,ADDRin,DOUTin,W_D,incr_pc;
enhanced_proc dut (DIN, Resetn, Clock, Run, Done, BusWires,Tstep_Q,IR,A,G,R0,R1,R2,R3,R4,R5,R6,R7,I,Tstep_D,Out_AddSub,Xreg,Yreg,Rin,Rout,AddSub,Ain,Gin,Gout,DINout,IRin,ADDRin,DOUTin,W_D,incr_pc,DOUT,ADDR,W);
RAM_1_PORT dut1 (ADDR,Clock,DOUT,W,DIN);
endmodule