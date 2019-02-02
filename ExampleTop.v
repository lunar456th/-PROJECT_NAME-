`include "DataMemory.v"
`include "MemoryController.v"

module ExampleTop # (
	parameter MEM_WIDTH = 32,
	parameter MEM_SIZE = 256
	)	(
	input wire clk,
	output wire led
	);

	wire [31:0] mem_addr;
	wire mem_read_en;
	wire mem_write_en;
	wire [31:0] mem_read_val;
	wire [31:0] mem_write_val;

	reg [7:0] addr;
	wire [31:0] data_read;
	reg [31:0] data_write;
	reg read_en;
	reg write_en;

	DataMemory # (
		.MEM_WIDTH(MEM_WIDTH),
		.MEM_SIZE(MEM_SIZE)
	) _DataMemory (
		.clk(clk),
		.addr(addr),
		.data_read(data_read),
		.data_write(data_write),
		.read_en(read_en),
		.write_en(write_en),
		.mem_addr(mem_addr),
		.mem_read_en(mem_read_en),
		.mem_write_en(mem_write_en),
		.mem_read_val(mem_read_val),
		.mem_write_val(mem_write_val)
	);

	MemoryController # (
		.MEM_WIDTH(MEM_WIDTH),
		.MEM_SIZE(MEM_SIZE)
	) _MemoryController (
		.clk(clk),
		.mem_addr(mem_addr),
		.mem_read_en(mem_read_en),
		.mem_write_en(mem_write_en),
		.mem_read_val(mem_read_val),
		.mem_write_val(mem_write_val)
	);

	initial
	begin
		addr <= 0;
		data_write <= 1;
		read_en <= 0;
		write_en <= 1;
	end

	assign led = ^(addr ^ data_read ^ data_write ^ read_en ^ write_en ^ mem_addr ^ mem_read_en ^ mem_write_en ^ mem_read_val ^ mem_write_val);

endmodule