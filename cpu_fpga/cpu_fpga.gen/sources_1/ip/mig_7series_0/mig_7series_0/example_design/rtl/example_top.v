//*****************************************************************************
// (c) Copyright 2023 Advanced Micro Devices, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor             : AMD
// \   \   \/     Version            : 4.2
//  \   \         Application        : MIG
//  /   /         Filename           : example_top.v
// /___/   /\     Date Last Modified : $Date: 2011/06/02 08:35:03 $
// \   \  /  \    Date Created       : Tue Sept 21 2010
//  \___\/\___\
//
// Device           : 7 Series
// Design Name      : DDR3 SDRAM
// Purpose          :
//   Top-level  module. This module serves as an example,
//   and allows the user to synthesize a self-contained design,
//   which they can be used to test their hardware.
//   In addition to the memory controller, the module instantiates:
//     1. Synthesizable testbench - used to model user's backend logic
//        and generate different traffic patterns
// Reference        :
// Revision History :
//*****************************************************************************

//`define SKIP_CALIB
`timescale 1ps/1ps

module example_top #
  (

   //***************************************************************************
   // Traffic Gen related parameters
   //***************************************************************************
   parameter C0_PORT_MODE             = "BI_MODE",
   parameter C0_DATA_MODE             = 4'b0010,
   parameter C0_TST_MEM_INSTR_MODE    = "R_W_INSTR_MODE",
   parameter C0_EYE_TEST              = "FALSE",
                                     // set EYE_TEST = "TRUE" to probe memory
                                     // signals. Traffic Generator will only
                                     // write to one single location and no
                                     // read transactions will be generated.
   parameter C0_DATA_PATTERN          = "DGEN_ALL",
                                      // For small devices, choose one only.
                                      // For large device, choose "DGEN_ALL"
                                      // "DGEN_HAMMER", "DGEN_WALKING1",
                                      // "DGEN_WALKING0","DGEN_ADDR","
                                      // "DGEN_NEIGHBOR","DGEN_PRBS","DGEN_ALL"
   parameter C0_CMD_PATTERN           = "CGEN_ALL",
                                      // "CGEN_PRBS","CGEN_FIXED","CGEN_BRAM",
                                      // "CGEN_SEQUENTIAL", "CGEN_ALL"
   parameter C0_CMD_WDT               = 'h3FF,
   parameter C0_WR_WDT                = 'h1FFF,
   parameter C0_RD_WDT                = 'h3FF,
   parameter C0_SEL_VICTIM_LINE       = 0,
   parameter C0_BEGIN_ADDRESS         = 32'h00000000,
   parameter C0_END_ADDRESS           = 32'h00ffffff,
   parameter C0_PRBS_EADDR_MASK_POS   = 32'hff000000,

   //***************************************************************************
   // The following parameters refer to width of various ports
   //***************************************************************************
   parameter C0_CK_WIDTH              = 1,
                                     // # of CK/CK# outputs to memory.
   parameter C0_nCS_PER_RANK          = 1,
                                     // # of unique CS outputs per rank for phy
   parameter C0_CKE_WIDTH             = 1,
                                     // # of CKE outputs to memory.
   parameter C0_DM_WIDTH              = 8,
                                     // # of DM (data mask)
   parameter C0_ODT_WIDTH             = 1,
                                     // # of ODT outputs to memory.
   parameter C0_BANK_WIDTH            = 3,
                                     // # of memory Bank Address bits.
   parameter C0_COL_WIDTH             = 10,
                                     // # of memory Column Address bits.
   parameter C0_CS_WIDTH              = 1,
                                     // # of unique CS outputs to memory.
   parameter C0_DQ_WIDTH              = 64,
                                     // # of DQ (data)
   parameter C0_DQS_WIDTH             = 8,
   parameter C0_DQS_CNT_WIDTH         = 3,
                                     // = ceil(log2(DQS_WIDTH))
   parameter C0_DRAM_WIDTH            = 8,
                                     // # of DQ per DQS
   parameter C0_ECC                   = "OFF",
   parameter C0_ECC_TEST              = "OFF",
   //parameter C0_nBANK_MACHS           = 4,
   parameter C0_nBANK_MACHS           = 4,
   parameter C0_RANKS                 = 1,
                                     // # of Ranks.
   parameter C0_ROW_WIDTH             = 16,
                                     // # of memory Row Address bits.
   parameter C0_ADDR_WIDTH            = 30,
                                     // # = RANK_WIDTH + BANK_WIDTH
                                     //     + ROW_WIDTH + COL_WIDTH;
                                     // Chip Select is always tied to low for
                                     // single rank devices

   //***************************************************************************
   // The following parameters are mode register settings
   //***************************************************************************
   parameter C0_BURST_MODE            = "8",
                                     // DDR3 SDRAM:
                                     // Burst Length (Mode Register 0).
                                     // # = "8", "4", "OTF".
                                     // DDR2 SDRAM:
                                     // Burst Length (Mode Register).
                                     // # = "8", "4".

   
   //***************************************************************************
   // The following parameters are multiplier and divisor factors for PLLE2.
   // Based on the selected design frequency these parameters vary.
   //***************************************************************************
   parameter C0_CLKIN_PERIOD          = 1875,
                                     // Input Clock Period
   parameter C0_CLKFBOUT_MULT         = 4,
                                     // write PLL VCO multiplier
   parameter C0_DIVCLK_DIVIDE         = 2,
                                     // write PLL VCO divisor
   parameter C0_CLKOUT0_PHASE         = 337.5,
                                     // Phase for PLL output clock (CLKOUT0)
   parameter C0_CLKOUT0_DIVIDE        = 2,
                                     // VCO output divisor for PLL output clock (CLKOUT0)
   parameter C0_CLKOUT1_DIVIDE        = 2,
                                     // VCO output divisor for PLL output clock (CLKOUT1)
   parameter C0_CLKOUT2_DIVIDE        = 32,
                                     // VCO output divisor for PLL output clock (CLKOUT2)
   parameter C0_CLKOUT3_DIVIDE        = 8,
                                     // VCO output divisor for PLL output clock (CLKOUT3)
   parameter C0_MMCM_VCO              = 1066,
                                     // Max Freq (MHz) of MMCM VCO
   parameter C0_MMCM_MULT_F           = 8,
                                     // write MMCM VCO multiplier
   parameter C0_MMCM_DIVCLK_DIVIDE    = 1,
                                     // write MMCM VCO divisor

   //***************************************************************************
   // Simulation parameters
   //***************************************************************************
   parameter C0_SIMULATION            = "FALSE",
                                     // Should be TRUE during design simulations and
                                     // FALSE during implementations

   //***************************************************************************
   // IODELAY and PHY related parameters
   //***************************************************************************
   parameter C0_TCQ                   = 100,
   
   parameter DRAM_TYPE             = "DDR3",

   
   //***************************************************************************
   // System clock frequency parameters
   //***************************************************************************
   parameter C0_nCK_PER_CLK           = 4,
                                     // # of memory CKs per fabric CLK

   

   //***************************************************************************
   // Debug parameters
   //***************************************************************************
   parameter C0_DEBUG_PORT            = "OFF",
                                     // # = "ON" Enable debug signals/controls.
                                     //   = "OFF" Disable debug signals/controls.
      
   //***************************************************************************
   // Traffic Gen related parameters
   //***************************************************************************
   parameter C1_PORT_MODE             = "BI_MODE",
   parameter C1_DATA_MODE             = 4'b0010,
   parameter C1_TST_MEM_INSTR_MODE    = "R_W_INSTR_MODE",
   parameter C1_EYE_TEST              = "FALSE",
                                     // set EYE_TEST = "TRUE" to probe memory
                                     // signals. Traffic Generator will only
                                     // write to one single location and no
                                     // read transactions will be generated.
   parameter C1_DATA_PATTERN          = "DGEN_ALL",
                                      // For small devices, choose one only.
                                      // For large device, choose "DGEN_ALL"
                                      // "DGEN_HAMMER", "DGEN_WALKING1",
                                      // "DGEN_WALKING0","DGEN_ADDR","
                                      // "DGEN_NEIGHBOR","DGEN_PRBS","DGEN_ALL"
   parameter C1_CMD_PATTERN           = "CGEN_ALL",
                                      // "CGEN_PRBS","CGEN_FIXED","CGEN_BRAM",
                                      // "CGEN_SEQUENTIAL", "CGEN_ALL"
   parameter C1_CMD_WDT               = 'h3FF,
   parameter C1_WR_WDT                = 'h1FFF,
   parameter C1_RD_WDT                = 'h3FF,
   parameter C1_SEL_VICTIM_LINE       = 0,
   parameter C1_BEGIN_ADDRESS         = 32'h00000000,
   parameter C1_END_ADDRESS           = 32'h00ffffff,
   parameter C1_PRBS_EADDR_MASK_POS   = 32'hff000000,

   //***************************************************************************
   // The following parameters refer to width of various ports
   //***************************************************************************
   parameter C1_CK_WIDTH              = 1,
                                     // # of CK/CK# outputs to memory.
   parameter C1_nCS_PER_RANK          = 1,
                                     // # of unique CS outputs per rank for phy
   parameter C1_CKE_WIDTH             = 1,
                                     // # of CKE outputs to memory.
   parameter C1_DM_WIDTH              = 1,
                                     // # of DM (data mask)
   parameter C1_ODT_WIDTH             = 1,
                                     // # of ODT outputs to memory.
   parameter C1_BANK_WIDTH            = 3,
                                     // # of memory Bank Address bits.
   parameter C1_COL_WIDTH             = 10,
                                     // # of memory Column Address bits.
   parameter C1_CS_WIDTH              = 1,
                                     // # of unique CS outputs to memory.
   parameter C1_DQ_WIDTH              = 8,
                                     // # of DQ (data)
   parameter C1_DQS_WIDTH             = 1,
   parameter C1_DQS_CNT_WIDTH         = 1,
                                     // = ceil(log2(DQS_WIDTH))
   parameter C1_DRAM_WIDTH            = 8,
                                     // # of DQ per DQS
   parameter C1_ECC                   = "OFF",
   parameter C1_ECC_TEST              = "OFF",
   //parameter C1_nBANK_MACHS           = 4,
   parameter C1_nBANK_MACHS           = 4,
   parameter C1_RANKS                 = 1,
                                     // # of Ranks.
   parameter C1_ROW_WIDTH             = 14,
                                     // # of memory Row Address bits.
   parameter C1_ADDR_WIDTH            = 28,
                                     // # = RANK_WIDTH + BANK_WIDTH
                                     //     + ROW_WIDTH + COL_WIDTH;
                                     // Chip Select is always tied to low for
                                     // single rank devices

   //***************************************************************************
   // The following parameters are mode register settings
   //***************************************************************************
   parameter C1_BURST_MODE            = "8",
                                     // DDR3 SDRAM:
                                     // Burst Length (Mode Register 0).
                                     // # = "8", "4", "OTF".
                                     // DDR2 SDRAM:
                                     // Burst Length (Mode Register).
                                     // # = "8", "4".

   
   //***************************************************************************
   // The following parameters are multiplier and divisor factors for PLLE2.
   // Based on the selected design frequency these parameters vary.
   //***************************************************************************
   parameter C1_CLKIN_PERIOD          = 1875,
                                     // Input Clock Period
   parameter C1_CLKFBOUT_MULT         = 4,
                                     // write PLL VCO multiplier
   parameter C1_DIVCLK_DIVIDE         = 2,
                                     // write PLL VCO divisor
   parameter C1_CLKOUT0_PHASE         = 337.5,
                                     // Phase for PLL output clock (CLKOUT0)
   parameter C1_CLKOUT0_DIVIDE        = 2,
                                     // VCO output divisor for PLL output clock (CLKOUT0)
   parameter C1_CLKOUT1_DIVIDE        = 2,
                                     // VCO output divisor for PLL output clock (CLKOUT1)
   parameter C1_CLKOUT2_DIVIDE        = 32,
                                     // VCO output divisor for PLL output clock (CLKOUT2)
   parameter C1_CLKOUT3_DIVIDE        = 8,
                                     // VCO output divisor for PLL output clock (CLKOUT3)
   parameter C1_MMCM_VCO              = 1066,
                                     // Max Freq (MHz) of MMCM VCO
   parameter C1_MMCM_MULT_F           = 8,
                                     // write MMCM VCO multiplier
   parameter C1_MMCM_DIVCLK_DIVIDE    = 1,
                                     // write MMCM VCO divisor

   //***************************************************************************
   // Simulation parameters
   //***************************************************************************
   parameter C1_SIMULATION            = "FALSE",
                                     // Should be TRUE during design simulations and
                                     // FALSE during implementations

   //***************************************************************************
   // IODELAY and PHY related parameters
   //***************************************************************************
   parameter C1_TCQ                   = 100,
   

   
   //***************************************************************************
   // System clock frequency parameters
   //***************************************************************************
   parameter C1_nCK_PER_CLK           = 4,
                                     // # of memory CKs per fabric CLK

   

   //***************************************************************************
   // Debug parameters
   //***************************************************************************
   parameter C1_DEBUG_PORT            = "OFF",
                                     // # = "ON" Enable debug signals/controls.
                                     //   = "OFF" Disable debug signals/controls.
      
   parameter RST_ACT_LOW           = 1
                                     // =1 for active low reset,
                                     // =0 for active high.
   )
  (

   // Inouts
   inout [63:0]                         c0_ddr3_dq,
   inout [7:0]                        c0_ddr3_dqs_n,
   inout [7:0]                        c0_ddr3_dqs_p,

   // Outputs
   output [15:0]                       c0_ddr3_addr,
   output [2:0]                      c0_ddr3_ba,
   output                                       c0_ddr3_ras_n,
   output                                       c0_ddr3_cas_n,
   output                                       c0_ddr3_we_n,
   output                                       c0_ddr3_reset_n,
   output [0:0]                        c0_ddr3_ck_p,
   output [0:0]                        c0_ddr3_ck_n,
   output [0:0]                       c0_ddr3_cke,
   
   output [0:0]           c0_ddr3_cs_n,
   
   output [7:0]                        c0_ddr3_dm,
   
   output [0:0]                       c0_ddr3_odt,
   

   // Inputs
   
   // Differential system clocks
   input                                        c0_sys_clk_p,
   input                                        c0_sys_clk_n,
   
   // differential iodelayctrl clk (reference clock)
   input                                        clk_ref_p,
   input                                        clk_ref_n,

   output                                       tg_compare_error,
   output                                       init_calib_complete,
   
      
   // Inouts
   inout [7:0]                         c1_ddr3_dq,
   inout [0:0]                        c1_ddr3_dqs_n,
   inout [0:0]                        c1_ddr3_dqs_p,

   // Outputs
   output [13:0]                       c1_ddr3_addr,
   output [2:0]                      c1_ddr3_ba,
   output                                       c1_ddr3_ras_n,
   output                                       c1_ddr3_cas_n,
   output                                       c1_ddr3_we_n,
   output                                       c1_ddr3_reset_n,
   output [0:0]                        c1_ddr3_ck_p,
   output [0:0]                        c1_ddr3_ck_n,
   output [0:0]                       c1_ddr3_cke,
   
   output [0:0]           c1_ddr3_cs_n,
   
   output [0:0]                        c1_ddr3_dm,
   
   output [0:0]                       c1_ddr3_odt,
   

   // Inputs
   
   // Differential system clocks
   input                                        c1_sys_clk_p,
   input                                        c1_sys_clk_n,
   

   
   
   
      

   // System reset - Default polarity of sys_rst pin is Active Low.
   // System reset polarity will change based on the option 
   // selected in GUI.
   input                                        sys_rst
   );

function integer clogb2 (input integer size);
    begin
      size = size - 1;
      for (clogb2=1; size>1; clogb2=clogb2+1)
        size = size >> 1;
    end
  endfunction // clogb2

  function integer STR_TO_INT;
    input [7:0] in;
    begin
      if(in == "8")
        STR_TO_INT = 8;
      else if(in == "4")
        STR_TO_INT = 4;
      else
        STR_TO_INT = 0;
    end
  endfunction


  localparam C0_DATA_WIDTH            = 64;
  localparam C0_RANK_WIDTH = clogb2(C0_RANKS);
  localparam C0_PAYLOAD_WIDTH         = (C0_ECC_TEST == "OFF") ? C0_DATA_WIDTH : C0_DQ_WIDTH;
  localparam C0_BURST_LENGTH          = STR_TO_INT(C0_BURST_MODE);
  localparam C0_APP_DATA_WIDTH        = 2 * C0_nCK_PER_CLK * C0_PAYLOAD_WIDTH;
  localparam C0_APP_MASK_WIDTH        = C0_APP_DATA_WIDTH / 8;

  //***************************************************************************
  // Traffic Gen related parameters (derived)
  //***************************************************************************
  localparam  C0_TG_ADDR_WIDTH = ((C0_CS_WIDTH == 1) ? 0 : C0_RANK_WIDTH)
                                 + C0_BANK_WIDTH + C0_ROW_WIDTH + C0_COL_WIDTH;
  localparam C0_MASK_SIZE             = C0_DATA_WIDTH/8;
      
  localparam C1_DATA_WIDTH            = 8;
  localparam C1_RANK_WIDTH = clogb2(C1_RANKS);
  localparam C1_PAYLOAD_WIDTH         = (C1_ECC_TEST == "OFF") ? C1_DATA_WIDTH : C1_DQ_WIDTH;
  localparam C1_BURST_LENGTH          = STR_TO_INT(C1_BURST_MODE);
  localparam C1_APP_DATA_WIDTH        = 2 * C1_nCK_PER_CLK * C1_PAYLOAD_WIDTH;
  localparam C1_APP_MASK_WIDTH        = C1_APP_DATA_WIDTH / 8;

  //***************************************************************************
  // Traffic Gen related parameters (derived)
  //***************************************************************************
  localparam  C1_TG_ADDR_WIDTH = ((C1_CS_WIDTH == 1) ? 0 : C1_RANK_WIDTH)
                                 + C1_BANK_WIDTH + C1_ROW_WIDTH + C1_COL_WIDTH;
  localparam C1_MASK_SIZE             = C1_DATA_WIDTH/8;
      

  // Wire declarations
      
  wire [(2*C0_nCK_PER_CLK)-1:0]              c0_app_ecc_multiple_err;
  wire [(2*C0_nCK_PER_CLK)-1:0]              c0_app_ecc_single_err;
  wire [C0_ADDR_WIDTH-1:0]                 c0_app_addr;
  wire [2:0]                            c0_app_cmd;
  wire                                  c0_app_en;
  wire                                  c0_app_rdy;
  wire [C0_APP_DATA_WIDTH-1:0]             c0_app_rd_data;
  wire                                  c0_app_rd_data_end;
  wire                                  c0_app_rd_data_valid;
  wire [C0_APP_DATA_WIDTH-1:0]             c0_app_wdf_data;
  wire                                  c0_app_wdf_end;
  wire [C0_APP_MASK_WIDTH-1:0]             c0_app_wdf_mask;
  wire                                  c0_app_wdf_rdy;
  wire                                  c0_app_sr_active;
  wire                                  c0_app_ref_ack;
  wire                                  c0_app_zq_ack;
  wire                                  c0_app_wdf_wren;
  wire [(64+(2*C0_APP_DATA_WIDTH))-1:0]      c0_error_status;
  wire [(C0_PAYLOAD_WIDTH/8)-1:0] c0_cumlative_dq_lane_error;
  wire                                  c0_mem_pattern_init_done;
  wire [47:0]                           c0_tg_wr_data_counts;
  wire [47:0]                           c0_tg_rd_data_counts;
  wire                                  c0_modify_enable_sel;
  wire [2:0]                            c0_data_mode_manual_sel;
  wire [2:0]                            c0_addr_mode_manual_sel;
  wire [C0_APP_DATA_WIDTH-1:0]             c0_cmp_data;
  reg [63:0]                            c0_cmp_data_r;
  wire                                  c0_cmp_data_valid;
  reg                                   c0_cmp_data_valid_r;
  wire                                  c0_cmp_error;
  wire [(C0_PAYLOAD_WIDTH/8)-1:0]            c0_dq_error_bytelane_cmp;

  wire                                  c0_clk;
  wire                                  c0_rst;

  wire                                  c0_dbg_sel_pi_incdec;
  wire                                  c0_dbg_pi_f_inc;
  wire                                  c0_dbg_pi_f_dec;
  wire                                  c0_dbg_sel_po_incdec;
  wire                                  c0_dbg_po_f_inc;
  wire                                  c0_dbg_po_f_stg23_sel;
  wire                                  c0_dbg_po_f_dec;
  
  
  wire                                  c0_vio_modify_enable;
  wire [3:0]                            c0_vio_data_mode_value;
  wire                                  c0_vio_pause_traffic;
  wire [2:0]                            c0_vio_addr_mode_value;
  wire [3:0]                            c0_vio_instr_mode_value;
  wire [1:0]                            c0_vio_bl_mode_value;
  wire [9:0]                            c0_vio_fixed_bl_value;
  wire [2:0]                            c0_vio_fixed_instr_value;
  wire                                  c0_vio_data_mask_gen;
  wire                                  c0_vio_tg_rst;
  wire                                  c0_vio_dbg_sel_pi_incdec;
  wire                                  c0_vio_dbg_pi_f_inc;
  wire                                  c0_vio_dbg_pi_f_dec;
  wire                                  c0_vio_dbg_sel_po_incdec;
  wire                                  c0_vio_dbg_po_f_inc;
  wire                                  c0_vio_dbg_po_f_stg23_sel;
  wire                                  c0_vio_dbg_po_f_dec;
     
  wire [11:0]                           c0_device_temp;
  
`ifdef SKIP_CALIB
  // skip calibration wires
  wire                          c0_calib_tap_req;
  reg                           c0_calib_tap_load;
  reg [6:0]                     c0_calib_tap_addr;
  reg [7:0]                     c0_calib_tap_val;
  reg                           c0_calib_tap_load_done;
