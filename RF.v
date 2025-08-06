`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 03:29:50 PM
// Design Name: 
// Module Name: RF
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


module RF #(parameter N=32)(
input [4:0] R1, R2, Write,
input clk, reset, RegWrite,
input [N-1:0]Wdata,
output [N-1:0]R1_out,R2_out);

reg [N-1:0] register [31:0];
integer i;

always @ (posedge clk , posedge reset)
begin
 if (reset==1) begin
 for (i=0 ; i<N ; i=i+1)
begin
register[i]=0;
end
end
else if (RegWrite==1 && Write != 0) 
begin
register[Write] = Wdata;
end 
end
assign R1_out=register[R1];
 assign R2_out=register[R2];
endmodule
