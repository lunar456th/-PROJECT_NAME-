`ifndef __INSTRUCTIONMEMORY_V__
`define __INSTRUCTIONMEMORY_V__

module InstructionMemory # (
	parameter MEM_WIDTH = 32, // size
	parameter MEM_SIZE = 256 // length
	)	(
	input clk,
	input wire [$clog2(MEM_SIZE)-1:0] addr,
	output wire [MEM_WIDTH-1:0] data_read,
	input wire read_en,

	output wire [$clog2(MEM_SIZE)-1:0] mem_addr,
	output wire mem_read_en,
	input wire [MEM_WIDTH-1:0] mem_read_val
	);

	assign mem_addr = addr;
	assign mem_read_en = read_en;
	assign data_read = read_en ? mem_read_val : 0;

endmodule

`endif /*__INSTRUCTIONMEMORY_V__*/
