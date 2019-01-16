`ifndef __DATAMEMORY_V__
`define __DATAMEMORY_V__

module DataMemory # (
	parameter MEM_WIDTH = 32, // size
	parameter MEM_SIZE = 256 // length
	)	(
	input clk,
	input wire [$clog2(MEM_SIZE)-1:0] addr,
	output reg [MEM_WIDTH-1:0] data_read,
	input wire [MEM_WIDTH-1:0] data_write,
	input wire read_en,
	input wire write_en,

	output reg [31:0] mem_addr,
	output reg mem_read_en,
	output reg mem_write_en,
	input wire [31:0] mem_read_val,
	output reg [31:0] mem_write_val,
	input wire mem_response
	);

	always @ (addr or read_en or write_en or data_write)
	begin
		if (read_en)
		begin
			mem_addr <= addr;
			mem_read_en <= 1'b1;
		end

		if (write_en)
		begin
			mem_addr <= addr;
			mem_write_en <= 1'b1;
			mem_write_val <= data_write;
		end
	end

	always @ (posedge mem_response)
	begin
		if (mem_read_en)
		begin
			data_read <= mem_read_val;
			mem_read_en <= 1'b0;
		end

		if (mem_write_en)
		begin
			mem_write_en <= 1'b0;
		end
	end

endmodule

`endif /*__DATAMEMORY_V__*/
