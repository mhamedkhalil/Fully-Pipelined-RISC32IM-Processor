`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2024 02:09:53 PM
// Design Name: 
// Module Name: RCA
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


module RCA #(parameter N = 8)(
    input [N-1:0] A, B,
    output [N:0] Output,
    input Cin
    );
   wire [N:0]Carry;
   assign Carry[0]=Cin;
   genvar i;
   generate
   for(i=0; i<N; i=i+1)
   begin
   FullAdder Adder(.A(A[i]),.B(B[i]),.Cin(Carry[i]),.Cout(Carry[i+1]),.Sum(Output[i]));
   end
   endgenerate
   assign Output[N]=Carry[N];
   
    
endmodule
