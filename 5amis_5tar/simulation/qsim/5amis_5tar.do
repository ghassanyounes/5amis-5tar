onerror {quit -f}
vlib work
vlog -work work top_5amis_5tar.vo
vlog -work work 5amis_5tar.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.top_5amis_5tar_vlg_vec_tst
vcd file -direction 5amis_5tar.msim.vcd
vcd add -internal top_5amis_5tar_vlg_vec_tst/*
vcd add -internal top_5amis_5tar_vlg_vec_tst/i1/*
add wave /*
run -all
