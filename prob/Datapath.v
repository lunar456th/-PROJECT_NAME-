`ifndef __DATAPATH_V__
`define __DATAPATH_V__

`include "ALU.v"
`include "ALUControl.v"
`include "Andm.v"
`include "DataMemory.v"
`include "InstructionMemory.v"
`include "MemorySelector.v"
`include "Mux.v"
`include "PC.v"
`include "RegisterFile.v"
`include "SignExtend.v"

module Datapath # (
	parameter MEM_WIDTH = 32,
	parameter MEM_SIZE = 256,
	parameter PC_START_ADDRESS = 212,
	parameter PC_END_ADDRESS = 255
	)	(
	input wire clk,
	input wire reset,
	input wire RegDst,
	input wire ALUSrc,
	input wire MemtoReg,
	input wire RegWrite,
	input wire MemRead,
	input wire MemWrite,
	input wire Branch,
	input wire [1:0] ALUOp,
	output wire [5:0] OpCode,

	output wire [$clog2(MEM_SIZE)-1:0] mem_addr,
	output wire mem_read_en,
	output wire mem_write_en,
	input wire [MEM_WIDTH-1:0] mem_read_val,
	output wire [MEM_WIDTH-1:0] mem_write_val,

	input wire stall
`ifdef TEST_PROB
	,
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

	wire [31:0] Instruction;
	wire [3:0] ALUCtrl;
	wire [31:0] ALUout;
	wire Zero;
	wire [31:0] PC_addr;
	wire [31:0] ReadRegister1;
	wire [31:0] ReadRegister2;
	wire [4:0] muxinstr_out;
	wire [31:0] muxalu_out;
	wire [31:0] muxdata_out;
	wire [31:0] ReadData;
	wire [31:0] signExtend;
	wire PCsel;
	assign OpCode = Instruction[31:26];
	wire [$clog2(MEM_SIZE)-1:0] mem_addr_instr;
	wire mem_read_en_instr;
	wire [MEM_WIDTH-1:0] mem_read_val_instr;
	wire [$clog2(MEM_SIZE)-1:0] mem_addr_data;
	wire mem_read_en_data;
	wire mem_write_en_data;
	wire [MEM_WIDTH-1:0] mem_read_val_data;
	wire [MEM_WIDTH-1:0] mem_write_val_data;

	InstructionMemory # ( // Instruction memory
		.MEM_WIDTH(MEM_WIDTH),
		.MEM_SIZE(MEM_SIZE)
	) _InstructionMemory (
		.addr(PC_addr[7:0]),
		.data_read(Instruction),
		.mem_addr(mem_addr_instr),
		.mem_read_en(mem_read_en_instr),
		.mem_read_val(mem_read_val_instr)
	);

	DataMemory # ( // Data memory
		.MEM_WIDTH(MEM_WIDTH),
		.MEM_SIZE(MEM_SIZE)
	) _DataMemory (
		.addr(ALUout[7:0]),
		.data_read(ReadData),
		.data_write(ReadRegister2),
		.read_en(MemRead),
		.write_en(MemWrite),
		.mem_addr(mem_addr_data),
		.mem_read_en(mem_read_en_data),
		.mem_write_en(mem_write_en_data),
		.mem_read_val(mem_read_val_data),
		.mem_write_val(mem_write_val_data)
	);

	RegisterFile _RegisterFile ( // Registers
		.RegWrite(RegWrite),
		.ra(Instruction[25:21]),
		.rb(Instruction[20:16]),
		.rc(muxinstr_out),
		.da(ReadRegister1),
		.db(ReadRegister2),
		.dc(muxdata_out)
	);

	MemorySelector _MemorySelector (
		.clk(clk),
		.mem_addr_instr(mem_addr_instr),
		.mem_read_en_instr(mem_read_en_instr),
		.mem_read_val_instr(mem_read_val_instr),
		.mem_addr_data(mem_addr_data),
		.mem_read_en_data(mem_read_en_data),
		.mem_write_en_data(mem_write_en_data),
		.mem_read_val_data(mem_read_val_data),
		.mem_write_val_data(mem_write_val_data),
		.mem_addr(mem_addr),
		.mem_read_en(mem_read_en),
		.mem_write_en(mem_write_en),
		.mem_read_val(mem_read_val),
		.mem_write_val(mem_write_val)
	);

	ALUControl _ALUControl ( // ALUControl
		.AluOp(ALUOp),
		.FnField(Instruction[5:0]),
		.AluCtrl(ALUCtrl)
	);

	ALU _ALU ( // ALU
		.opA(ReadRegister1),
		.opB(muxalu_out),
		.ALUop(ALUCtrl),
		.result(ALUout),
		.zero(Zero)
	);

	PC # ( // generate PC
		.PC_START_ADDRESS(PC_START_ADDRESS),
		.PC_END_ADDRESS(PC_END_ADDRESS)
	) _PC (
		.clk(clk),
		.reset(reset),
		.ain(signExtend),
		.aout(PC_addr),
		.pcsel(PCsel),
		.stall(stall)
	);

	Andm _AndPC ( // AndPC (branch & zero)
		.inA(Branch),
		.inB(Zero),
		.out(PCsel)
	);

	SignExtend _SignExtend ( // Sign extend
		.out(signExtend),
		.in(Instruction[15:0])
	);

	Mux # ( // MUX for Write Register
		.DATA_LENGTH(5)
	) _Mux_Instruction (
		.sel(RegDst),
		.ina(Instruction[20:16]),
		.inb(Instruction[15:11]),
		.out(muxinstr_out)
	);

	Mux # ( // MUX for ALU
		.DATA_LENGTH(32)
	) _MUX_ALU (
		.sel(ALUSrc),
		.ina(ReadRegister2),
		.inb(signExtend),
		.out(muxalu_out)
	);

	Mux # ( // MUX for Data memory
		.DATA_LENGTH(32)
	) _MUX_Data (
		.sel(MemtoReg),
		.ina(ALUout),
		.inb(ReadData),
		.out(muxdata_out)
	);

`ifdef TEST_PROB
	assign PC_addr_prob = PC_addr;
	assign Instruction_prob = Instruction;
	assign ALUout_prob = ALUout;
	assign mem_addr_instr_prob = mem_addr_instr;
	assign mem_read_en_instr_prob = mem_read_en_instr;
	assign mem_read_val_instr_prob = mem_read_val_instr;
	assign mem_addr_data_prob = mem_addr_data;
	assign mem_read_en_data_prob = mem_read_en_data;
	assign mem_read_val_data_prob = mem_read_val_data;
`endif

endmodule

`endif /*__DATAPATH_V__*/
