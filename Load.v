`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2024 02:26:33 AM
// Design Name: 
// Module Name: Load
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


module Load(
    input [2:0] funct3,
    input MemRead, MemWrite,
    input [31:0] unitInput,
    output reg [31:0] result
    );

always @ (*)
begin
if(MemRead)
begin
    case(funct3)
    3'b000: result = {{24{unitInput[7]}},unitInput[7:0]}; //LB (sign extension)
    3'b001: result = {{16{unitInput[15]}},unitInput[15:8]}; //LH
    3'b010: result = unitInput; //LW
    3'b100: result = {24'd0, unitInput[7:0]}; //LBU 
    3'b101: result = {16'd0, unitInput[15:8]}; //LHU 
    default: result = 32'd0;
    endcase  
end

if(MemWrite)
begin
    case(funct3)
    3'b000: result = {{24{unitInput[7]}},unitInput[7:0]}; //SB 
    3'b001: result = {{16{unitInput[15]}},unitInput[15:8]}; //SH
    3'b010: result = unitInput; //SW
    default: result = 32'd0;
    endcase
end

if(~MemRead && ~MemWrite)
    result = 32'd0; 
end

endmodule
