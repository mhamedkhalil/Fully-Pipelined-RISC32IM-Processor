`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 05:02:04 PM
// Design Name: 
// Module Name: CU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CU( input [6:0]Inst , 
output reg branch, MemRead, MemtoReg, MemWrite,AluSrc, RegWrite, Jump, JumpR, AUIPC, EXIT,
output reg[1:0] ALUOp
);

initial begin
EXIT = 0;
end

always @ (*) begin 
case (Inst)
7'b0110011 :  // R-Type
begin
branch=0; 
MemRead=0; 
MemtoReg=0;
ALUOp=2'b10;
MemWrite=0;
AluSrc=0;
RegWrite=1;
Jump=0;
JumpR=0;
AUIPC=0;

end

7'b0000011 :  // I-Type Loads 
begin
branch=0; 
MemRead=1; 
MemtoReg=1;
ALUOp=2'b00;
MemWrite=0;
AluSrc=1;
RegWrite=1;
Jump=0;
JumpR=0;
AUIPC=0;

end

7'b0100011 :  // S-Type
begin

branch=0; 
MemRead=0; 
MemtoReg=1'b0;
ALUOp=2'b00;
MemWrite=1;
AluSrc=1;
RegWrite=0;
Jump=0;
JumpR=0;
AUIPC=0;

end

7'b1100011 :  // B-Type 
begin

branch=1; 
MemRead=0; 
MemtoReg=1'bX;
ALUOp=2'b01;
MemWrite=0;
AluSrc=0;
RegWrite=0;
Jump=0;
JumpR=0;
AUIPC=0;

end

7'b0010011 :  // I-Type 
begin

branch=0; 
MemRead=0; 
MemtoReg=1'b0;
ALUOp=2'b10;
MemWrite=0;
AluSrc=1;
RegWrite=1;
Jump=0;
JumpR=0;
AUIPC=0;

end

7'b0110111 : // LUI 
begin 

branch=0;
MemRead=0;
MemtoReg=1'b0;
ALUOp=2'b11;
MemWrite=0;
AluSrc=1;
RegWrite=1;
Jump=0;
JumpR=0;
AUIPC=0;

end

7'b1101111: //JAL  
begin

branch=0;
MemRead=0;
MemtoReg=1'b0;
ALUOp=2'b00;
MemWrite=0;
AluSrc=0;
RegWrite=1;
Jump=1;
JumpR=0;
AUIPC=0;

end 

7'b1100111: //JALR 
begin

branch=0;
MemRead=0;
MemtoReg=1'b0;
ALUOp=2'b00;
MemWrite=0;
AluSrc=1;
RegWrite=1;
Jump=1;
JumpR=1;
AUIPC=0;

end

7'b0010111: //AUIPC 
begin

branch=0;
MemRead=0;
MemtoReg=1'b0;
ALUOp=2'b00;
MemWrite=0;
AluSrc=1;
RegWrite=1;
Jump=0;
JumpR=0;
AUIPC=1;

end 

7'b1110011: // ECALL 
begin

branch=0;
MemRead=0;
MemtoReg=1'b0;
ALUOp=2'b00;
MemWrite=0;
AluSrc=0;
RegWrite=0;
Jump=0;
JumpR=0;
AUIPC=0;
EXIT=1; 
end 

default:
begin

branch=0; 
MemRead=0; 
MemtoReg=1'b0;
ALUOp=2'b00;
MemWrite=0;
AluSrc=0;
RegWrite=0;
Jump=0;
JumpR=0;
AUIPC=0;
end

endcase
end
endmodule
