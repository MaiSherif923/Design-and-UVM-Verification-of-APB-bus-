onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /slave_tb/ADDR_WIDTH
add wave -noupdate /slave_tb/DATA_WIDTH
add wave -noupdate /slave_tb/MEM_DEPTH
add wave -noupdate /slave_tb/tests
add wave -noupdate /slave_tb/PRESETn
add wave -noupdate /slave_tb/DUT/cs
add wave -noupdate /slave_tb/DUT/ns
add wave -noupdate /slave_tb/PCLK
add wave -noupdate /slave_tb/PADDR
add wave -noupdate /slave_tb/PSEL
add wave -noupdate /slave_tb/PENABLE
add wave -noupdate /slave_tb/PWRITE
add wave -noupdate /slave_tb/PWDATA
add wave -noupdate /slave_tb/PREADY_dut
add wave -noupdate /slave_tb/PREADY_gm
add wave -noupdate /slave_tb/PSLVERR_dut
add wave -noupdate /slave_tb/PRDATA_dut
add wave -noupdate /slave_tb/PSLVERR_gm
add wave -noupdate /slave_tb/PRDATA_gm
add wave -noupdate /slave_tb/PSTRB
add wave -noupdate /slave_tb/PPROT
add wave -noupdate /slave_tb/i
add wave -noupdate /slave_tb/DUT/mem
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {583 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 100
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {482 ns} {727 ns}
