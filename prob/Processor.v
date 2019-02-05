`ifndef __PROCESSOR_V__
`define __PROCESSOR_V__

`include "Core.v"
`include "MemoryController.v"

module Processor # (
	parameter MEM_WIDTH = 32,
	parameter MEM_SIZE = 256
	)	(
	input wire clk, // E3
	input wire reset, // D9
	output wire led, // G6
	output wire led3, // T10
	output wire led2, // T9
	output wire led1, // J5
	output wire led0 // H5
`ifdef TEST_PROB
	,
	// processor
	output wire clk_prob,
	output wire [$clog2(MEM_SIZE)-1:0] mem_addr_prob,
	output wire mem_read_en_prob,
	output wire [MEM_WIDTH-1:0] mem_read_val_prob,
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

	localparam PC_START_ADDRESS_CORE_1 = 212;
	localparam PC_END_ADDRESS_CORE_1 = 255;

	wire [$clog2(MEM_SIZE)-1:0] mem_addr;
	wire mem_write_en;
	wire mem_read_en;
	wire [MEM_WIDTH-1:0] mem_write_val;
	wire [MEM_WIDTH-1:0] mem_read_val;

	// Clock Divider Module
	reg clk1Hz = 0;
	integer i = 0;

	always @ (posedge clk)
	begin
		if (i >= 49999999)
		begin
			clk1Hz = ~clk1Hz;
			i = 0;
		end
		else
		begin
			i = i + 1;
		end
	end

	Core # (
		.MEM_WIDTH(MEM_WIDTH),
		.MEM_SIZE(MEM_SIZE),
		.PC_START_ADDRESS(PC_START_ADDRESS_CORE_1),
		.PC_END_ADDRESS(PC_END_ADDRESS_CORE_1)
	) _Core (
		.clk(clk1Hz),
		.reset(reset),
		.mem_addr(mem_addr),
		.mem_write_en(mem_write_en),
		.mem_read_en(mem_read_en),
		.mem_write_val(mem_write_val),
		.mem_read_val(mem_read_val)
	);

	MemoryController # (
		.MEM_WIDTH(MEM_WIDTH),
		.MEM_SIZE(MEM_SIZE)
	) _MemoryController (
		.mem_addr(mem_addr),
		.mem_read_en(mem_read_en),
		.mem_write_en(mem_write_en),
		.mem_read_val(mem_read_val),
		.mem_write_val(mem_write_val)
	);

	// LED Output Module
	assign led = ^(mem_addr ^ mem_write_en ^ mem_read_en ^ mem_write_val ^ mem_read_val);
	assign led3 = mem_read_val[3];
	assign led2 = mem_read_val[2];
	assign led1 = mem_read_val[1];
	assign led0 = mem_read_val[0];

`ifdef TEST_PROB
	assign clk_prob = clk1Hz;
	assign mem_addr_prob = mem_addr;
	assign mem_read_en_prob = mem_read_en;
	assign mem_read_val_prob = mem_read_val;
`endif

endmodule

`endif /*__PROCESSOR_V__*/
