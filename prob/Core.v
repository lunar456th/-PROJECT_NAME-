`ifndef __CORE_V__
`define __CORE_V__

`include "Datapath.v"
`include "Control.v"

module Core # (
	parameter MEM_WIDTH = 32,
	parameter MEM_SIZE = 256,
	parameter PC_START_ADDRESS = 212,
	parameter PC_END_ADDRESS = 255
	)	(
	input wire clk,
	input wire reset,
	output wire [$clog2(MEM_SIZE)-1:0] mem_addr,
	output wire mem_read_en,
	output wire mem_write_en,
	input wire [MEM_WIDTH-1:0] mem_read_val,
	output wire [MEM_WIDTH-1:0] mem_write_val
`ifdef TEST_PROB
	,
	// core
	output wire MemRead_prob,
	output wire stall_prob,
	// datapath
	output wire [31:0] Instruction_prob,
	output wire [31:0] ALUout_prob,
	output wire [31:0] PC_addr_prob,
	output wire [$clog2(MEM_SIZE)-1:0] mem_addr_instr_prob,
	output wire mem_read_en_instr_prob,
	output wire [MEM_WIDTH-1:0] mem_read_val_instr_prob,
	output wire [$clog2(MEM_SIZE)-1:0] mem_addr_data_prob,
	output wire mem_read_en_data_prob,
	output wire [MEM_WIDTH-1:0] mem_read_val_data_prob,
	// memoryselector
	output wire token_prob
`endif
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
	wire stall;

	Datapath # (
		.MEM_WIDTH(MEM_WIDTH),
		.MEM_SIZE(MEM_SIZE),
		.PC_START_ADDRESS(PC_START_ADDRESS),
		.PC_END_ADDRESS(PC_END_ADDRESS)
	) _Datapath (
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
		.stall(stall)
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
		.AluOP(ALUOp),
		.stall(stall)
	);

`ifdef TEST_PROB
	assign MemRead_prob = MemRead;
	assign stall_prob = stall;
`endif

endmodule

`endif /*__CORE_V__*/