`endif
      
    // Wire declarations
      
  wire [(2*C1_nCK_PER_CLK)-1:0]              c1_app_ecc_multiple_err;
  wire [(2*C1_nCK_PER_CLK)-1:0]              c1_app_ecc_single_err;
  wire [C1_ADDR_WIDTH-1:0]                 c1_app_addr;
  wire [2:0]                            c1_app_cmd;
  wire                                  c1_app_en;
  wire                                  c1_app_rdy;
  wire [C1_APP_DATA_WIDTH-1:0]             c1_app_rd_data;
  wire                                  c1_app_rd_data_end;
  wire                                  c1_app_rd_data_valid;
  wire [C1_APP_DATA_WIDTH-1:0]             c1_app_wdf_data;
  wire                                  c1_app_wdf_end;
  wire [C1_APP_MASK_WIDTH-1:0]             c1_app_wdf_mask;
  wire                                  c1_app_wdf_rdy;
  wire                                  c1_app_sr_active;
  wire                                  c1_app_ref_ack;
  wire                                  c1_app_zq_ack;
  wire                                  c1_app_wdf_wren;
  wire [(64+(2*C1_APP_DATA_WIDTH))-1:0]      c1_error_status;
  wire [(C1_PAYLOAD_WIDTH/8)-1:0] c1_cumlative_dq_lane_error;
  wire                                  c1_mem_pattern_init_done;
  wire [47:0]                           c1_tg_wr_data_counts;
  wire [47:0]                           c1_tg_rd_data_counts;
  wire                                  c1_modify_enable_sel;
  wire [2:0]                            c1_data_mode_manual_sel;
  wire [2:0]                            c1_addr_mode_manual_sel;
  wire [C1_APP_DATA_WIDTH-1:0]             c1_cmp_data;
  reg [63:0]                            c1_cmp_data_r;
  wire                                  c1_cmp_data_valid;
  reg                                   c1_cmp_data_valid_r;
  wire                                  c1_cmp_error;
  wire [(C1_PAYLOAD_WIDTH/8)-1:0]            c1_dq_error_bytelane_cmp;

  wire                                  c1_clk;
  wire                                  c1_rst;

  wire                                  c1_dbg_sel_pi_incdec;
  wire                                  c1_dbg_pi_f_inc;
  wire                                  c1_dbg_pi_f_dec;
  wire                                  c1_dbg_sel_po_incdec;
  wire                                  c1_dbg_po_f_inc;
  wire                                  c1_dbg_po_f_stg23_sel;
  wire                                  c1_dbg_po_f_dec;
  
  
  wire                                  c1_vio_modify_enable;
  wire [3:0]                            c1_vio_data_mode_value;
  wire                                  c1_vio_pause_traffic;
  wire [2:0]                            c1_vio_addr_mode_value;
  wire [3:0]                            c1_vio_instr_mode_value;
  wire [1:0]                            c1_vio_bl_mode_value;
  wire [9:0]                            c1_vio_fixed_bl_value;
  wire [2:0]                            c1_vio_fixed_instr_value;
  wire                                  c1_vio_data_mask_gen;
  wire                                  c1_vio_tg_rst;
  wire                                  c1_vio_dbg_sel_pi_incdec;
  wire                                  c1_vio_dbg_pi_f_inc;
  wire                                  c1_vio_dbg_pi_f_dec;
  wire                                  c1_vio_dbg_sel_po_incdec;
  wire                                  c1_vio_dbg_po_f_inc;
  wire                                  c1_vio_dbg_po_f_stg23_sel;
  wire                                  c1_vio_dbg_po_f_dec;
     
  wire [11:0]                           c1_device_temp;
  
`ifdef SKIP_CALIB
  // skip calibration wires
  wire                          c1_calib_tap_req;
  reg                           c1_calib_tap_load;
  reg [6:0]                     c1_calib_tap_addr;
  reg [7:0]                     c1_calib_tap_val;
  reg                           c1_calib_tap_load_done;
