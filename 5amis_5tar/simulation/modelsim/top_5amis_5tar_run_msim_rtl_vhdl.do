transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/imem.vhd}
vcom -93 -work work {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/inst_name.vhd}
vcom -93 -work work {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/control_unit.vhd}
vlib clock
vmap clock clock
vcom -93 -work clock {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/clock.vhd}
vlib displays
vmap displays displays
vcom -93 -work displays {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/displays.vhd}
vlib commonmods
vmap commonmods commonmods
vcom -93 -work commonmods {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/common_mods.vhd}
vcom -93 -work work {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/alu.vhd}
vcom -93 -work work {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/pc.vhd}
vcom -93 -work work {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/imm_gen.vhd}
vcom -93 -work work {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/reg_file.vhd}
vcom -93 -work work {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/branch_comp.vhd}
vcom -93 -work work {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/ram_lpm.vhd}
vcom -93 -work work {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/top_5amis_5tar.vhd}
vcom -93 -work work {C:/Users/jakor/OneDrive/Documents/DigiPen_S8/ECE380/Project/5amis-5tar/5amis_5tar/LCD_Message_fmt.vhd}

