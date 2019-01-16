`ifndef __PROCESSOR_V__
`define __PROCESSOR_V__

`include "Core.v"

module Processor (
	input wire clk,
	input wire reset
	);

	wire [31:0] mem_addr;
	wire mem_write_en;
	wire mem_read_en;
	wire [31:0] mem_write_val;
	wire [31:0] mem_read_val;
	wire mem_response;

	Core _Core (
		.clk(clk),
		.reset(reset),
		.mem_addr(mem_addr),
		.mem_write_en(mem_write_en),
		.mem_read_en(mem_read_en),
		.mem_write_val(mem_write_val),
		.mem_read_val(mem_read_val),
		.mem_response(mem_response)
	);

	TemporaryMemory _TemporaryMemory (
		.mem_addr(mem_addr),
		.mem_write_en(mem_write_en),
		.mem_read_en(mem_read_en),
		.mem_write_val(mem_write_val),
		.mem_read_val(mem_read_val),
		.mem_response(mem_response)
	);

endmodule

`endif /*__PROCESSOR_V__*/
