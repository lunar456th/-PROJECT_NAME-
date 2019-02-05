`ifndef __DATAMEMORY_V__
`define __DATAMEMORY_V__

module DataMemory # (
	parameter MEM_WIDTH = 32, // size
	parameter MEM_SIZE = 256 // length
	)	(
	input wire [$clog2(MEM_SIZE)-1:0] addr,
	output wire [MEM_WIDTH-1:0] data_read,
	input wire [MEM_WIDTH-1:0] data_write,
	input wire read_en,
	input wire write_en,

	output wire [$clog2(MEM_SIZE)-1:0] mem_addr,
	output wire mem_read_en,
	output wire mem_write_en,
	input wire [MEM_WIDTH-1:0] mem_read_val,
	output wire [MEM_WIDTH-1:0] mem_write_val
	);

	assign mem_addr = addr;
	assign mem_read_en = read_en;
	assign mem_write_en = write_en;
	assign mem_write_val = write_en ? data_write : 0;
	assign data_read = read_en ? mem_read_val : 0;

endmodule

`endif /*__DATAMEMORY_V__*/
