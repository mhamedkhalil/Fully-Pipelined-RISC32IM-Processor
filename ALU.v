//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 09/24/2024 02:10:52 PM
//// Design Name: 
//// Module Name: ALU
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

//module ALU #(parameter N = 32)(
//    input [N-1:0] A, B,
////    input [4:0] shamt,
//    input [3:0] sel,
//    input [2:0] Branching,
//    input mulDivBit,
//    output reg [N-1:0] out,
//    output reg branchFlag,
//    output zeroFlag, cFlag, vFlag, sFlag 
//);
//    wire [N-1:0] Bout; 
//    wire Cin; 
//    wire [N:0] adderResult;
//    wire [N-1:0] shifterResult;


//    // Multiplication and Division Results
//    wire signed [63:0] resultMul = $signed(A) * $signed(B);  // Signed multiplication
//    wire signed [31:0] resultDiv = $signed(A) / $signed(B);  // Signed division
//    wire signed [31:0] resultRem = $signed(A) % $signed(B);  // Signed remainder
//    wire [63:0] resultMulU = A * B;                          // Unsigned multiplication
//    wire [31:0] resultDivU = A / B;                          // Unsigned division
//    wire [31:0] resultRemU = A % B;                          // Unsigned remainder
    
//    assign resultMul = A*B;
//    assign resultDiv = A/B;
//    assign Bout = (sel[2] == 1) ? (~B) : B;
//    assign Cin = (sel[2] == 1) ? 1'b1 : 1'b0;
//    assign zeroFlag = (out == 0) ? 1 : 0 ;
//    assign cFlag = adderResult[N];
//    assign sFlag = adderResult[N-1];
//    assign vFlag = (A[N-1] ^ Bout[N-1] ^ adderResult[N-1] ^ cFlag); 
//    RCA #(N)adder(.A(A), .B(Bout), .Cin(Cin), .Output(adderResult));
//    shifter shift(.Input(A), .Amount(B), .type(sel[3:2]), .result(shifterResult));
    
//    always @(*) begin
//    if(~mulDivBit)
//    begin
//        case(sel)
//            4'b0010, 4'b0110: out = adderResult[N-1:0];              // ADD, SUB
//            4'b0000:          out = A & B;                    // AND
//            4'b0001:          out = A | B;                    // OR
//            4'b1110:          out = {31'b0, (sFlag != vFlag)}; // SLT
//            4'b0100:          out = {31'b0, (~cFlag)};         // SLTU
//            4'b0101:          out = A ^ B;                    // XOR
//            4'b0111:          out = shifterResult;            // SLL
//            4'b1000:          out = shifterResult;            // SRL
//            4'b1100:          out = shifterResult;            // SRA
//            4'b0011:          out = B;                        // LUI    
//            default:          out = 32'd0;                    // Default case
//        endcase
//        end
////      else
////      begin
////      case(sel)
////                4'b0010: out = resultMul[31:0];                  // MUL (low 32 bits of signed multiplication)
////                4'b0111: out = resultMul[63:32];                 // MULH (high 32 bits of signed multiplication)
////                4'b1110: out = resultMulU[63:32];                // MULHU (high 32 bits of unsigned multiplication)
////                4'b0100: out = $signed(resultMulU[63:32]);       // MULHSU (signed * unsigned, high 32 bits)

////                4'b1000: out = resultDivU;                       // DIVU (unsigned division)
////                4'b0101: out = resultDiv;                        // DIV (signed division)
////                4'b0000: out = resultRemU;                       // REMU (unsigned remainder)
////                4'b0001: out = resultRem;                        // REM (signed remainder)

////                default: out = 32'd0;                            // Default case
////      endcase
////    end
//    end 
    
//    always @ (*) begin
//        case(Branching)
//        3'b000: branchFlag = (zeroFlag) ? 1 : 0; //BEQ 
//        3'b001: branchFlag = (zeroFlag) ? 0 : 1; //BNE 
//        3'b100: branchFlag = (sFlag != vFlag) ? 1 : 0; //BLT 
//        3'b101: branchFlag = (sFlag != vFlag) ? 0 : 1; //BGE 
//        3'b110: branchFlag = (cFlag) ? 0 : 1; //BLTU 
//        3'b111: branchFlag = (cFlag) ? 1 : 0; //BGEU 
//        default: branchFlag = 0;
//        endcase 
//    end 

//endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2024 02:10:52 PM
// Design Name: 
// Module Name: ALU
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

module ALU #(parameter N = 32)(
    input [N-1:0] A, B,
//    input [4:0] shamt,
    input [3:0] sel,
    input [2:0] Branching,
    output reg [N-1:0] out,
    output reg branchFlag,
    output zeroFlag, cFlag, vFlag, sFlag 
);
    wire [N-1:0] Bout; 
    wire Cin; 
    wire [N:0] adderResult;
    wire [N-1:0] shifterResult;

    assign Bout = (sel[2] == 1) ? (~B) : B;
    assign Cin = (sel[2] == 1) ? 1'b1 : 1'b0;
    assign zeroFlag = (out == 0) ? 1 : 0 ;
    assign cFlag = adderResult[N];
    assign sFlag = adderResult[N-1];
    assign vFlag = (A[N-1] ^ Bout[N-1] ^ adderResult[N-1] ^ cFlag); 
    RCA #(N)adder(.A(A), .B(Bout), .Cin(Cin), .Output(adderResult));
    shifter shift(.Input(A), .Amount(B), .type(sel[3:2]), .result(shifterResult));
    
    always @(*) begin
        case(sel)
            4'b0010, 4'b0110: out = adderResult[N-1:0];              // ADD, SUB
            4'b0000:          out = A & B;                    // AND
            4'b0001:          out = A | B;                    // OR
            4'b1110:          out = {31'b0, (sFlag != vFlag)}; // SLT
            4'b0100:          out = {31'b0, (~cFlag)};         // SLTU
            4'b0101:          out = A ^ B;                    // XOR
            4'b0111:          out = shifterResult;            // SLL
            4'b1000:          out = shifterResult;            // SRL
            4'b1100:          out = shifterResult;            // SRA
            4'b0011:          out = B;                        // LUI    
            default:          out = 32'd0;                    // Default case
        endcase
    end
    
    always @ (*) begin
        case(Branching)
        3'b000: branchFlag = (zeroFlag) ? 1 : 0; //BEQ 
        3'b001: branchFlag = (zeroFlag) ? 0 : 1; //BNE 
        3'b100: branchFlag = (sFlag != vFlag) ? 1 : 0; //BLT 
        3'b101: branchFlag = (sFlag != vFlag) ? 0 : 1; //BGE 
        3'b110: branchFlag = (cFlag) ? 0 : 1; //BLTU 
        3'b111: branchFlag = (cFlag) ? 1 : 0; //BGEU 
        default: branchFlag = 0;
        endcase 
    end 

endmodule
