onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/Clk
add wave -noupdate /testbench/SW
add wave -noupdate /testbench/Run
add wave -noupdate /testbench/Reset
add wave -noupdate /testbench/HEX0
add wave -noupdate /testbench/HEX1
add wave -noupdate /testbench/HEX2
add wave -noupdate /testbench/HEX3
add wave -noupdate /testbench/HEX4
add wave -noupdate /testbench/HEX5
add wave -noupdate /testbench/Pin13
add wave -noupdate /testbench/Pin12
add wave -noupdate /testbench/Pin11
add wave -noupdate /testbench/Pin10
add wave -noupdate /testbench/Pin9
add wave -noupdate /testbench/Pin8
add wave -noupdate /testbench/Pin6
add wave -noupdate /testbench/Pin5
add wave -noupdate /testbench/Pin4
add wave -noupdate /testbench/Pin3
add wave -noupdate /testbench/Pin2
add wave -noupdate /testbench/Pin1
add wave -noupdate /testbench/ErrorCnt
add wave -noupdate -expand /testbench/chip_checker0/done
add wave -noupdate /testbench/chip_checker0/chip_checker_state0/State
add wave -noupdate /testbench/chip_checker0/chip_Quad_2_input_NAND0/State
add wave -noupdate /testbench/chip_checker0/RSLT
add wave -noupdate /testbench/chip_checker0/RSLT_0
add wave -noupdate /testbench/chip_checker0/LD_RSLT
add wave -noupdate /testbench/chip_checker0/Start_Check
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {255694 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 240
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {4947115 ps}
