`include "DataMemory.v"
`include "MemoryController.v"

module MemoryController_tb # (
	 parameter DQ_WIDTH = 16,
	 parameter ECC_TEST = "OFF",
	 parameter nBANK_MACHS = 4,
	 parameter ADDR_WIDTH = 28,
	 parameter nCK_PER_CLK = 4,

	 parameter MEM_WIDTH = 32,
	 parameter MEM_SIZE = 256
	)	(
	input wire clk,
	input wire reset,
	output reg led_result,

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

	reg [$clog2(MEM_SIZE)-1:0] addr;
	wire [MEM_WIDTH-1:0] data_read;
	reg [MEM_WIDTH-1:0] data_write;
	reg read_en;
	reg write_en;

	wire [31:0] mem_addr;
	wire mem_read_en;
	wire mem_write_en;
	wire [31:0] mem_read_val;
	wire [31:0] mem_write_val;
	wire mem_response;

	integer count = 0;
	integer tick = 0;
	reg [MEM_WIDTH-1:0] data_result[0:7];

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
		.mem_write_val(mem_write_val),
		.mem_response(mem_response)
	);

	MemoryController # (
		.DQ_WIDTH(DQ_WIDTH),
		.ECC_TEST(ECC_TEST),
		.nBANK_MACHS(nBANK_MACHS),
		.ADDR_WIDTH(ADDR_WIDTH),
		.nCK_PER_CLK(nCK_PER_CLK)
	) _MemoryController (
		.clk(clk),
		.reset(reset),

		.mem_addr(mem_addr),
		.mem_read_en(mem_read_en),
		.mem_write_en(mem_write_en),
		.mem_read_val(mem_read_val),
		.mem_write_val(mem_write_val),
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
		addr = 0;
		data_write = 0;
		read_en = 0;
		write_en = 0;
		data_result[0] = 0;
		data_result[1] = 0;
		data_result[2] = 0;
		data_result[3] = 0;
		data_result[4] = 0;
		data_result[5] = 0;
		data_result[6] = 0;
		data_result[7] = 0;
		led_result = 0;
	end

	always @ (tick)
	begin
		if (tick == 1)
		begin
			addr = 0; data_write = 1; read_en = 0; write_en = 1;
		end
		if (tick == 2)
		begin
			addr = 1; data_write = 2; read_en = 0; write_en = 1;
		end
		if (tick == 3)
		begin
			addr = 2; data_write = 3; read_en = 0; write_en = 1;
		end
		if (tick == 4)
		begin
			addr = 3; data_write = 4; read_en = 0; write_en = 1;
		end
		if (tick == 5)
		begin
			addr = 4; data_write = 5; read_en = 0; write_en = 1;
		end
		if (tick == 6)
		begin
			addr = 5; data_write = 6; read_en = 0; write_en = 1;
		end
		if (tick == 7)
		begin
			addr = 6; data_write = 7; read_en = 0; write_en = 1;
		end
		if (tick == 8)
		begin
			addr = 7; data_write = 8; read_en = 0; write_en = 1;
		end
		if (tick == 9)
		begin
			addr = 0; data_write = 0; write_en = 0; read_en = 1; data_result[0] = data_read;
		end
		if (tick == 10)
		begin
			addr = 1; data_write = 0; write_en = 0; read_en = 1; data_result[1] = data_read;
		end
		if (tick == 11)
		begin
			addr = 2; data_write = 0; write_en = 0; read_en = 1; data_result[2] = data_read;
		end
		if (tick == 12)
		begin
			addr = 3; data_write = 0; write_en = 0; read_en = 1; data_result[3] = data_read;
		end
		if (tick == 13)
		begin
			addr = 4; data_write = 0; write_en = 0; read_en = 1; data_result[4] = data_read;
		end
		if (tick == 14)
		begin
			addr = 5; data_write = 0; write_en = 0; read_en = 1; data_result[5] = data_read;
		end
		if (tick == 15)
		begin
			addr = 6; data_write = 0; write_en = 0; read_en = 1; data_result[6] = data_read;
		end
		if (tick == 16)
		begin
			addr = 7; data_write = 0; write_en = 0; read_en = 1; data_result[7] = data_read;
		end
		if (tick == 17)
		begin
			if (data_result[0] == 1
				&& data_result[1] == 2
				&& data_result[2] == 3
				&& data_result[3] == 4
				&& data_result[4] == 5
				&& data_result[5] == 6
				&& data_result[6] == 7
				&& data_result[7] == 8)
			begin
				led_result = 1'b1;
			end
			else
			begin
				led_result = 1'b0;
			end
		end
	end

	always @ (posedge clk)
	begin
		if (count == 6)
		begin
			if (tick < 20)
			begin
				tick = tick + 1;
			end
			count = 0;
		end
		else
		begin
			count = count + 1;
		end
	end

endmodule
