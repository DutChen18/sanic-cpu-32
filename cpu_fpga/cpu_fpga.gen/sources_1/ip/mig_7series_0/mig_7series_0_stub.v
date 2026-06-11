// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
// Date        : Tue May 26 19:57:23 2026
// Host        : death running 64-bit CachyOS
// Command     : write_verilog -force -mode synth_stub
//               /home/boysanic/git/sanic-cpu-32/cpu_fpga/cpu_fpga.gen/sources_1/ip/mig_7series_0/mig_7series_0_stub.v
// Design      : mig_7series_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k480tffg1156-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module mig_7series_0(c0_ddr3_dq, c0_ddr3_dqs_n, c0_ddr3_dqs_p, 
  c0_ddr3_addr, c0_ddr3_ba, c0_ddr3_ras_n, c0_ddr3_cas_n, c0_ddr3_we_n, c0_ddr3_reset_n, 
  c0_ddr3_ck_p, c0_ddr3_ck_n, c0_ddr3_cke, c0_ddr3_cs_n, c0_ddr3_dm, c0_ddr3_odt, c0_sys_clk_p, 
  c0_sys_clk_n, clk_ref_p, clk_ref_n, c0_app_addr, c0_app_cmd, c0_app_en, c0_app_wdf_data, 
  c0_app_wdf_end, c0_app_wdf_mask, c0_app_wdf_wren, c0_app_rd_data, c0_app_rd_data_end, 
  c0_app_rd_data_valid, c0_app_rdy, c0_app_wdf_rdy, c0_app_sr_req, c0_app_ref_req, 
  c0_app_zq_req, c0_app_sr_active, c0_app_ref_ack, c0_app_zq_ack, c0_ui_clk, 
  c0_ui_clk_sync_rst, c0_init_calib_complete, c0_device_temp, c1_ddr3_dq, c1_ddr3_dqs_n, 
  c1_ddr3_dqs_p, c1_ddr3_addr, c1_ddr3_ba, c1_ddr3_ras_n, c1_ddr3_cas_n, c1_ddr3_we_n, 
  c1_ddr3_reset_n, c1_ddr3_ck_p, c1_ddr3_ck_n, c1_ddr3_cke, c1_ddr3_cs_n, c1_ddr3_dm, 
  c1_ddr3_odt, c1_sys_clk_p, c1_sys_clk_n, c1_app_addr, c1_app_cmd, c1_app_en, c1_app_wdf_data, 
  c1_app_wdf_end, c1_app_wdf_mask, c1_app_wdf_wren, c1_app_rd_data, c1_app_rd_data_end, 
  c1_app_rd_data_valid, c1_app_rdy, c1_app_wdf_rdy, c1_app_sr_req, c1_app_ref_req, 
  c1_app_zq_req, c1_app_sr_active, c1_app_ref_ack, c1_app_zq_ack, c1_ui_clk, 
  c1_ui_clk_sync_rst, c1_init_calib_complete, c1_device_temp, sys_rst)
