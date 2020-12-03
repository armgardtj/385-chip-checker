transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Classes/ECE385/chip_checker {D:/Classes/ECE385/chip_checker/HexDriver.sv}
vlog -sv -work work +incdir+D:/Classes/ECE385/chip_checker {D:/Classes/ECE385/chip_checker/chip_checker.sv}
vlog -sv -work work +incdir+D:/Classes/ECE385/chip_checker {D:/Classes/ECE385/chip_checker/chip_checker_state.sv}
vlog -sv -work work +incdir+D:/Classes/ECE385/chip_checker {D:/Classes/ECE385/chip_checker/chip_7402.sv}

vlog -sv -work work +incdir+D:/Classes/ECE385/chip_checker {D:/Classes/ECE385/chip_checker/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns
