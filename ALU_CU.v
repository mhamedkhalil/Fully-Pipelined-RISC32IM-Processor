//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 09/29/2024 04:25:17 PM
//// Design Name: 
//// Module Name: ALU_CU
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////

//module ALU_CU(
//    input [1:0] ALUOp,
//    input [2:0] Inst1,
//    input mulDivBit,
//    input Inst2,
//    output reg [3:0] ALUSel,
//    output reg [2:0] Branching
//);

//    always @(*) begin
//        case(ALUOp)
//            2'b00: ALUSel = 4'b0010;
//            2'b01: begin //B-type 
//            ALUSel = 4'b0110;
//            Branching = Inst1; 
//            end
//            2'b10: begin //R-type / I-Type no Load 
//                case(Inst1)
//                    3'b000: begin
//                    if(mulDivBit)
//                        ALUSel = 4'b0010; // MUL
//                    else
//                        ALUSel = Inst2 ? 4'b0110 : 4'b0010;  // Addition or Subtraction
//                     end
//                    3'b111: ALUSel = 4'b0000;                    // AND / REMU
//                    3'b100: ALUSel = 4'b0101;                    // XOR / DIV
//                    3'b001: ALUSel = 4'b0111;                    // SLL / MULH
//                    3'b101: begin
//                    if(mulDivBit)
//                        ALUSel = 4'b1000;                       // DIVU
//                    else 
//                        ALUSel = Inst2 ? 4'b1100 : 4'b1000;  // SRA or SRL 
//                    end
//                    3'b110: ALUSel = 4'b0001;                    //  OR / REM
//                    3'b010: ALUSel = 4'b1110;                    // SLT / MULHSU
//                    4'b011: ALUSel = 4'b0100;                    // SLTU / MULHU
//                    default: ALUSel = 3'b1111; 
//                endcase
//            end
//            2'b11: ALUSel = 4'b0011; //LUI
//            default: ALUSel = 4'b1111; // Catch-all in case of an unexpected ALUOp value
//        endcase
//    end

//endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2024 04:25:17 PM
// Design Name: 
// Module Name: ALU_CU
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

module ALU_CU(
    input [1:0] ALUOp,
    input [2:0] Inst1,
    input Inst2,
    output reg [3:0] ALUSel,
    output reg [2:0] Branching
);

    always @(*) begin
        case(ALUOp)
            2'b00: ALUSel = 4'b0010;
            2'b01: begin //B-type 
            ALUSel = 4'b0110;
            Branching = Inst1; 
            end
            2'b10: begin //R-type / I-Type no Load 
                case(Inst1)
                    3'b000: ALUSel = Inst2 ? 4'b0110 : 4'b0010;  // Addition or Subtraction
                    3'b111: ALUSel = 4'b0000;                    // AND
                    3'b100: ALUSel = 4'b0101;                    // XOR
                    3'b001: ALUSel = 4'b0111;                    // SLL
                    3'b101: ALUSel = Inst2 ? 4'b1100 : 4'b1000;  // SRA or SRL
                    3'b110: ALUSel = 4'b0001;                    //  OR
                    3'b010: ALUSel = 4'b1110;                    // SLT 
                    4'b011: ALUSel = 4'b0100;                    // SLTU
                    default: ALUSel = 3'b1111; 
                endcase
            end
            2'b11: ALUSel = 4'b0011; //LUI
            default: ALUSel = 4'b1111; // Catch-all in case of an unexpected ALUOp value
        endcase
    end

endmodule