`endif
      
  

//***************************************************************************
	wire                            c0_init_calib_complete;
	wire                            c0_tg_compare_error;
	wire                            c1_init_calib_complete;
	wire                            c1_tg_compare_error;

  assign init_calib_complete = c0_init_calib_complete & c1_init_calib_complete;
  assign tg_compare_error = c0_tg_compare_error | c1_tg_compare_error;



      
      
// Start of User Design top instance
//***************************************************************************
// The User design is instantiated below. The memory interface ports are
// connected to the top-level and the application interface ports are
// connected to the traffic generator module. This provides a reference
// for connecting the memory controller to system.
//***************************************************************************

  mig_7series_0 u_mig_7series_0
      (
       
       
// Memory interface ports
       .c0_ddr3_addr                      (c0_ddr3_addr),
       .c0_ddr3_ba                        (c0_ddr3_ba),
       .c0_ddr3_cas_n                     (c0_ddr3_cas_n),
       .c0_ddr3_ck_n                      (c0_ddr3_ck_n),
       .c0_ddr3_ck_p                      (c0_ddr3_ck_p),
       .c0_ddr3_cke                       (c0_ddr3_cke),
       .c0_ddr3_ras_n                     (c0_ddr3_ras_n),
       .c0_ddr3_we_n                      (c0_ddr3_we_n),
       .c0_ddr3_dq                        (c0_ddr3_dq),
       .c0_ddr3_dqs_n                     (c0_ddr3_dqs_n),
       .c0_ddr3_dqs_p                     (c0_ddr3_dqs_p),
       .c0_ddr3_reset_n                   (c0_ddr3_reset_n),
       .c0_init_calib_complete            (c0_init_calib_complete),
      
       .c0_ddr3_cs_n                      (c0_ddr3_cs_n),
       .c0_ddr3_dm                        (c0_ddr3_dm),
       .c0_ddr3_odt                       (c0_ddr3_odt),
// Application interface ports
       .c0_app_addr                       (c0_app_addr),
       .c0_app_cmd                        (c0_app_cmd),
       .c0_app_en                         (c0_app_en),
       .c0_app_wdf_data                   (c0_app_wdf_data),
       .c0_app_wdf_end                    (c0_app_wdf_end),
       .c0_app_wdf_wren                   (c0_app_wdf_wren),
       .c0_app_rd_data                    (c0_app_rd_data),
       .c0_app_rd_data_end                (c0_app_rd_data_end),
       .c0_app_rd_data_valid              (c0_app_rd_data_valid),
       .c0_app_rdy                        (c0_app_rdy),
       .c0_app_wdf_rdy                    (c0_app_wdf_rdy),
       .c0_app_sr_req                     (1'b0),
       .c0_app_ref_req                    (1'b0),
       .c0_app_zq_req                     (1'b0),
       .c0_app_sr_active                  (c0_app_sr_active),
       .c0_app_ref_ack                    (c0_app_ref_ack),
       .c0_app_zq_ack                     (c0_app_zq_ack),
       .c0_ui_clk                         (c0_clk),
       .c0_ui_clk_sync_rst                (c0_rst),
      
       .c0_app_wdf_mask                   (c0_app_wdf_mask),
      
       
// System Clock Ports
       .c0_sys_clk_p                       (c0_sys_clk_p),
       .c0_sys_clk_n                       (c0_sys_clk_n),
// Reference Clock Ports
       .clk_ref_p                      (clk_ref_p),
       .clk_ref_n                      (clk_ref_n),
       .c0_device_temp            (c0_device_temp),
       `ifdef SKIP_CALIB
       .c0_calib_tap_req                    (c0_calib_tap_req),
       .c0_calib_tap_load                   (c0_calib_tap_load),
       .c0_calib_tap_addr                   (c0_calib_tap_addr),
       .c0_calib_tap_val                    (c0_calib_tap_val),
       .c0_calib_tap_load_done              (c0_calib_tap_load_done),
       `endif
      
       
// Memory interface ports
       .c1_ddr3_addr                      (c1_ddr3_addr),
       .c1_ddr3_ba                        (c1_ddr3_ba),
       .c1_ddr3_cas_n                     (c1_ddr3_cas_n),
       .c1_ddr3_ck_n                      (c1_ddr3_ck_n),
       .c1_ddr3_ck_p                      (c1_ddr3_ck_p),
       .c1_ddr3_cke                       (c1_ddr3_cke),
       .c1_ddr3_ras_n                     (c1_ddr3_ras_n),
       .c1_ddr3_we_n                      (c1_ddr3_we_n),
       .c1_ddr3_dq                        (c1_ddr3_dq),
       .c1_ddr3_dqs_n                     (c1_ddr3_dqs_n),
       .c1_ddr3_dqs_p                     (c1_ddr3_dqs_p),
       .c1_ddr3_reset_n                   (c1_ddr3_reset_n),
       .c1_init_calib_complete            (c1_init_calib_complete),
      
       .c1_ddr3_cs_n                      (c1_ddr3_cs_n),
       .c1_ddr3_dm                        (c1_ddr3_dm),
       .c1_ddr3_odt                       (c1_ddr3_odt),
// Application interface ports
       .c1_app_addr                       (c1_app_addr),
       .c1_app_cmd                        (c1_app_cmd),
       .c1_app_en                         (c1_app_en),
       .c1_app_wdf_data                   (c1_app_wdf_data),
       .c1_app_wdf_end                    (c1_app_wdf_end),
       .c1_app_wdf_wren                   (c1_app_wdf_wren),
       .c1_app_rd_data                    (c1_app_rd_data),
       .c1_app_rd_data_end                (c1_app_rd_data_end),
       .c1_app_rd_data_valid              (c1_app_rd_data_valid),
       .c1_app_rdy                        (c1_app_rdy),
       .c1_app_wdf_rdy                    (c1_app_wdf_rdy),
       .c1_app_sr_req                     (1'b0),
       .c1_app_ref_req                    (1'b0),
       .c1_app_zq_req                     (1'b0),
       .c1_app_sr_active                  (c1_app_sr_active),
       .c1_app_ref_ack                    (c1_app_ref_ack),
       .c1_app_zq_ack                     (c1_app_zq_ack),
       .c1_ui_clk                         (c1_clk),
       .c1_ui_clk_sync_rst                (c1_rst),
      
       .c1_app_wdf_mask                   (c1_app_wdf_mask),
      
       
// System Clock Ports
       .c1_sys_clk_p                       (c1_sys_clk_p),
       .c1_sys_clk_n                       (c1_sys_clk_n),
       .c1_device_temp            (c1_device_temp),
       `ifdef SKIP_CALIB
       .c1_calib_tap_req                    (c1_calib_tap_req),
       .c1_calib_tap_load                   (c1_calib_tap_load),
       .c1_calib_tap_addr                   (c1_calib_tap_addr),
       .c1_calib_tap_val                    (c1_calib_tap_val),
       .c1_calib_tap_load_done              (c1_calib_tap_load_done),
       `endif
      
       .sys_rst                        (sys_rst)
       );
// End of User Design top instance


//***************************************************************************
// The traffic generation module instantiated below drives traffic (patterns)
// on the application interface of the memory controller
//***************************************************************************

  mig_7series_v4_2_traffic_gen_top #
    (
     .TCQ                 (C0_TCQ),
     .SIMULATION          (C0_SIMULATION),
     .FAMILY              ("VIRTEX7"),
     .MEM_TYPE            (DRAM_TYPE),
     .TST_MEM_INSTR_MODE  (C0_TST_MEM_INSTR_MODE),
     //.BL_WIDTH            (C0_BL_WIDTH),
     .nCK_PER_CLK         (C0_nCK_PER_CLK),
     .NUM_DQ_PINS         (C0_PAYLOAD_WIDTH),
     .MEM_BURST_LEN       (C0_BURST_LENGTH),
     .MEM_COL_WIDTH       (C0_COL_WIDTH),
     .PORT_MODE           (C0_PORT_MODE),
     .DATA_PATTERN        (C0_DATA_PATTERN),
     .CMD_PATTERN         (C0_CMD_PATTERN),
     .DATA_WIDTH          (C0_APP_DATA_WIDTH),
     .ADDR_WIDTH          (C0_TG_ADDR_WIDTH),
     .MASK_SIZE           (C0_MASK_SIZE),
     .BEGIN_ADDRESS       (C0_BEGIN_ADDRESS),
     .DATA_MODE           (C0_DATA_MODE),
     .END_ADDRESS         (C0_END_ADDRESS),
     .PRBS_EADDR_MASK_POS (C0_PRBS_EADDR_MASK_POS),
     .SEL_VICTIM_LINE     (C0_SEL_VICTIM_LINE),
     .CMD_WDT             (C0_CMD_WDT),
     .RD_WDT              (C0_RD_WDT),
     .WR_WDT              (C0_WR_WDT),
     .EYE_TEST            (C0_EYE_TEST)
     )
    c0_u_traffic_gen_top
      (
       .clk                  (c0_clk),
       .rst                  (c0_rst),
       .tg_only_rst          (c0_po_win_tg_rst | c0_vio_tg_rst),
       .manual_clear_error   (c0_manual_clear_error),
       .memc_init_done       (c0_init_calib_complete),
       .memc_cmd_full        (~c0_app_rdy),
       .memc_cmd_en          (c0_app_en),
       .memc_cmd_instr       (c0_app_cmd),
       .memc_cmd_bl          (),
       .memc_cmd_addr        (c0_app_addr),
       .memc_wr_en           (c0_app_wdf_wren),
       .memc_wr_end          (c0_app_wdf_end),
       .memc_wr_mask         (c0_app_wdf_mask),
       .memc_wr_data         (c0_app_wdf_data),
       .memc_wr_full         (~c0_app_wdf_rdy),
       .memc_rd_en           (),
       .memc_rd_data         (c0_app_rd_data),
       .memc_rd_empty        (~c0_app_rd_data_valid),
       .qdr_wr_cmd_o         (),
       .qdr_rd_cmd_o         (),
       .vio_pause_traffic    (c0_vio_pause_traffic),
       .vio_modify_enable    (c0_vio_modify_enable),
       .vio_data_mode_value  (c0_vio_data_mode_value),
       .vio_addr_mode_value  (c0_vio_addr_mode_value),
       .vio_instr_mode_value (c0_vio_instr_mode_value),
       .vio_bl_mode_value    (c0_vio_bl_mode_value),
       .vio_fixed_bl_value   (c0_vio_fixed_bl_value),
       .vio_fixed_instr_value(c0_vio_fixed_instr_value),
       .vio_data_mask_gen    (c0_vio_data_mask_gen),
       .fixed_addr_i         (32'b0),
       .fixed_data_i         (32'b0),
       .simple_data0         (32'b0),
       .simple_data1         (32'b0),
       .simple_data2         (32'b0),
       .simple_data3         (32'b0),
       .simple_data4         (32'b0),
       .simple_data5         (32'b0),
       .simple_data6         (32'b0),
       .simple_data7         (32'b0),
       .wdt_en_i             (c0_wdt_en_w),
       .bram_cmd_i           (39'b0),
       .bram_valid_i         (1'b0),
       .bram_rdy_o           (),
       .cmp_data             (c0_cmp_data),
       .cmp_data_valid       (c0_cmp_data_valid),
       .cmp_error            (c0_cmp_error),
       .wr_data_counts       (c0_tg_wr_data_counts),
       .rd_data_counts       (c0_tg_rd_data_counts),
       .dq_error_bytelane_cmp (c0_dq_error_bytelane_cmp),
       .error                (c0_tg_compare_error),
       .error_status         (c0_error_status),
       .cumlative_dq_lane_error (c0_cumlative_dq_lane_error),
       .cmd_wdt_err_o         (c0_cmd_wdt_err_w),
       .wr_wdt_err_o          (c0_wr_wdt_err_w),
       .rd_wdt_err_o          (c0_rd_wdt_err_w),
       .mem_pattern_init_done   (c0_mem_pattern_init_done)
       );
//***************************************************************************
// The traffic generation module instantiated below drives traffic (patterns)
// on the application interface of the memory controller
//***************************************************************************

  mig_7series_v4_2_traffic_gen_top #
    (
     .TCQ                 (C1_TCQ),
     .SIMULATION          (C1_SIMULATION),
     .FAMILY              ("VIRTEX7"),
     .MEM_TYPE            (DRAM_TYPE),
     .TST_MEM_INSTR_MODE  (C1_TST_MEM_INSTR_MODE),
     //.BL_WIDTH            (C1_BL_WIDTH),
     .nCK_PER_CLK         (C1_nCK_PER_CLK),
     .NUM_DQ_PINS         (C1_PAYLOAD_WIDTH),
     .MEM_BURST_LEN       (C1_BURST_LENGTH),
     .MEM_COL_WIDTH       (C1_COL_WIDTH),
     .PORT_MODE           (C1_PORT_MODE),
     .DATA_PATTERN        (C1_DATA_PATTERN),
     .CMD_PATTERN         (C1_CMD_PATTERN),
     .DATA_WIDTH          (C1_APP_DATA_WIDTH),
     .ADDR_WIDTH          (C1_TG_ADDR_WIDTH),
     .MASK_SIZE           (C1_MASK_SIZE),
     .BEGIN_ADDRESS       (C1_BEGIN_ADDRESS),
     .DATA_MODE           (C1_DATA_MODE),
     .END_ADDRESS         (C1_END_ADDRESS),
     .PRBS_EADDR_MASK_POS (C1_PRBS_EADDR_MASK_POS),
     .SEL_VICTIM_LINE     (C1_SEL_VICTIM_LINE),
     .CMD_WDT             (C1_CMD_WDT),
     .RD_WDT              (C1_RD_WDT),
     .WR_WDT              (C1_WR_WDT),
     .EYE_TEST            (C1_EYE_TEST)
     )
    c1_u_traffic_gen_top
      (
       .clk                  (c1_clk),
       .rst                  (c1_rst),
       .tg_only_rst          (c1_po_win_tg_rst | c1_vio_tg_rst),
       .manual_clear_error   (c1_manual_clear_error),
       .memc_init_done       (c1_init_calib_complete),
       .memc_cmd_full        (~c1_app_rdy),
       .memc_cmd_en          (c1_app_en),
       .memc_cmd_instr       (c1_app_cmd),
       .memc_cmd_bl          (),
       .memc_cmd_addr        (c1_app_addr),
       .memc_wr_en           (c1_app_wdf_wren),
       .memc_wr_end          (c1_app_wdf_end),
       .memc_wr_mask         (c1_app_wdf_mask),
       .memc_wr_data         (c1_app_wdf_data),
       .memc_wr_full         (~c1_app_wdf_rdy),
       .memc_rd_en           (),
       .memc_rd_data         (c1_app_rd_data),
       .memc_rd_empty        (~c1_app_rd_data_valid),
       .qdr_wr_cmd_o         (),
       .qdr_rd_cmd_o         (),
       .vio_pause_traffic    (c1_vio_pause_traffic),
       .vio_modify_enable    (c1_vio_modify_enable),
       .vio_data_mode_value  (c1_vio_data_mode_value),
       .vio_addr_mode_value  (c1_vio_addr_mode_value),
       .vio_instr_mode_value (c1_vio_instr_mode_value),
       .vio_bl_mode_value    (c1_vio_bl_mode_value),
       .vio_fixed_bl_value   (c1_vio_fixed_bl_value),
       .vio_fixed_instr_value(c1_vio_fixed_instr_value),
       .vio_data_mask_gen    (c1_vio_data_mask_gen),
       .fixed_addr_i         (32'b0),
       .fixed_data_i         (32'b0),
       .simple_data0         (32'b0),
       .simple_data1         (32'b0),
       .simple_data2         (32'b0),
       .simple_data3         (32'b0),
       .simple_data4         (32'b0),
       .simple_data5         (32'b0),
       .simple_data6         (32'b0),
       .simple_data7         (32'b0),
       .wdt_en_i             (c1_wdt_en_w),
       .bram_cmd_i           (39'b0),
       .bram_valid_i         (1'b0),
       .bram_rdy_o           (),
       .cmp_data             (c1_cmp_data),
       .cmp_data_valid       (c1_cmp_data_valid),
       .cmp_error            (c1_cmp_error),
       .wr_data_counts       (c1_tg_wr_data_counts),
       .rd_data_counts       (c1_tg_rd_data_counts),
       .dq_error_bytelane_cmp (c1_dq_error_bytelane_cmp),
       .error                (c1_tg_compare_error),
       .error_status         (c1_error_status),
       .cumlative_dq_lane_error (c1_cumlative_dq_lane_error),
       .cmd_wdt_err_o         (c1_cmd_wdt_err_w),
       .wr_wdt_err_o          (c1_wr_wdt_err_w),
       .rd_wdt_err_o          (c1_rd_wdt_err_w),
       .mem_pattern_init_done   (c1_mem_pattern_init_done)
       );


   //*****************************************************************
   // Default values are assigned to the debug inputs of the traffic
   // generator
   //*****************************************************************
   assign c0_vio_modify_enable     = 1'b0;
   assign c0_vio_data_mode_value   = 4'b0010;
   assign c0_vio_addr_mode_value   = 3'b011;
   assign c0_vio_instr_mode_value  = 4'b0010;
   assign c0_vio_bl_mode_value     = 2'b10;
   assign c0_vio_fixed_bl_value    = 8'd16;
   assign c0_vio_data_mask_gen     = 1'b0;
   assign c0_vio_pause_traffic     = 1'b0;
   assign c0_vio_fixed_instr_value = 3'b001;
   assign c0_dbg_clear_error       = 1'b0;
   assign c0_po_win_tg_rst         = 1'b0;
   assign c0_vio_tg_rst            = 1'b0;
   assign c0_wdt_en_w              = 1'b1;

   assign c0_dbg_sel_pi_incdec       = 'b0;
   assign c0_dbg_sel_po_incdec       = 'b0;
   assign c0_dbg_pi_f_inc            = 'b0;
   assign c0_dbg_pi_f_dec            = 'b0;
   assign c0_dbg_po_f_inc            = 'b0;
   assign c0_dbg_po_f_dec            = 'b0;
   assign c0_dbg_po_f_stg23_sel      = 'b0;

      
`ifdef SKIP_CALIB
  //***************************************************************************
  // Skip calib test logic
  //***************************************************************************

  reg[3*DQS_WIDTH-1:0]        po_coarse_tap;
  reg[6*DQS_WIDTH-1:0]        po_stg3_taps;
  reg[6*DQS_WIDTH-1:0]        po_stg2_taps;
  reg[6*DQS_WIDTH-1:0]        pi_stg2_taps;
  reg[5*DQS_WIDTH-1:0]        idelay_taps;
  reg[11:0]                   cal_device_temp;


  always @(posedge clk) begin
    // tap values from golden run (factory)
    po_coarse_tap   <= #TCQ 'h2;
    po_stg3_taps    <= #TCQ 'h0D;
    po_stg2_taps    <= #TCQ 'h1D;
    pi_stg2_taps    <= #TCQ 'h1E;
    idelay_taps     <= #TCQ 'h08;
        cal_device_temp <= #TCQ 'h000;
  end

  always @(posedge clk) begin
    if (rst)
      c0_calib_tap_load <= #TCQ 1'b0;
    else if (c0_calib_tap_req)
      c0_calib_tap_load <= #TCQ 1'b1;
  end

  always @(posedge clk) begin
    if (rst) begin
      c0_calib_tap_addr      <= #TCQ 'd0;
      c0_calib_tap_val       <= #TCQ po_coarse_tap[3*c0_calib_tap_addr[6:3]+:3]; //'d1;
      c0_calib_tap_load_done <= #TCQ 1'b0;
    end else if (c0_calib_tap_load) begin
      case (c0_calib_tap_addr[2:0])
        3'b000: begin
          c0_calib_tap_addr[2:0] <= #TCQ 3'b001;
          c0_calib_tap_val       <= #TCQ po_stg3_taps[6*c0_calib_tap_addr[6:3]+:6]; //'d19;
        end
        3'b001: begin
          c0_calib_tap_addr[2:0] <= #TCQ 3'b010;
          c0_calib_tap_val       <= #TCQ po_stg2_taps[6*c0_calib_tap_addr[6:3]+:6]; //'d45;
        end
        3'b010: begin
          c0_calib_tap_addr[2:0] <= #TCQ 3'b011;
          c0_calib_tap_val       <= #TCQ pi_stg2_taps[6*c0_calib_tap_addr[6:3]+:6]; //'d20;
        end
        3'b011: begin
          c0_calib_tap_addr[2:0] <= #TCQ 3'b100;
          c0_calib_tap_val       <= #TCQ idelay_taps[5*c0_calib_tap_addr[6:3]+:5]; //'d1;
        end
        3'b100: begin
          if (c0_calib_tap_addr[6:3] < DQS_WIDTH-1) begin
            c0_calib_tap_addr[2:0] <= #TCQ 3'b000;
            c0_calib_tap_val       <= #TCQ po_coarse_tap[3*(c0_calib_tap_addr[6:3]+1)+:3]; //'d1;
            c0_calib_tap_addr[6:3] <= #TCQ c0_calib_tap_addr[6:3] + 1;
          end else begin
            c0_calib_tap_addr[2:0] <= #TCQ 3'b110;
            c0_calib_tap_val       <= #TCQ cal_device_temp[7:0];
            c0_calib_tap_addr[6:3] <= #TCQ 4'b1111;
          end
        end
        3'b110: begin
            c0_calib_tap_addr[2:0] <= #TCQ 3'b111;
            c0_calib_tap_val       <= #TCQ {4'h0,cal_device_temp[11:8]};
            c0_calib_tap_addr[6:3] <= #TCQ 4'b1111;
        end
        3'b111: begin
            c0_calib_tap_load_done <= #TCQ 1'b1;
        end
      endcase
    end
  end