/* synthesis syn_black_box black_box_pad_pin="c0_ddr3_dq[63:0],c0_ddr3_dqs_n[7:0],c0_ddr3_dqs_p[7:0],c0_ddr3_addr[15:0],c0_ddr3_ba[2:0],c0_ddr3_ras_n,c0_ddr3_cas_n,c0_ddr3_we_n,c0_ddr3_reset_n,c0_ddr3_ck_p[0:0],c0_ddr3_ck_n[0:0],c0_ddr3_cke[0:0],c0_ddr3_cs_n[0:0],c0_ddr3_dm[7:0],c0_ddr3_odt[0:0],c0_sys_clk_p,c0_sys_clk_n,clk_ref_p,clk_ref_n,c0_app_addr[29:0],c0_app_cmd[2:0],c0_app_en,c0_app_wdf_data[511:0],c0_app_wdf_end,c0_app_wdf_mask[63:0],c0_app_wdf_wren,c0_app_rd_data[511:0],c0_app_rd_data_end,c0_app_rd_data_valid,c0_app_rdy,c0_app_wdf_rdy,c0_app_sr_req,c0_app_ref_req,c0_app_zq_req,c0_app_sr_active,c0_app_ref_ack,c0_app_zq_ack,c0_ui_clk_sync_rst,c0_init_calib_complete,c0_device_temp[11:0],c1_ddr3_dq[7:0],c1_ddr3_dqs_n[0:0],c1_ddr3_dqs_p[0:0],c1_ddr3_addr[13:0],c1_ddr3_ba[2:0],c1_ddr3_ras_n,c1_ddr3_cas_n,c1_ddr3_we_n,c1_ddr3_reset_n,c1_ddr3_ck_p[0:0],c1_ddr3_ck_n[0:0],c1_ddr3_cke[0:0],c1_ddr3_cs_n[0:0],c1_ddr3_dm[0:0],c1_ddr3_odt[0:0],c1_sys_clk_p,c1_sys_clk_n,c1_app_addr[27:0],c1_app_cmd[2:0],c1_app_en,c1_app_wdf_data[63:0],c1_app_wdf_end,c1_app_wdf_mask[7:0],c1_app_wdf_wren,c1_app_rd_data[63:0],c1_app_rd_data_end,c1_app_rd_data_valid,c1_app_rdy,c1_app_wdf_rdy,c1_app_sr_req,c1_app_ref_req,c1_app_zq_req,c1_app_sr_active,c1_app_ref_ack,c1_app_zq_ack,c1_ui_clk_sync_rst,c1_init_calib_complete,c1_device_temp[11:0],sys_rst" */
/* synthesis syn_force_seq_prim="c0_ui_clk" */
/* synthesis syn_force_seq_prim="c1_ui_clk" */;
  inout [63:0]c0_ddr3_dq;
  inout [7:0]c0_ddr3_dqs_n;
  inout [7:0]c0_ddr3_dqs_p;
  output [15:0]c0_ddr3_addr;
  output [2:0]c0_ddr3_ba;
  output c0_ddr3_ras_n;
  output c0_ddr3_cas_n;
  output c0_ddr3_we_n;
  output c0_ddr3_reset_n;
  output [0:0]c0_ddr3_ck_p;
  output [0:0]c0_ddr3_ck_n;
  output [0:0]c0_ddr3_cke;
  output [0:0]c0_ddr3_cs_n;
  output [7:0]c0_ddr3_dm;
  output [0:0]c0_ddr3_odt;
  input c0_sys_clk_p;
  input c0_sys_clk_n;
  input clk_ref_p;
  input clk_ref_n;
  input [29:0]c0_app_addr;
  input [2:0]c0_app_cmd;
  input c0_app_en;
  input [511:0]c0_app_wdf_data;
  input c0_app_wdf_end;
  input [63:0]c0_app_wdf_mask;
  input c0_app_wdf_wren;
  output [511:0]c0_app_rd_data;
  output c0_app_rd_data_end;
  output c0_app_rd_data_valid;
  output c0_app_rdy;
  output c0_app_wdf_rdy;
  input c0_app_sr_req;
  input c0_app_ref_req;
  input c0_app_zq_req;
  output c0_app_sr_active;
  output c0_app_ref_ack;
  output c0_app_zq_ack;
  output c0_ui_clk /* synthesis syn_isclock = 1 */;
  output c0_ui_clk_sync_rst;
  output c0_init_calib_complete;
  output [11:0]c0_device_temp;
  inout [7:0]c1_ddr3_dq;
  inout [0:0]c1_ddr3_dqs_n;
  inout [0:0]c1_ddr3_dqs_p;
  output [13:0]c1_ddr3_addr;
  output [2:0]c1_ddr3_ba;
  output c1_ddr3_ras_n;
  output c1_ddr3_cas_n;
  output c1_ddr3_we_n;
  output c1_ddr3_reset_n;
  output [0:0]c1_ddr3_ck_p;
  output [0:0]c1_ddr3_ck_n;
  output [0:0]c1_ddr3_cke;
  output [0:0]c1_ddr3_cs_n;
  output [0:0]c1_ddr3_dm;
  output [0:0]c1_ddr3_odt;
  input c1_sys_clk_p;
  input c1_sys_clk_n;
  input [27:0]c1_app_addr;
  input [2:0]c1_app_cmd;
  input c1_app_en;
  input [63:0]c1_app_wdf_data;
  input c1_app_wdf_end;
  input [7:0]c1_app_wdf_mask;
  input c1_app_wdf_wren;
  output [63:0]c1_app_rd_data;
  output c1_app_rd_data_end;
  output c1_app_rd_data_valid;
  output c1_app_rdy;
  output c1_app_wdf_rdy;
  input c1_app_sr_req;
  input c1_app_ref_req;
  input c1_app_zq_req;
  output c1_app_sr_active;
  output c1_app_ref_ack;
  output c1_app_zq_ack;
  output c1_ui_clk /* synthesis syn_isclock = 1 */;
  output c1_ui_clk_sync_rst;
  output c1_init_calib_complete;
  output [11:0]c1_device_temp;
  input sys_rst;
endmodule
