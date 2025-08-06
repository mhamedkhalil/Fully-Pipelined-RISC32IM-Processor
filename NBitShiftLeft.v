`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2024 04:09:11 PM
// Design Name: 
// Module Name: NBitShiftLeft
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


module NBitShiftLeft #(parameter N = 8)(
    input [N-1:0] in,
    output [N-1:0] out
    );
    
    assign out = {in[N-2:0],1'b0};
    
endmodule
