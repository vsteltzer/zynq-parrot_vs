set project_name $::env(BASENAME)_bd_proj
set bd_name $::env(BASENAME)_bd_1

# Create project
create_project -force ${project_name} [pwd] -part xczu9eg-ffvb1156-2-e

# Create Block Design
create_bd_design ${bd_name}
update_compile_order -fileset sources_1
startgroup
  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0 ]
  set_property -dict [ list \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__SAXIGP2__DATA_WIDTH {64} \
   CONFIG.PSU__USE__M_AXI_GP0 {1} \
   CONFIG.PSU__USE__M_AXI_GP1 {1} \
   CONFIG.PSU__USE__M_AXI_GP2 {0} \
   CONFIG.PSU__USE__S_AXI_GP2 {1} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {32} \
   CONFIG.PSU__MAXIGP1__DATA_WIDTH {32} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \   
   CONFIG.PSU__SAXIGP2__DATA_WIDTH {64} \   
 ] $zynq_ultra_ps_e_0
endgroup
open_bd_design ${project_name}.srcs/sources_1/bd/${bd_name}/${bd_name}.bd}
set_property  ip_repo_paths  fpga_build [current_project]
update_ip_catalog

# Create BRAM
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 axi_bram_ctrl_0_bram
set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]
set_property -dict [ list \
   CONFIG.ECC_TYPE {0} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.SINGLE_PORT_BRAM {1} \
] $axi_bram_ctrl_0
apply_bd_automation -rule xilinx.com:bd_rule:bram_cntlr -config {BRAM "Auto"} [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
endgroup

# Integrate Black Parrot IP
startgroup
create_bd_cell -type ip -vlnv user.org:user:top:1.0 top_0
endgroup

# Create Smart Connect & Interconnect Modules 
# m00_axi of blackparrot cant use smartconnect for some reason, gets following implementation error:
# [Opt 31-67] Problem: A LUT3 cell in the design is missing a connection on input pin I1, which is used by the LUT equation. 
# This pin has either been left unconnected in the design or the connection was removed due to the trimming of unused logic. 
# The LUT cell name is: blackparrot_bd_1_i/smartconnect_2/inst/s00_entry_pipeline/s00_mmu/inst/ar_sreg/m_vector_i[1137]_i_1.

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_1
endgroup
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_2
endgroup
set_property -dict [list CONFIG.NUM_SI {1}] [get_bd_cells smartconnect_0]
set_property -dict [list CONFIG.NUM_SI {1}] [get_bd_cells smartconnect_1]
set_property -dict [list CONFIG.NUM_SI {1}] [get_bd_cells smartconnect_2]


# Connect PS, PL and BRAM
connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD] [get_bd_intf_pins smartconnect_0/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins top_0/s00_axi]
connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM1_FPD] [get_bd_intf_pins smartconnect_1/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_1/M00_AXI] [get_bd_intf_pins top_0/s01_axi]
connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD] [get_bd_intf_pins smartconnect_2/M00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_2/S00_AXI] [get_bd_intf_pins top_0/m00_axi]
connect_bd_intf_net [get_bd_intf_pins top_0/m01_axi] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]

# Connect reset network
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins top_0/aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins smartconnect_0/aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins smartconnect_1/aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins smartconnect_2/aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn]
endgroup

# Connect clocks
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (20 MHz)" }  [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (20 MHz)" }  [get_bd_pins zynq_ultra_ps_e_0/maxihpm1_fpd_aclk]
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (20 MHz)" }  [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk]
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/zynq_ultra_ps_e_0/pl_clk0 (20 MHz)" }  [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins /zynq_ultra_ps_e_0/pl_resetn0] [get_bd_pins proc_sys_reset_0/ext_reset_in]
endgroup
connect_bd_net [get_bd_pins /axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]
connect_bd_net [get_bd_pins /top_0/aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0]

# Assign addresses
create_bd_addr_seg -range 0x00002000 -offset 0x10000000 [get_bd_addr_spaces top_0/m01_axi] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
assign_bd_address
# with other versions of vivado, it may have different names for the slave segment
# in the gui you can open the address editor, right click on the interface (s00_axi or s01_axi)
# and select "Address Segment Properties..." to see what name to use in these commands.
set_property offset 0x1000000000 [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_top_0_reg0}]
set_property offset 0x5000000000 [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_top_0_reg04}]
set_property range 4K [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_top_0_reg0}]
set_property range 1G [get_bd_addr_segs {zynq_ultra_ps_e_0/Data/SEG_top_0_reg04}]

# Validate, wrapp and save
validate_bd_design
make_wrapper -files [get_files ${project_name}.srcs/sources_1/bd/${bd_name}/${bd_name}.bd] -top
add_files -norecurse ${project_name}.srcs/sources_1/bd/${bd_name}/hdl/${bd_name}_wrapper.v
delete_bd_objs [get_bd_nets reset_rtl_0_1] [get_bd_ports reset_rtl_0]
save_bd_design

# change this to a 0 to have it stop before synthesis and implementation
# so you can inspect the design with the GUI

if {0} {
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
}

puts "Completed. Type start_gui to enter vivado GUI; quit to exit"
