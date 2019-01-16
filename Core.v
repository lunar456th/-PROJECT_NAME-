`ifndef __CORE_V__
`define __CORE_V__

`include "ALU.v"
`include "ALUControl.v"
`include "Andm.v"
`include "Control.v"
`include "DataMemory.v"
`include "Datapath.v"
`include "InstructionMemory.v"
`include "Mux.v"
`include "PC.v"
`include "RegisterFile.v"
`include "SignExtend.v"

module Core ( // main cpu module
	input wire clk,
	input wire reset,

	output wire [31:0] mem_addr,
	output wire mem_read_en,
	output wire mem_write_en,
	input wire [31:0] mem_read_val,
	output wire [31:0] mem_write_val,
	input wire mem_response
	);

	wire [5:0] OpCode;
	wire [1:0] ALUOp;
	wire RegDst;
	wire ALUSrc;
	wire MemtoReg;
	wire RegWrite;
	wire MemRead;
	wire MemWrite;
	wire Branch;

	Datapath _Datapath (
		.clk(clk),
		.reset(reset),
		.RegDst(RegDst),
		.ALUSrc(ALUSrc),
		.MemtoReg(MemtoReg),
		.RegWrite(RegWrite),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.Branch(Branch),
		.ALUOp(ALUOp),
		.OpCode(OpCode),

		.mem_addr(mem_addr),
		.mem_read_en(mem_read_en),
		.mem_write_en(mem_write_en),
		.mem_read_val(mem_read_val),
		.mem_write_val(mem_write_val),
		.mem_response(mem_response)
	);

	Control _Control (
		.opcode(OpCode),
		.RegDst(RegDst),
		.ALUSrc(ALUSrc),
		.MemtoReg(MemtoReg),
		.RegWrite(RegWrite),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.Branch(Branch),
		.AluOP(ALUOp)
	);

endmodule

`endif /*__CORE_V__*/
