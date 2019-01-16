`include "DataMemory.v"
`include "TemporaryMemory.v"

`timescale 1ns/1ns

module Testbench ( // 더 이상 건드리면 안됨.
	);

	reg clk;

	wire [31:0] mem_addr;
	wire mem_read_en;
	wire mem_write_en;
	wire [31:0] mem_read_val;
	wire [31:0] mem_write_val;
	wire mem_response;

	reg [7:0] addr;
	wire [31:0] data_read;
	reg [31:0] data_write;
	reg read_en;
	reg write_en;

    DataMemory unit0(clk, addr, data_read, data_write, read_en, write_en, mem_addr, mem_read_en, mem_write_en, mem_read_val, mem_write_val, mem_response);
	TemporaryMemory unit1(clk, mem_addr, mem_read_en, mem_write_en, mem_read_val, mem_write_val, mem_response);

    initial
    begin
        clk <= 1'b0;
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
	
	always @ (*)
	begin
		$monitor("addr = %d, data_write = %d, read_en = %d, write_en = %d", addr, data_write, read_en, write_en);
	end

	always @ (mem_addr)
	begin
		$monitor("mem_addr = %d", mem_addr);
	end

	always @ (mem_read_en)
	begin
		$monitor("mem_read_en = %d", mem_read_en);
	end

	always @ (mem_write_en)
	begin
		$monitor("mem_write_en = %d", mem_write_en);
	end

	always @ (mem_read_val)
	begin
		$monitor("mem_read_val = %d", mem_read_val);
	end

	always @ (mem_write_val)
	begin
		$monitor("mem_write_val = %d", mem_write_val);
	end

	always @ (mem_response)
	begin
		$monitor("mem_response = %d", mem_response);
	end
	
	always @ (data_read)
	begin
		$monitor("data_read = %d", data_read);
	end
	
	always @ (clk)
	begin
	    clk <= ~clk; #1;
	end

endmodule
