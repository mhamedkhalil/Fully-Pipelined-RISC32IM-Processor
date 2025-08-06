`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 02:47:22 PM
// Design Name: 
// Module Name: DM
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


module DataMem
(input clk, input MemRead, input MemWrite,
input [31:0] addr, input [31:0] data_in, output [31:0] data_out);
reg [31:0] mem [0:64];
assign data_out = MemRead == 1 ? mem[addr/4] : 32'b0;
//assign data_out = MemRead == 1 ? {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]} : 32'd0;
always @(posedge clk)
begin
if(MemWrite == 1)
begin
    mem[addr] = data_in;
end 
end 
//initialize data in memory
initial begin
    mem[0] = 32'd17;
    mem[1] = 32'd9;
    mem[2] = 32'd25;
    mem[3] = 32'd20;
    mem[4] = 32'd12;
    mem[5] = 32'd30;
    mem[6] = 32'd8;
    mem[7] = 32'd27;
    mem[8] = 32'd15;
    mem[9] = 32'd5;
    mem[10] = 32'd23;
    mem[11] = 32'd18;
    mem[12] = 32'd14;
    mem[13] = 32'd32;
    mem[14] = 32'd10;
    mem[15] = 32'd29;
    mem[16] = 32'd7;
    mem[17] = 32'd19;
    mem[18] = 32'd4;
    mem[19] = 32'd16;
    mem[20] = 32'd21;
    mem[21] = 32'd13;
    mem[22] = 32'd11;
    mem[23] = 32'd6;
    mem[24] = 32'd22;
    mem[25] = 32'd3;
    mem[26] = 32'd28;
    mem[27] = 32'd2;
    mem[28] = 32'd24;
    mem[29] = 32'd1;
    mem[30] = 32'd31;
    mem[31] = 32'd35;
end 
endmodule

