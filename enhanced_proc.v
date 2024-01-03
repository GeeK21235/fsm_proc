module counter(R,incr_pc,Rin,Clock,Q);
input Rin,incr_pc,Clock;
input [15:0]R;
output reg [15:0]Q;
always @(posedge Clock)
begin
if (Rin==1) Q <= R;
if (incr_pc==1) Q <= Q + 1;
end
endmodule

module dec3to8(W, En, Y);
input [2:0] W;
input En;
output [7:0] Y;
reg [7:0] Y;
always @(W or En)
begin
if (En == 1)
case (W)
3'b000: Y = 8'b10000000;
3'b001: Y = 8'b01000000;
3'b010: Y = 8'b00100000;
3'b011: Y = 8'b00010000;
3'b100: Y = 8'b00001000;
3'b101: Y = 8'b00000100;
3'b110: Y = 8'b00000010;
3'b111: Y = 8'b00000001;
endcase
else
Y = 8'b00000000;
end
endmodule

module regn(R, Rin, Clock, Q);
parameter n = 16;
input [n-1:0] R;
input Rin, Clock;
output [n-1:0] Q;
reg [n-1:0] Q;
always @(posedge Clock)
if (Rin)
Q <= R;
endmodule 


module enhanced_proc (DIN, Resetn, Clock, Run, Done, BusWires,Tstep_Q,IR,A,G,R0,R1,R2,R3,R4,R5,R6,R7,I,Tstep_D,Out_AddSub,Xreg,Yreg,Rin,Rout,AddSub,Ain,Gin,Gout,DINout,IRin,ADDRin,DOUTin,W_D,incr_pc,DOUT,ADDR,W);
output [15:0] DOUT,ADDR;
output W;
input [15:0] DIN;
input Resetn, Clock, Run;
output reg Done;
output [15:0] BusWires;
output reg [2:0]Tstep_Q;
output reg [2:0]Tstep_D;
output reg IRin;
output wire [8:0]IR;
parameter T0= 3'b000, T1=3'b001,T2=3'b010,T3=3'b011,T4=3'b100,T5=3'b101;
output wire [2:0]I;
output wire [7:0]Xreg,Yreg;
output wire [16:0] R2,R3,R4,R5,R6,R7,Out_AddSub;
output wire [16:0] R0,R1,A,G;

output reg [7:0] Rin,Rout;
output reg AddSub,Ain,Gin,Gout,DINout,ADDRin,DOUTin,W_D,incr_pc;
assign I=IR[8:6];
dec3to8 decX(IR[5:3],1'b1,Xreg);
dec3to8 decY(IR[2:0],1'b1,Yreg);
//Control FSM state table
always @(Tstep_Q or Run or Done)
	case(Tstep_Q)
	T0:
	
	Tstep_D=T1;
	T1:
	Tstep_D=T2;
	T2:
	if (!Run) Tstep_D=T0;
	else Tstep_D=T3;
	T3:
	if (Done) Tstep_D=T0;
	else Tstep_D=T4;
	T4:
	if (Done) Tstep_D=T0;
	else Tstep_D=T5;
	T5:
	if (Done) Tstep_D=T0;
	else Tstep_D=T0;
	default:
	Tstep_D=T0;
	endcase
//Control FSM outputs
always @(Tstep_Q or I or Xreg or Yreg)
begin
	Rin=8'b00000000;
	Rout=8'b00000000;
	Gin=0;
	AddSub=0;
	Ain=0;
	Gout=0;
	DINout=1;
	Done=0;
	IRin=0;
	ADDRin=0;
	DOUTin=0;
	W_D=0;
	incr_pc=0;
case (Tstep_Q)
	T0:
	begin
	DINout=0;
	Rout=8'b00000001;
   ADDRin=1;
	incr_pc=1;
	end
	T1:
	begin
	DINout=0;
	Rout=8'b00000001;
   ADDRin=1;
	end

	
   T2: 
	begin
	IRin = 1;
	end
	T3: //define signals in time step 1
	case (I)
	3'b110:
	begin
	if (G==0) Done=1;
	else 
	begin
	DINout=0;
	Rin=Xreg;
	Rout=Yreg;
	Done=1;
	end

	end
	3'b000:
	begin
	DINout=0;
	Rin=Xreg;
	Rout=Yreg;
	Done=1;
	end
	3'b001:
	begin
	Rin=Xreg;
	incr_pc=1;
	Done=1;
	
	end
	3'b010:
	begin
	DINout=0;
	Rout=Xreg;
	Ain=1;
	end
	3'b011:
	begin
	DINout=0;
	Rout=Xreg;
	Ain=1;
	end
	3'b100:
	begin
	Rout=Yreg;
	DINout=0;
	ADDRin=1;
	
	end
	3'b101:
	begin
	Rout=Yreg;
	ADDRin=1;
	DINout=0;
	end
	endcase
	T4: //define signals in time step 2
	case (I)
	
	3'b010:
	begin
	DINout=0;
	Rout=Yreg;
	Gin=1;
	end
	3'b011:
	begin
	DINout=0;
	Rout=Yreg;
	Gin=1;
	AddSub=1;
	end
	3'b100:
	begin
	end
	3'b101:
	begin
	DINout=0;
	Rout=Xreg;
	DOUTin=1;
	end
	endcase
	T5: //define signals in time step 3
	case (I)
	  
	3'b010:
	begin
	DINout=0;
	Gout=1;
	Rin=Xreg;
	Done=1;
	end
	3'b011:
	begin
	DINout=0;
	Gout=1;
	Rin=Xreg;
	Done=1;
	end
	3'b100:
	begin
	DINout=1;
	Rin=Xreg;
	Done=1;
	end
	3'b101:
	begin
	W_D=1;
	Done=1;
	end
	endcase
	
endcase
end

always @(posedge Clock or negedge Resetn)
if (!Resetn) Tstep_Q=T0;
else Tstep_Q=Tstep_D;

Multiplexers proc_multiplexers(Rout,Gout,DINout,DIN,R0,R1,R2,R3,R4,R5,R6,R7,G,BusWires);
regn #(.n(9)) IRegister(.Clock(Clock),.R(DIN[8:0]),.Rin(IRin),.Q(IR));
regn reg_0(BusWires,Rin[7],Clock,R0);
regn reg_1(BusWires,Rin[6],Clock,R1);
regn reg_2(BusWires,Rin[5],Clock,R2);
regn reg_3(BusWires,Rin[4],Clock,R3);
regn reg_4(BusWires,Rin[3],Clock,R4);
regn reg_5(BusWires,Rin[2],Clock,R5);
regn reg_6(BusWires,Rin[1],Clock,R6);
counter reg_7(BusWires,incr_pc,Rin[0],Clock,R7);
regn reg_ADDRESS(BusWires,ADDRin,Clock,ADDR);
regn Areg(BusWires,Ain,Clock,A);
regn Greg(Out_AddSub,Gin,Clock,G);
Add_Sub proc_AddSub(AddSub,A,BusWires,Out_AddSub);
regn #(.n(1)) WriteReg(.Clock(Clock),.R(W_D),.Rin(1),.Q(W));
regn reg_DOUT(BusWires,DOUTin,Clock,DOUT);

endmodule

module Add_Sub(AddSub,A,BusWires,Out_AddSub);
input AddSub;
input [15:0]A,BusWires;
output [15:0]Out_AddSub;
assign Out_AddSub=(AddSub==1)?(A-BusWires):(A+BusWires);
endmodule 