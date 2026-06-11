//*****************************************************************************
// (c) Copyright 2009 - 2010 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /   Vendor             : Xilinx
// \   \   \/    Version            : 4.2
//  \   \        Application        : MIG
//  /   /        Filename           : mig_7series_0.veo
// /___/   /\    Date Last Modified : $Date: 2011/06/02 08:34:47 $
// \   \  /  \   Date Created       : Tue Sept 21 2010
//  \___\/\___\
//
// Device           : 7 Series
// Design Name      : DDR3 SDRAM
// Purpose          : Template file containing code that can be used as a model
//                    for instantiating a CORE Generator module in a HDL design.
// Revision History :
//*****************************************************************************

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG

  mig_7series_0 u_mig_7series_0 (

    // Memory interface ports
    .c0_ddr3_addr                      (c0_ddr3_addr),  // output [15:0]		c0_ddr3_addr
    .c0_ddr3_ba                        (c0_ddr3_ba),  // output [2:0]		c0_ddr3_ba
    .c0_ddr3_cas_n                     (c0_ddr3_cas_n),  // output			c0_ddr3_cas_n
    .c0_ddr3_ck_n                      (c0_ddr3_ck_n),  // output [0:0]		c0_ddr3_ck_n
    .c0_ddr3_ck_p                      (c0_ddr3_ck_p),  // output [0:0]		c0_ddr3_ck_p
    .c0_ddr3_cke                       (c0_ddr3_cke),  // output [0:0]		c0_ddr3_cke
    .c0_ddr3_ras_n                     (c0_ddr3_ras_n),  // output			c0_ddr3_ras_n
    .c0_ddr3_reset_n                   (c0_ddr3_reset_n),  // output			c0_ddr3_reset_n
    .c0_ddr3_we_n                      (c0_ddr3_we_n),  // output			c0_ddr3_we_n
    .c0_ddr3_dq                        (c0_ddr3_dq),  // inout [63:0]		c0_ddr3_dq
    .c0_ddr3_dqs_n                     (c0_ddr3_dqs_n),  // inout [7:0]		c0_ddr3_dqs_n
    .c0_ddr3_dqs_p                     (c0_ddr3_dqs_p),  // inout [7:0]		c0_ddr3_dqs_p
    .c0_init_calib_complete            (c0_init_calib_complete),  // output			c0_init_calib_complete
      
	.c0_ddr3_cs_n                      (c0_ddr3_cs_n),  // output [0:0]		c0_ddr3_cs_n
    .c0_ddr3_dm                        (c0_ddr3_dm),  // output [7:0]		c0_ddr3_dm
    .c0_ddr3_odt                       (c0_ddr3_odt),  // output [0:0]		c0_ddr3_odt
    // Application interface ports
    .c0_app_addr                       (c0_app_addr),  // input [29:0]		c0_app_addr
    .c0_app_cmd                        (c0_app_cmd),  // input [2:0]		c0_app_cmd
    .c0_app_en                         (c0_app_en),  // input				c0_app_en
    .c0_app_wdf_data                   (c0_app_wdf_data),  // input [511:0]		c0_app_wdf_data
    .c0_app_wdf_end                    (c0_app_wdf_end),  // input				c0_app_wdf_end
    .c0_app_wdf_wren                   (c0_app_wdf_wren),  // input				c0_app_wdf_wren
    .c0_app_rd_data                    (c0_app_rd_data),  // output [511:0]		c0_app_rd_data
    .c0_app_rd_data_end                (c0_app_rd_data_end),  // output			c0_app_rd_data_end
    .c0_app_rd_data_valid              (c0_app_rd_data_valid),  // output			c0_app_rd_data_valid
    .c0_app_rdy                        (c0_app_rdy),  // output			c0_app_rdy
    .c0_app_wdf_rdy                    (c0_app_wdf_rdy),  // output			c0_app_wdf_rdy
    .c0_app_sr_req                     (c0_app_sr_req),  // input			c0_app_sr_req
    .c0_app_ref_req                    (c0_app_ref_req),  // input			c0_app_ref_req
    .c0_app_zq_req                     (c0_app_zq_req),  // input			c0_app_zq_req
    .c0_app_sr_active                  (c0_app_sr_active),  // output			c0_app_sr_active
    .c0_app_ref_ack                    (c0_app_ref_ack),  // output			c0_app_ref_ack
    .c0_app_zq_ack                     (c0_app_zq_ack),  // output			c0_app_zq_ack
    .c0_ui_clk                         (c0_ui_clk),  // output			c0_ui_clk
    .c0_ui_clk_sync_rst                (c0_ui_clk_sync_rst),  // output			c0_ui_clk_sync_rst
    .c0_app_wdf_mask                   (c0_app_wdf_mask),  // input [63:0]		c0_app_wdf_mask
    // System Clock Ports
    .c0_sys_clk_p                       (c0_sys_clk_p),  // input				c0_sys_clk_p
    .c0_sys_clk_n                       (c0_sys_clk_n),  // input				c0_sys_clk_n
    // Reference Clock Ports
    .clk_ref_p                      (clk_ref_p),  // input				clk_ref_p
    .clk_ref_n                      (clk_ref_n),  // input				clk_ref_n
    // Memory interface ports
    .c1_ddr3_addr                      (c1_ddr3_addr),  // output [13:0]		c1_ddr3_addr
    .c1_ddr3_ba                        (c1_ddr3_ba),  // output [2:0]		c1_ddr3_ba
    .c1_ddr3_cas_n                     (c1_ddr3_cas_n),  // output			c1_ddr3_cas_n
    .c1_ddr3_ck_n                      (c1_ddr3_ck_n),  // output [0:0]		c1_ddr3_ck_n
    .c1_ddr3_ck_p                      (c1_ddr3_ck_p),  // output [0:0]		c1_ddr3_ck_p
    .c1_ddr3_cke                       (c1_ddr3_cke),  // output [0:0]		c1_ddr3_cke
    .c1_ddr3_ras_n                     (c1_ddr3_ras_n),  // output			c1_ddr3_ras_n
    .c1_ddr3_reset_n                   (c1_ddr3_reset_n),  // output			c1_ddr3_reset_n
    .c1_ddr3_we_n                      (c1_ddr3_we_n),  // output			c1_ddr3_we_n
    .c1_ddr3_dq                        (c1_ddr3_dq),  // inout [7:0]		c1_ddr3_dq
    .c1_ddr3_dqs_n                     (c1_ddr3_dqs_n),  // inout [0:0]		c1_ddr3_dqs_n
    .c1_ddr3_dqs_p                     (c1_ddr3_dqs_p),  // inout [0:0]		c1_ddr3_dqs_p
    .c1_init_calib_complete            (c1_init_calib_complete),  // output			c1_init_calib_complete
      
	.c1_ddr3_cs_n                      (c1_ddr3_cs_n),  // output [0:0]		c1_ddr3_cs_n
    .c1_ddr3_dm                        (c1_ddr3_dm),  // output [0:0]		c1_ddr3_dm
    .c1_ddr3_odt                       (c1_ddr3_odt),  // output [0:0]		c1_ddr3_odt
    // Application interface ports
    .c1_app_addr                       (c1_app_addr),  // input [27:0]		c1_app_addr
    .c1_app_cmd                        (c1_app_cmd),  // input [2:0]		c1_app_cmd
    .c1_app_en                         (c1_app_en),  // input				c1_app_en
    .c1_app_wdf_data                   (c1_app_wdf_data),  // input [63:0]		c1_app_wdf_data
    .c1_app_wdf_end                    (c1_app_wdf_end),  // input				c1_app_wdf_end
    .c1_app_wdf_wren                   (c1_app_wdf_wren),  // input				c1_app_wdf_wren
    .c1_app_rd_data                    (c1_app_rd_data),  // output [63:0]		c1_app_rd_data
    .c1_app_rd_data_end                (c1_app_rd_data_end),  // output			c1_app_rd_data_end
    .c1_app_rd_data_valid              (c1_app_rd_data_valid),  // output			c1_app_rd_data_valid
    .c1_app_rdy                        (c1_app_rdy),  // output			c1_app_rdy
    .c1_app_wdf_rdy                    (c1_app_wdf_rdy),  // output			c1_app_wdf_rdy
    .c1_app_sr_req                     (c1_app_sr_req),  // input			c1_app_sr_req
    .c1_app_ref_req                    (c1_app_ref_req),  // input			c1_app_ref_req
    .c1_app_zq_req                     (c1_app_zq_req),  // input			c1_app_zq_req
    .c1_app_sr_active                  (c1_app_sr_active),  // output			c1_app_sr_active
    .c1_app_ref_ack                    (c1_app_ref_ack),  // output			c1_app_ref_ack
    .c1_app_zq_ack                     (c1_app_zq_ack),  // output			c1_app_zq_ack
    .c1_ui_clk                         (c1_ui_clk),  // output			c1_ui_clk
    .c1_ui_clk_sync_rst                (c1_ui_clk_sync_rst),  // output			c1_ui_clk_sync_rst
    .c1_app_wdf_mask                   (c1_app_wdf_mask),  // input [7:0]		c1_app_wdf_mask
    // System Clock Ports
    .c1_sys_clk_p                       (c1_sys_clk_p),  // input				c1_sys_clk_p
    .c1_sys_clk_n                       (c1_sys_clk_n),  // input				c1_sys_clk_n
    .sys_rst                        (sys_rst) // input sys_rst
    );

// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file mig_7series_0.v when simulating
// the core, mig_7series_0. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "CORE Generator Help".


