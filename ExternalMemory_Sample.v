module ExternalMemory_Sample (
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
	input sys_rst,
	input [27:0] app_addr,
	input [2:0] app_cmd,
	input app_en,
	input [127:0] app_wdf_data,
	input app_wdf_end,
	input [15:0] app_wdf_mask,
	input app_wdf_wren,
	input app_sr_req,
	input app_ref_req,
	input app_zq_req,
	output [127:0] app_rd_data,
	output app_rd_data_end,
	output app_rd_data_valid,
	output app_rdy,
	output app_wdf_rdy,
	output app_sr_active,
	output app_ref_ack,
	output app_zq_ack,
	output ui_clk,
	output ui_clk_sync_rst,
	output init_calib_complete,
	output [11:0] device_temp
	);

endmodule
