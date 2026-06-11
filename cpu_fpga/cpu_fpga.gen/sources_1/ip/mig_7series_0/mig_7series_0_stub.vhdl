-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (lin64) Build 6299465 Fri Nov 14 12:34:56 MST 2025
-- Date        : Tue May 26 19:57:23 2026
-- Host        : death running 64-bit CachyOS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/boysanic/git/sanic-cpu-32/cpu_fpga/cpu_fpga.gen/sources_1/ip/mig_7series_0/mig_7series_0_stub.vhdl
-- Design      : mig_7series_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k480tffg1156-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mig_7series_0 is
  Port ( 
    c0_ddr3_dq : inout STD_LOGIC_VECTOR ( 63 downto 0 );
    c0_ddr3_dqs_n : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    c0_ddr3_dqs_p : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    c0_ddr3_addr : out STD_LOGIC_VECTOR ( 15 downto 0 );
    c0_ddr3_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    c0_ddr3_ras_n : out STD_LOGIC;
    c0_ddr3_cas_n : out STD_LOGIC;
    c0_ddr3_we_n : out STD_LOGIC;
    c0_ddr3_reset_n : out STD_LOGIC;
    c0_ddr3_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    c0_ddr3_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    c0_ddr3_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    c0_ddr3_cs_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    c0_ddr3_dm : out STD_LOGIC_VECTOR ( 7 downto 0 );
    c0_ddr3_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    c0_sys_clk_p : in STD_LOGIC;
    c0_sys_clk_n : in STD_LOGIC;
    clk_ref_p : in STD_LOGIC;
    clk_ref_n : in STD_LOGIC;
    c0_app_addr : in STD_LOGIC_VECTOR ( 29 downto 0 );
    c0_app_cmd : in STD_LOGIC_VECTOR ( 2 downto 0 );
    c0_app_en : in STD_LOGIC;
    c0_app_wdf_data : in STD_LOGIC_VECTOR ( 511 downto 0 );
    c0_app_wdf_end : in STD_LOGIC;
    c0_app_wdf_mask : in STD_LOGIC_VECTOR ( 63 downto 0 );
    c0_app_wdf_wren : in STD_LOGIC;
    c0_app_rd_data : out STD_LOGIC_VECTOR ( 511 downto 0 );
    c0_app_rd_data_end : out STD_LOGIC;
    c0_app_rd_data_valid : out STD_LOGIC;
    c0_app_rdy : out STD_LOGIC;
    c0_app_wdf_rdy : out STD_LOGIC;
    c0_app_sr_req : in STD_LOGIC;
    c0_app_ref_req : in STD_LOGIC;
    c0_app_zq_req : in STD_LOGIC;
    c0_app_sr_active : out STD_LOGIC;
    c0_app_ref_ack : out STD_LOGIC;
    c0_app_zq_ack : out STD_LOGIC;
    c0_ui_clk : out STD_LOGIC;
    c0_ui_clk_sync_rst : out STD_LOGIC;
    c0_init_calib_complete : out STD_LOGIC;
    c0_device_temp : out STD_LOGIC_VECTOR ( 11 downto 0 );
    c1_ddr3_dq : inout STD_LOGIC_VECTOR ( 7 downto 0 );
    c1_ddr3_dqs_n : inout STD_LOGIC_VECTOR ( 0 to 0 );
    c1_ddr3_dqs_p : inout STD_LOGIC_VECTOR ( 0 to 0 );
    c1_ddr3_addr : out STD_LOGIC_VECTOR ( 13 downto 0 );
    c1_ddr3_ba : out STD_LOGIC_VECTOR ( 2 downto 0 );
    c1_ddr3_ras_n : out STD_LOGIC;
    c1_ddr3_cas_n : out STD_LOGIC;
    c1_ddr3_we_n : out STD_LOGIC;
    c1_ddr3_reset_n : out STD_LOGIC;
    c1_ddr3_ck_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    c1_ddr3_ck_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    c1_ddr3_cke : out STD_LOGIC_VECTOR ( 0 to 0 );
    c1_ddr3_cs_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    c1_ddr3_dm : out STD_LOGIC_VECTOR ( 0 to 0 );
    c1_ddr3_odt : out STD_LOGIC_VECTOR ( 0 to 0 );
    c1_sys_clk_p : in STD_LOGIC;
    c1_sys_clk_n : in STD_LOGIC;
    c1_app_addr : in STD_LOGIC_VECTOR ( 27 downto 0 );
    c1_app_cmd : in STD_LOGIC_VECTOR ( 2 downto 0 );
    c1_app_en : in STD_LOGIC;
    c1_app_wdf_data : in STD_LOGIC_VECTOR ( 63 downto 0 );
    c1_app_wdf_end : in STD_LOGIC;
    c1_app_wdf_mask : in STD_LOGIC_VECTOR ( 7 downto 0 );
    c1_app_wdf_wren : in STD_LOGIC;
    c1_app_rd_data : out STD_LOGIC_VECTOR ( 63 downto 0 );
    c1_app_rd_data_end : out STD_LOGIC;
    c1_app_rd_data_valid : out STD_LOGIC;
    c1_app_rdy : out STD_LOGIC;
    c1_app_wdf_rdy : out STD_LOGIC;
    c1_app_sr_req : in STD_LOGIC;
    c1_app_ref_req : in STD_LOGIC;
    c1_app_zq_req : in STD_LOGIC;
    c1_app_sr_active : out STD_LOGIC;
    c1_app_ref_ack : out STD_LOGIC;
    c1_app_zq_ack : out STD_LOGIC;
    c1_ui_clk : out STD_LOGIC;
    c1_ui_clk_sync_rst : out STD_LOGIC;
    c1_init_calib_complete : out STD_LOGIC;
    c1_device_temp : out STD_LOGIC_VECTOR ( 11 downto 0 );
    sys_rst : in STD_LOGIC
  );

