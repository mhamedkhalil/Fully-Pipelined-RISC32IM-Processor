`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 02:19:09 PM
// Design Name: 
// Module Name: SingleCycle
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


module SingleCycle(
input clk, rst,
input [1:0] ledSel,
input [3:0] ssdSel,
input ssdClk,
output reg [15:0] leds,

output [3:0]  Anode,
output [6:0] LED_out
    );
wire [31:0] PCinput, PCoutput;
wire [31:0] Inst, Wdata, Read1, Read2, Immediate, ALUsrcOut, ALUresult, DMout, immShifted, adder1Out, adder2Out, loadStore, WdataMUXed, finalWdata, Jumpaddress;
wire RegWrite, ALUsrc, Branch, MemRead, MemtoReg, MemWrite, branchFlag, Jump, JumpR, AUIPC, EXIT;
wire [1:0] ALUOp;
wire zeroFlag, PCsrc;
wire [3:0] ALUSel;
wire [31:0] loaded;
wire [2:0] Branchingf3;
reg [12:0] ssd;

wire [31:0] IF_ID_PC, IF_ID_PCinc4, IF_ID_Inst;
NBitRegister #(96) IF_ID (.clk(~clk),.reset(rst || ((EX_MEM_Ctrl[7] & EX_MEM_BranchF) || EX_MEM_Ctrl[2]) || EXIT),.load(~stall),.D({PCoutput,adder2Out,memOut}),.Q({IF_ID_PC,IF_ID_PCinc4,IF_ID_Inst}));

wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_PCinc4;
wire [11:0] ID_EX_Ctrl;
wire [3:0] ID_EX_Func;
wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
NBitRegister #(191) ID_EX (.clk(clk),.reset(rst),.load(1'b1),.D({finalHazardCtrlOut,IF_ID_PC,Read1,Read2,Immediate,{IF_ID_Inst[30],IF_ID_Inst[14:12]},IF_ID_Inst[19:15],IF_ID_Inst[24:20],IF_ID_Inst[11:7],IF_ID_PCinc4}),.Q({ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,
ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd,ID_EX_PCinc4}));

wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_PCinc4, EX_MEM_AUIPC_data;
wire [7:0] EX_MEM_Ctrl;
wire [4:0] EX_MEM_Rd;
wire [2:0] EX_MEM_Funct3;
wire EX_MEM_BranchF, stall;
NBitRegister #(177) EX_MEM (.clk(~clk),.reset(rst),.load(1'b1),.D({flushingCtrlOut,Jumpaddress,branchFlag,ALUresult,ALUsrc2frwrd,ID_EX_Rd,ID_EX_PCinc4,adder1Out,ID_EX_Func[2:0]}),.Q({EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_BranchF,
EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd,EX_MEM_PCinc4,EX_MEM_AUIPC_data,EX_MEM_Funct3}));

wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, ALUsrc1frwrd, ALUsrc2frwrd, MEM_WB_PCinc4, MEM_WB_AUIPC_data;
wire [1:0] forwardA, forwardB;
wire [3:0] MEM_WB_Ctrl;
wire [4:0] MEM_WB_Rd;
wire [11:0] hazardCtrlOut;
wire [7:0] flushingCtrlOut;
NBitRegister #(137) MEM_WB (.clk(clk),.reset(rst),.load(1'b1),.D({EX_MEM_Ctrl[5],EX_MEM_Ctrl[3],EX_MEM_Ctrl[2],EX_MEM_Ctrl[0],memOut,EX_MEM_ALU_out,EX_MEM_Rd,EX_MEM_PCinc4,EX_MEM_AUIPC_data}),.Q({MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out,
MEM_WB_Rd,MEM_WB_PCinc4,MEM_WB_AUIPC_data}));
wire [11:0] finalHazardCtrlOut;
Hazard_Detection hazard_detect(.IF_ID_Rs1(IF_ID_Inst[19:15]),.IF_ID_Rs2(IF_ID_Inst[24:20]),.ID_EX_Rd(ID_EX_Rd), .ID_EX_MemRead(ID_EX_Ctrl[9]), .stall(stall));
NMUX2x1 #(12) hazardMUX(.I0({Branch,MemRead,MemtoReg,MemWrite,ALUsrc,RegWrite,ALUOp,Jump,JumpR,AUIPC,EXIT}),.I1(12'd0),.Sel(stall || ((EX_MEM_Ctrl[7] & EX_MEM_BranchF) || EX_MEM_Ctrl[2])),.out(hazardCtrlOut));
NMUX2x1 #(12) exitMUX(.I0(hazardCtrlOut), .I1({11'd0,1'b1}), .Sel(EXIT), .out(finalHazardCtrlOut));
NMUX2x1 #(8) flushingMUXExec(.I0({ID_EX_Ctrl[11:8],ID_EX_Ctrl[6],ID_EX_Ctrl[3:1]}),.I1(8'd0),.Sel(((EX_MEM_Ctrl[7] & EX_MEM_BranchF) || EX_MEM_Ctrl[2])),.out(flushingCtrlOut));
Forwarding_Unit forward(.ID_EX_Rs1(ID_EX_Rs1), .ID_EX_Rs2(ID_EX_Rs2), .EX_MEM_Rd(EX_MEM_Rd), .MEM_WB_Rd(MEM_WB_Rd),
    .EX_MEM_RegWrite(EX_MEM_Ctrl[3]), .MEM_WB_RegWrite(MEM_WB_Ctrl[2]),
    .forwardA(forwardA), .forwardB(forwardB));
MUX4x1 muxForwardA(.I0(ID_EX_RegR1),.I1(finalWdata),.I2(EX_MEM_ALU_out),.I3(32'd0),.sel(forwardA),.out(ALUsrc1frwrd));
MUX4x1 muxForwardB(.I0(ID_EX_RegR2),.I1(finalWdata),.I2(EX_MEM_ALU_out),.I3(32'd0),.sel(forwardB),.out(ALUsrc2frwrd));
NBitRegister #(32) PC(.clk(clk), .load(~EXIT && ~stall), .reset(rst), .D(PCinput), .Q(PCoutput));

//InstMem  IM(.addr(PCoutput), .data_out(Inst));
//DataMem DM(.clk(clk), .MemRead(EX_MEM_Ctrl[6]), .MemWrite(EX_MEM_Ctrl[4]), .addr(EX_MEM_ALU_out), .data_in(loaded), .data_out(DMout));wire [7:0] muxAddressout;
wire [31:0]muxAddressout;
wire muxWriteout;
wire muxReadout;
wire [31:0] memOut;
wire [2:0] muxfun3out;
NMUX2x1 #(32)muxAddress (.I0(EX_MEM_ALU_out), .I1(PCoutput[7:0]+256), .Sel(clk), .out(muxAddressout));
NMUX2x1 #(1)muxWrite (.I0(EX_MEM_Ctrl[4]), .I1(1'b0), .Sel(clk), .out(muxWriteout));
NMUX2x1 #(1)muxRead (.I0(EX_MEM_Ctrl[6]), .I1(1'b1), .Sel(clk), .out(muxReadout));
NMUX2x1 #(3)muxfun3 (.I0(EX_MEM_Funct3), .I1(3'b010), .Sel(clk), .out(muxfun3out)); // Why??

Memory mem (.clk(~clk), .MemRead(muxReadout), .MemWrite(muxWriteout),.data_in(EX_MEM_RegR2), .address(muxAddressout), .data_out(memOut), .func3(muxfun3out));

CU control(.Inst(IF_ID_Inst[6:0]), .branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .AluSrc(ALUsrc), .RegWrite(RegWrite), .ALUOp(ALUOp), .Jump(Jump), .JumpR(JumpR), .AUIPC(AUIPC), .EXIT(EXIT));
ALU_CU aluControl(.ALUOp(ID_EX_Ctrl[5:4]), .Inst1(ID_EX_Func[2:0]), .Inst2(ID_EX_Func[3]), .ALUSel(ALUSel), .Branching(Branchingf3));
RF regFile(.R1(IF_ID_Inst[19:15]), .R2(IF_ID_Inst[24:20]), .Write(MEM_WB_Rd), .clk(~clk), .reset(rst), 
.RegWrite(MEM_WB_Ctrl[2]), .Wdata(finalWdata),.R1_out(Read1), .R2_out(Read2));
ImmGen imm(.Imm(Immediate), .IR(IF_ID_Inst));
NMUX2x1 #(32) mux1(.I0(ALUsrc2frwrd), .I1(ID_EX_Imm), .Sel(ID_EX_Ctrl[7]), .out(ALUsrcOut));
ALU #(32) alu(.A(ALUsrc1frwrd), .B(ALUsrcOut), .sel(ALUSel), .Branching(Branchingf3), .branchFlag(branchFlag) ,.out(ALUresult), .zeroFlag(zeroFlag));
NMUX2x1 #(32) loadStoreMUX(.I0(EX_MEM_RegR2),.I1(memOut),.Sel(EX_MEM_Ctrl[6]),.out(loadStore));
//Load loadUnit(.funct3(EX_MEM_Funct3),.MemRead(EX_MEM_Ctrl[6]),.MemWrite(EX_MEM_Ctrl[4]),.unitInput(loadStore),.result(loaded));
NMUX2x1 #(32) mux2(.I0(MEM_WB_ALU_out), .I1(MEM_WB_Mem_out), .Sel(MEM_WB_Ctrl[3]), .out(Wdata));
NMUX2x1 #(32) JumpRMUX(.I0(adder1Out), .I1(ALUresult), .Sel(ID_EX_Ctrl[2]), .out(Jumpaddress));
//NBitShiftLeft #(32) shift(.in(Immediate),.out(immShifted));
RCA #(32) adder1(.A(ID_EX_PC), .B(ID_EX_Imm), .Output(adder1Out),.Cin(1'b0));
RCA #(32) adder2(.A(PCoutput), .B(32'd4), .Output(adder2Out),.Cin(1'b0));
NMUX2x1 #(32) mux3(.I0(adder2Out), .I1(EX_MEM_BranchAddOut), .Sel((EX_MEM_Ctrl[7] & EX_MEM_BranchF) || EX_MEM_Ctrl[2]), .out(PCinput));
NMUX2x1 #(32) JumpMUX(.I0(Wdata), .I1(MEM_WB_PCinc4), .Sel(MEM_WB_Ctrl[1]), .out(WdataMUXed));
NMUX2x1 #(32) AUIPCMUX(.I0(WdataMUXed), .I1(MEM_WB_AUIPC_data), .Sel(MEM_WB_Ctrl[0]), .out(finalWdata));
Four_Digit_Seven_Segment_Driver SevenSegments(.clk(ssdClk), .num(ssd), .Anode(Anode), .LED_out(LED_out));//Four_Digit_Seven_Segment_Driver SevenSegments(.clk(ssdClk), .num(ssd), .Anode(Anode), .LED_out(LED_out));

always @(*)begin
case(ledSel)
2'b00: leds=memOut[15:0];
2'b01: leds=memOut[31:16];
2'b10: leds={2'b00, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUsrc, RegWrite, ALUSel , zeroFlag, {Branch & zeroFlag}};
default: leds=16'd0;
endcase
end 

always @(*)
begin
case(ssdSel)
4'b0000: ssd = PCoutput[12:0];
4'b0001: ssd = adder2Out[12:0];
4'b0010: ssd = adder1Out[12:0];
4'b0011: ssd = PCinput[12:0];
4'b0100: ssd = Read1[12:0];
4'b0101: ssd = Read2[12:0];
4'b0110: ssd = Wdata[12:0];
4'b0111: ssd = Immediate[12:0];
4'b1000: ssd = immShifted[12:0];
4'b1001: ssd = ALUsrcOut[12:0];
4'b1010: ssd = ALUresult[12:0];
4'b1011: ssd = DMout[12:0];
endcase
end 
endmodule