//****************skip calib test logic end**********************************
`endif    
   //*****************************************************************
   // Default values are assigned to the debug inputs of the traffic
   // generator
   //*****************************************************************
   assign c1_vio_modify_enable     = 1'b0;
   assign c1_vio_data_mode_value   = 4'b0010;
   assign c1_vio_addr_mode_value   = 3'b011;
   assign c1_vio_instr_mode_value  = 4'b0010;
   assign c1_vio_bl_mode_value     = 2'b10;
   assign c1_vio_fixed_bl_value    = 8'd16;
   assign c1_vio_data_mask_gen     = 1'b0;
   assign c1_vio_pause_traffic     = 1'b0;
   assign c1_vio_fixed_instr_value = 3'b001;
   assign c1_dbg_clear_error       = 1'b0;
   assign c1_po_win_tg_rst         = 1'b0;
   assign c1_vio_tg_rst            = 1'b0;
   assign c1_wdt_en_w              = 1'b1;

   assign c1_dbg_sel_pi_incdec       = 'b0;
   assign c1_dbg_sel_po_incdec       = 'b0;
   assign c1_dbg_pi_f_inc            = 'b0;
   assign c1_dbg_pi_f_dec            = 'b0;
   assign c1_dbg_po_f_inc            = 'b0;
   assign c1_dbg_po_f_dec            = 'b0;
   assign c1_dbg_po_f_stg23_sel      = 'b0;

      
`ifdef SKIP_CALIB
  //***************************************************************************
  // Skip calib test logic
  //***************************************************************************

  reg[3*DQS_WIDTH-1:0]        po_coarse_tap;
  reg[6*DQS_WIDTH-1:0]        po_stg3_taps;
  reg[6*DQS_WIDTH-1:0]        po_stg2_taps;
  reg[6*DQS_WIDTH-1:0]        pi_stg2_taps;
  reg[5*DQS_WIDTH-1:0]        idelay_taps;
  reg[11:0]                   cal_device_temp;


  always @(posedge clk) begin
    // tap values from golden run (factory)
    po_coarse_tap   <= #TCQ 'h2;
    po_stg3_taps    <= #TCQ 'h0D;
    po_stg2_taps    <= #TCQ 'h1D;
    pi_stg2_taps    <= #TCQ 'h1E;
    idelay_taps     <= #TCQ 'h08;
        cal_device_temp <= #TCQ 'h000;
  end

  always @(posedge clk) begin
    if (rst)
      c0_calib_tap_load <= #TCQ 1'b0;
    else if (c0_calib_tap_req)
      c0_calib_tap_load <= #TCQ 1'b1;
  end

  always @(posedge clk) begin
    if (rst) begin
      c0_calib_tap_addr      <= #TCQ 'd0;
      c0_calib_tap_val       <= #TCQ po_coarse_tap[3*c0_calib_tap_addr[6:3]+:3]; //'d1;
      c0_calib_tap_load_done <= #TCQ 1'b0;
    end else if (c0_calib_tap_load) begin
      case (c0_calib_tap_addr[2:0])
        3'b000: begin
          c0_calib_tap_addr[2:0] <= #TCQ 3'b001;
          c0_calib_tap_val       <= #TCQ po_stg3_taps[6*c0_calib_tap_addr[6:3]+:6]; //'d19;
        end
        3'b001: begin
          c0_calib_tap_addr[2:0] <= #TCQ 3'b010;
          c0_calib_tap_val       <= #TCQ po_stg2_taps[6*c0_calib_tap_addr[6:3]+:6]; //'d45;
        end
        3'b010: begin
          c0_calib_tap_addr[2:0] <= #TCQ 3'b011;
          c0_calib_tap_val       <= #TCQ pi_stg2_taps[6*c0_calib_tap_addr[6:3]+:6]; //'d20;
        end
        3'b011: begin
          c0_calib_tap_addr[2:0] <= #TCQ 3'b100;
          c0_calib_tap_val       <= #TCQ idelay_taps[5*c0_calib_tap_addr[6:3]+:5]; //'d1;
        end
        3'b100: begin
          if (c0_calib_tap_addr[6:3] < DQS_WIDTH-1) begin
            c0_calib_tap_addr[2:0] <= #TCQ 3'b000;
            c0_calib_tap_val       <= #TCQ po_coarse_tap[3*(c0_calib_tap_addr[6:3]+1)+:3]; //'d1;
            c0_calib_tap_addr[6:3] <= #TCQ c0_calib_tap_addr[6:3] + 1;
          end else begin
            c0_calib_tap_addr[2:0] <= #TCQ 3'b110;
            c0_calib_tap_val       <= #TCQ cal_device_temp[7:0];
            c0_calib_tap_addr[6:3] <= #TCQ 4'b1111;
          end
        end
        3'b110: begin
            c0_calib_tap_addr[2:0] <= #TCQ 3'b111;
            c0_calib_tap_val       <= #TCQ {4'h0,cal_device_temp[11:8]};
            c0_calib_tap_addr[6:3] <= #TCQ 4'b1111;
        end
        3'b111: begin
            c0_calib_tap_load_done <= #TCQ 1'b1;
        end
      endcase
    end
  end


//****************skip calib test logic end**********************************
`endif    

endmodule


