`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2024 05:29:01 PM
// Design Name: 
// Module Name: Memory
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


module Memory(input clk, MemRead, MemWrite,[31:0] data_in, [10:0] address, output reg[31:0] data_out, input [2:0]func3);

 reg [7:0] mem [0:511];
 reg [31:0] temp [0:255];
 reg [10:0]offset; initial begin 
assign offset = 256;
end

    always @(*) begin
        if (MemRead == 1) begin
            case(func3)
                3'b000: data_out = {{24{mem[address][7]}}, mem[address]};// LB 
                3'b001: data_out = {{16{mem[address][15]}}, mem[address+1], mem[address]};// LH 
                3'b010: data_out = {mem[address+3],mem[address+2],mem[address+1], mem[address]};//LW 
                3'b100: data_out = {24'd0, mem[address]};// LBU 
                3'b101: data_out = {16'd0,mem[address],mem[address+1], mem[address]};//LHU 
                default: data_out = 32'd0;
            endcase
        end 
        end
    always @(posedge clk) begin
        if (MemWrite == 1) begin
            case(func3)
                3'b000: mem[address] = data_in[7:0];//SB
                3'b001: {mem[address+1], mem[address]} = data_in[15:0] ;//SH
                3'b010: { mem[address+3],mem[address+2],mem[address+1], mem[address]} = data_in;//SW     
            endcase
        end
    end
initial begin
    {mem[3],mem[2],mem[1],mem[0]} = 32'd17;
   {mem[7],mem[6],mem[5],mem[4]}  = 32'd9;
  {mem[11],mem[10],mem[9],mem[8]}  = 32'd25;
//    $readmemh("C:/Users/mhamed_khalil/ProjectArch/ProjectArch.srcs/sources_1/new/testCases.hex",temp);
//{mem[offset +3], mem[offset +2], mem[offset +1], mem[offset +0]} = 32'b00000000000000000000000000110011; //add x0, x0, x0
// added to be skipped since PC starts with 4 after reset
//{mem[offset +7], mem[offset +6], mem[offset +5], mem[offset +4]} = 32'b00000000010000000000001010010011; //addi x5, x0, 4 
//{mem[offset +11], mem[offset +10], mem[offset +9], mem[offset +8]} = 32'b00000000000000000101000010110111; //lui x1, 5 
//{mem[offset +15], mem[offset +14], mem[offset +13], mem[offset +12]} = 32'b00000000000000000011000100010111; //auipc x2, 3 
//{mem[offset +19], mem[offset +18], mem[offset +17], mem[offset +16]} = 32'b11111111000111111111000111101111; //jal x3, -16 
//{mem[offset +23], mem[offset +22], mem[offset +21], mem[offset +20]} = 32'b00000000100100000000001010010011; // addi x5, x0, 9
//{mem[offset +27], mem[offset +26], mem[offset +25], mem[offset +24]} = 32'b00000000000100010001010000110011; //sll x8, x2, x1 
//{mem[offset +31], mem[offset +30], mem[offset +29], mem[offset +28]} = 32'b00000000000100010101010010110011; //srl x9, x2, x1 
//{mem[offset +35], mem[offset +34], mem[offset +33], mem[offset +32]} = 32'b01000000000100010101010100110011; //sra x10, x2, x1 
//{mem[offset +39], mem[offset +38], mem[offset +37], mem[offset +36]} = 32'b00000000001000001010010110110011; //slt x11, x1, x2 
//{mem[offset +43], mem[offset +42], mem[offset +41], mem[offset +40]} = 32'b00000000001000001011011000110011; //sltu x12, x1, x2 

//{mem[offset +47],mem[offset + 46],mem[offset + 45],mem[offset + 44]}=32'b0100000_00010_00001_000_01000_0110011 ; //sub x8, x1, x2
//{mem[offset +51],mem[offset + 50],mem[offset + 49],mem[offset + 48]}=32'b00001010110110011100010100010111 ; //auipc x10, 44444
//{mem[offset +55],mem[offset + 54],mem[offset + 53],mem[offset + 52]}=32'b0000000_00001_00000_000_01001_0110011 ; //add x9, x0, x1
//{mem[offset +59],mem[offset + 58],mem[offset + 57],mem[offset + 56]}=32'b00000000000000000000000001110011; // ecall
end
integer i;
    initial begin
        for (i = 0; i < 32; i = i+1)
            {mem[(i*4) + 259], mem[(i*4) + 258], mem[(i*4) + 257], mem[i*4 + 256]} = temp[i];
    end
endmodule
