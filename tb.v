`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2024 04:02:43 PM
// Design Name: 
// Module Name: forwarding_tb
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


module tb();
reg clk, rst;
reg [1:0] ledSel;
reg [3:0] ssdSel;
reg ssdClk;
wire [15:0] leds;

SingleCycle cpu(.clk(clk),.rst(rst),.ledSel(2'd0),.ssdSel(4'd0),.ssdClk(1'b0),.leds(leds));
localparam period = 10;

initial begin
clk = 0;
forever #(period/2)
clk = ~clk;
end

initial begin
rst = 1;
#period
rst = 0;
#(period*50)
$finish;
end
endmodule
