`ifndef __PROCESSOR_V__
`define __PROCESSOR_V__

`include "Core.v"
`include "MemoryController.v"

module Processor (
	input wire clk,
	input wire reset,

	// AXI Memory In/Out Ports
	inout wire [15:0] ddr3_dq,
	inout wire [1:0] ddr3_dqs_n,
	inout wire [1:0] ddr3_dqs_p,
	output wire [13:0] ddr3_addr,
	output wire [2:0] ddr3_ba,
	output wire ddr3_ras_n,
	output wire ddr3_cas_n,
	output wire ddr3_we_n,
	output wire ddr3_reset_n,
	output wire [0:0] ddr3_ck_p,
	output wire [0:0] ddr3_ck_n,
	output wire [0:0] ddr3_cke,
	output wire [0:0] ddr3_cs_n,
	output wire [1:0] ddr3_dm,
	output wire [0:0] ddr3_odt
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

endmodule

`endif /*__PROCESSOR_V__*/
