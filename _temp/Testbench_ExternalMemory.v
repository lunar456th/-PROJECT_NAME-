`include "DataMemory.v"

module Testbench_ExternalMemory (
	inout [15:0] ddr3_dq,
	inout [1:0] ddr3_dqs_n,
	inout [1:0] ddr3_dqs_p,
	output [13:0] ddr3_addr,
	output [2:0] ddr3_ba,
	output ddr3_ras_n,
	output ddr3_cas_n,
	output ddr3_we_n,
	output ddr3_reset_n,
	output [0:0] ddr3_ck_p,
	output [0:0] ddr3_ck_n,
	output [0:0] ddr3_cke,
	output [0:0] ddr3_cs_n,
	output [1:0] ddr3_dm,
	output [0:0] ddr3_odt,
	input sys_clk_i,
	input clk_ref_i,
	input sys_rst
	);

    reg clk;
    reg reset;

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
	MemoryController # (
		.DQ_WIDTH(16),
		.ECC_TEST("OFF"),
		.nBANK_MACHS(4),
		.ADDR_WIDTH(28),
		.nCK_PER_CLK(4)
	) _MemoryController (
		.clk(clk),
		.reset(reset),

		.mem_addr(mem_addr),
		.mem_write_en(mem_write_en),
		.mem_read_en(mem_read_en),
		.mem_write_val(mem_write_val),
		.mem_read_val(mem_read_val),
		.mem_response(mem_response),

		.ddr3_dq(ddr3_dq),
		.ddr3_dqs_n(ddr3_dqs_n),
		.ddr3_dqs_p(ddr3_dqs_p),
		.ddr3_addr(ddr3_addr),
		.ddr3_ba(ddr3_ba),
		.ddr3_ras_n(ddr3_ras_n),
		.ddr3_cas_n(ddr3_cas_n),
		.ddr3_we_n(ddr3_we_n),
		.ddr3_reset_n(ddr3_reset_n),
		.ddr3_ck_p(ddr3_ck_p),
		.ddr3_ck_n(ddr3_ck_n),
		.ddr3_cke(ddr3_cke),
		.ddr3_cs_n(ddr3_cs_n),
		.ddr3_dm(ddr3_dm),
		.ddr3_odt(ddr3_odt)
	);

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

    initial
    begin
        clk <= 1'b0;
        reset <= 1'b0;
        forever
        begin
            #1 clk = ~clk;
        end
    end

endmodule