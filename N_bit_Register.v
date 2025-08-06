`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2024 02:16:12 PM
// Design Name: 
// Module Name: N_bit_Register
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


module NBitRegister #(parameter N = 8)(    
    input clk, load, reset,
    input [N-1:0] D,
    output [N-1:0] Q
    );
     
    wire [N-1:0] MUX_out;
    genvar i;
    generate
    for (i=0; i<N; i=i+1)
    begin
    MUX2x1 MUX(.I0(Q[i]),.I1(D[i]),.Sel(load),.out(MUX_out[i]));
    DFlipFlop FF(.clk(clk),.rst(reset),.D(MUX_out[i]),.Q(Q[i]));
    end
    endgenerate
endmodule