end mig_7series_0;

architecture stub of mig_7series_0 is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "c0_ddr3_dq[63:0],c0_ddr3_dqs_n[7:0],c0_ddr3_dqs_p[7:0],c0_ddr3_addr[15:0],c0_ddr3_ba[2:0],c0_ddr3_ras_n,c0_ddr3_cas_n,c0_ddr3_we_n,c0_ddr3_reset_n,c0_ddr3_ck_p[0:0],c0_ddr3_ck_n[0:0],c0_ddr3_cke[0:0],c0_ddr3_cs_n[0:0],c0_ddr3_dm[7:0],c0_ddr3_odt[0:0],c0_sys_clk_p,c0_sys_clk_n,clk_ref_p,clk_ref_n,c0_app_addr[29:0],c0_app_cmd[2:0],c0_app_en,c0_app_wdf_data[511:0],c0_app_wdf_end,c0_app_wdf_mask[63:0],c0_app_wdf_wren,c0_app_rd_data[511:0],c0_app_rd_data_end,c0_app_rd_data_valid,c0_app_rdy,c0_app_wdf_rdy,c0_app_sr_req,c0_app_ref_req,c0_app_zq_req,c0_app_sr_active,c0_app_ref_ack,c0_app_zq_ack,c0_ui_clk,c0_ui_clk_sync_rst,c0_init_calib_complete,c0_device_temp[11:0],c1_ddr3_dq[7:0],c1_ddr3_dqs_n[0:0],c1_ddr3_dqs_p[0:0],c1_ddr3_addr[13:0],c1_ddr3_ba[2:0],c1_ddr3_ras_n,c1_ddr3_cas_n,c1_ddr3_we_n,c1_ddr3_reset_n,c1_ddr3_ck_p[0:0],c1_ddr3_ck_n[0:0],c1_ddr3_cke[0:0],c1_ddr3_cs_n[0:0],c1_ddr3_dm[0:0],c1_ddr3_odt[0:0],c1_sys_clk_p,c1_sys_clk_n,c1_app_addr[27:0],c1_app_cmd[2:0],c1_app_en,c1_app_wdf_data[63:0],c1_app_wdf_end,c1_app_wdf_mask[7:0],c1_app_wdf_wren,c1_app_rd_data[63:0],c1_app_rd_data_end,c1_app_rd_data_valid,c1_app_rdy,c1_app_wdf_rdy,c1_app_sr_req,c1_app_ref_req,c1_app_zq_req,c1_app_sr_active,c1_app_ref_ack,c1_app_zq_ack,c1_ui_clk,c1_ui_clk_sync_rst,c1_init_calib_complete,c1_device_temp[11:0],sys_rst";
begin
end;
