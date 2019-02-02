`include "DataMemory.v"
`include "MemoryController.v"

module ExampleTop_tb (
	);

	reg clk;

	parameter MEM_WIDTH = 32;
	parameter MEM_SIZE = 256;

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
		clk <= 0;
		forever
		begin
			#5 clk = ~clk;
		end
	end

	initial
	begin
		addr <= 0; data_write <= 1; read_en <= 0; write_en <= 1; #5;
		addr <= 1; data_write <= 2; read_en <= 0; write_en <= 1; #5;
		addr <= 2; data_write <= 3; read_en <= 0; write_en <= 1; #5;
		addr <= 3; data_write <= 4; read_en <= 0; write_en <= 1; #5;
		addr <= 4; data_write <= 5; read_en <= 0; write_en <= 1; #5;
		addr <= 5; data_write <= 6; read_en <= 0; write_en <= 1; #5;
		addr <= 6; data_write <= 7; read_en <= 0; write_en <= 1; #5;
		addr <= 7; data_write <= 8; read_en <= 0; write_en <= 1; #5;
		addr <= 0; data_write <= 0; write_en <= 0; read_en <= 1; #5; // data_read = 1
		addr <= 1; data_write <= 0; write_en <= 0; read_en <= 1; #5; // data_read = 2
		addr <= 2; data_write <= 0; write_en <= 0; read_en <= 1; #5; // data_read = 3
		addr <= 3; data_write <= 0; write_en <= 0; read_en <= 1; #5; // data_read = 4
		addr <= 4; data_write <= 0; write_en <= 0; read_en <= 1; #5; // data_read = 5
		addr <= 5; data_write <= 0; write_en <= 0; read_en <= 1; #5; // data_read = 6
		addr <= 6; data_write <= 0; write_en <= 0; read_en <= 1; #5; // data_read = 7
		addr <= 7; data_write <= 0; write_en <= 0; read_en <= 1; #5; // data_read = 8
		$finish;
	end

endmodule
