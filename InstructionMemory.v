`ifndef __INSTRUCTIONMEMORY_V__
`define __INSTRUCTIONMEMORY_V__

module InstructionMemory # ( // asynchronous memory with 256 32 - bit locations for instruction memory
	parameter MEM_WIDTH = 32,
	parameter MEM_SIZE = 256
	)	(
	input wire [$clog2(MEM_SIZE)-1:0] addr,
	output reg [MEM_WIDTH-1:0] data_read,

	output reg [31:0] mem_addr,
	output reg mem_read_en,
	input wire [31:0] mem_read_val,
	input wire mem_response
	);

	always @ (addr)
	begin
		mem_addr <= addr;
		mem_read_en <= 1'b1;
	end

	always @ (posedge mem_response)
	begin
		if (mem_read_en)
		begin
			data_read <= mem_read_val;
			mem_read_en <= 1'b0;
		end
	end

endmodule

`endif /*__INSTRUCTIONMEMORY_V__*/
