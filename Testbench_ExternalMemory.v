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

	// ExternalMemory //
	localparam DATA_WIDTH = 16;
	localparam PAYLOAD_WIDTH = (ECC_TEST == "OFF") ? DATA_WIDTH : DQ_WIDTH;
	localparam APP_DATA_WIDTH = 2 * nCK_PER_CLK * PAYLOAD_WIDTH;
	localparam APP_MASK_WIDTH = APP_DATA_WIDTH / 8;
	parameter DQ_WIDTH = 16;
	parameter ECC_TEST = "OFF";
	parameter nBANK_MACHS = 4;
	parameter ADDR_WIDTH = 28;
	parameter nCK_PER_CLK = 4;
	wire ui_clk; //
	wire ui_clk_sync_rst; //
	reg [ADDR_WIDTH-1:0] app_addr;
	reg [2:0] app_cmd;
	reg app_en;
	reg [APP_DATA_WIDTH-1:0] app_wdf_data;
	wire app_wdf_end;
	reg app_wdf_wren;
	wire [APP_DATA_WIDTH-1:0] app_rd_data;
	wire app_rd_data_end;
	wire app_rd_data_valid;
	wire app_rdy;
	wire app_wdf_rdy;
	wire app_sr_active;
	wire app_ref_ack;
	wire app_zq_ack;
	wire [APP_MASK_WIDTH-1:0] app_wdf_mask;
	wire [11:0] device_temp;
	wire init_calib_complete;
	assign clk_ref_i = 0; // temp
	assign device_temp = 0; // temp
	// ~ExternalMemory //

	// DataMemory //
	wire [31:0] mem_addr;
	wire mem_read_en;
	wire mem_write_en;
	reg [31:0] mem_read_val;
	wire [31:0] mem_write_val;
	reg mem_response;
	reg [7:0] addr;
	wire [31:0] data_read;
	reg [31:0] data_write;
	reg read_en;
	reg write_en;

	// ~DataMemory //

	ExternalMemory _ExternalMemory
	(
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
		.ddr3_odt(ddr3_odt),
		.init_calib_complete(init_calib_complete), //
		.app_addr(app_addr),
		.app_cmd(app_cmd),
		.app_en(app_en),
		.app_wdf_data(app_wdf_data),
		.app_wdf_end(app_wdf_end),
		.app_wdf_wren(app_wdf_wren),
		.app_rd_data(app_rd_data),
		.app_rd_data_end(app_rd_data_end),
		.app_rd_data_valid(app_rd_data_valid),
		.app_rdy(app_rdy),
		.app_wdf_rdy(app_wdf_rdy),
		.app_sr_req(1'b0),
		.app_ref_req(1'b0),
		.app_zq_req(1'b0),
		.app_sr_active(app_sr_active),
		.app_ref_ack(app_ref_ack),
		.app_zq_ack(app_zq_ack),
		.ui_clk(ui_clk),
		.ui_clk_sync_rst(ui_clk_sync_rst),
		.app_wdf_mask(app_wdf_mask),
		.sys_clk_i(sys_clk_i),
		.clk_ref_i(sys_ref_i),
		.device_temp(device_temp),
		.sys_rst(sys_rst)
	);

	DataMemory # (
		.MEM_WIDTH(32),
		.MEM_SIZE(256)
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
	
	localparam STATE_INIT = 3'd0;
	localparam STATE_READY = 3'd1;
	localparam STATE_READ = 3'd2;
	localparam STATE_READ_DONE = 3'd3;
	localparam STATE_WRITE = 3'd4;
	localparam STATE_WRITE_DONE = 3'd5;

	reg [2:0] state = STATE_INIT;

	localparam CMD_WRITE = 3'b000;
	localparam CMD_READ = 3'b001;

	always @ (posedge ui_clk)
	begin
		if (ui_clk_sync_rst)
		begin
			state <= STATE_INIT;
			app_en <= 0;
			app_wdf_wren <= 0;
		end
		else
		begin
			case (state)
				STATE_INIT:
				begin
					if (init_calib_complete)
					begin
						state <= STATE_READY;
					end
				end

				STATE_READY:
				begin
					mem_response <= 1'b0;
					state <= STATE_READY;
				end

				STATE_READ:
				begin
					if (app_rdy)
					begin
						app_en <= 1'b1;
						app_addr <= mem_addr;
						app_cmd <= CMD_READ;
						state <= STATE_READ_DONE;
					end
				end

				STATE_READ_DONE:
				begin
					if (app_rdy & app_en)
					begin
						app_en <= 0;
					end

					if (app_rd_data_valid)
					begin
						mem_read_val <= app_rd_data;
						mem_response <= 1'b1;
						state <= STATE_READY;
					end
				end

				STATE_WRITE:
				begin
					if (app_rdy & app_wdf_rdy)
					begin
						app_en <= 1'b1;
						app_wdf_wren <= 1'b1;
						app_addr <= mem_addr;
						app_cmd <= CMD_WRITE;
						app_wdf_data <= mem_write_val;
						state <= STATE_WRITE_DONE;
					end
				end

				STATE_WRITE_DONE:
				begin
					if (app_rdy & app_en)
					begin
						app_en <= 0;
					end

					if (app_wdf_rdy & app_wdf_wren)
					begin
						app_wdf_wren <= 0;
					end

					if (~app_en & ~app_wdf_wren)
					begin
						mem_response <= 1'b1;
						state <= STATE_READY;
					end
				end

				default:
				begin
					state <= STATE_READY;
				end
			endcase
		end
	end

	always @ (mem_read_en or mem_write_en)
	begin
		if (mem_read_en)
		begin
			state <= STATE_READ;
		end

		if (mem_write_en)
		begin
			state <= STATE_WRITE;
		end
	end

    initial
    begin
        clk = 1'b0;
        forever
        begin
            #1 clk = ~clk;
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

    always @ (clk)
    begin
        $monitor("clk = %d", clk);
    end

endmodule