onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /APB_TOP_tb/wrapper_if/PCLK
add wave -noupdate /APB_TOP_tb/wrapper_if/PRESETn
add wave -noupdate /APB_TOP_tb/wrapper_if/BADDR
add wave -noupdate /APB_TOP_tb/wrapper_if/BWRITE
add wave -noupdate /APB_TOP_tb/wrapper_if/start_transfer
add wave -noupdate /APB_TOP_tb/wrapper_if/BWDATA
add wave -noupdate /APB_TOP_tb/wrapper_if/BERR
add wave -noupdate /APB_TOP_tb/wrapper_if/BRDATA_gm
add wave -noupdate -expand -group PADDR /APB_TOP_tb/wrapper_if/PADDR
add wave -noupdate -expand -group PADDR /APB_TOP_tb/wrapper_if/PADDR_gm
add wave -noupdate -expand -group PSEL /APB_TOP_tb/wrapper_if/PSEL
add wave -noupdate -expand -group PSEL /APB_TOP_tb/wrapper_if/PSEL_gm
add wave -noupdate -expand -group PENABLE /APB_TOP_tb/wrapper_if/PENABLE
add wave -noupdate -expand -group PENABLE /APB_TOP_tb/wrapper_if/PENABLE_gm
add wave -noupdate -expand -group PWRITE /APB_TOP_tb/wrapper_if/PWRITE
add wave -noupdate -expand -group PWRITE /APB_TOP_tb/wrapper_if/PWRITE_gm
add wave -noupdate -expand -group PWDATA /APB_TOP_tb/wrapper_if/PWDATA
add wave -noupdate -expand -group PWDATA /APB_TOP_tb/wrapper_if/PWDATA_gm
add wave -noupdate -expand -group PREADY /APB_TOP_tb/wrapper_if/PREADY
add wave -noupdate -expand -group PREADY /APB_TOP_tb/wrapper_if/PREADY_gm
add wave -noupdate -expand -group PSLEVRR /APB_TOP_tb/wrapper_if/PSLVERR
add wave -noupdate -expand -group PSLEVRR /APB_TOP_tb/wrapper_if/PSLVERR_gm
add wave -noupdate -expand -group BRDATA /APB_TOP_tb/wrapper_if/PRDATA
add wave -noupdate -expand -group BRDATA /APB_TOP_tb/wrapper_if/BRDATA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {988 ns} 0}
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
WaveRestoreZoom {973 ns} {1003 ns}
