`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2024 03:35:41 PM
// Design Name: 
// Module Name: NMUX2x1
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


module NMUX2x1 #(parameter N = 8)(
    input [N-1:0] I0, I1, 
    input Sel,
    output [N-1:0] out
    );
   genvar i;
   
   generate
   for(i=0; i<N; i=i+1)
   begin
   MUX2x1 MUX(.I0(I0[i]),.I1(I1[i]),.Sel(Sel),.out(out[i]));
   end
   endgenerate 
   
endmodule
