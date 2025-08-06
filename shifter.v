`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2024 09:09:20 PM
// Design Name: 
// Module Name: shifter
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


module shifter(
    input [31:0] Input, 
    input [4:0] Amount,
    input [1:0] type,
    output reg [31:0] result
    );
    always @ (*)
    begin
    case(type)
    2'b01: result = Input << Amount;
    2'b10: result = Input >> Amount;
    2'b11: result = Input >>> Amount;
    default: result = Input;
    endcase
    end 
    
endmodule
