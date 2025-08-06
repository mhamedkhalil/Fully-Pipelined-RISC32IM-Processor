`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2024 03:25:54 PM
// Design Name: 
// Module Name: MUX4x1
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


module MUX4x1(
    input [31:0] I0, I1, I2, I3,
    input [1:0] sel,
    output reg [31:0] out
    );
    
    always @(*)
    begin
    case(sel)
    2'b00: out <= I0;
    2'b01: out <= I1;
    2'b10: out <= I2;
    2'b11: out <= I3;
    default: out <= 32'd0;
    endcase
    
    end
endmodule
