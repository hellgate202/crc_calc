onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_crc/DUT/clk_i
add wave -noupdate /tb_crc/DUT/rst_i
add wave -noupdate /tb_crc/DUT/soft_reset_i
add wave -noupdate /tb_crc/DUT/valid_i
add wave -noupdate -radix hexadecimal /tb_crc/DUT/data_i
add wave -noupdate -radix hexadecimal /tb_crc/DUT/crc_o
add wave -noupdate -radix hexadecimal /tb_crc/DUT/crc_next
add wave -noupdate -radix hexadecimal /tb_crc/DUT/crc_prev
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31526 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 559
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
WaveRestoreZoom {0 ps} {456750 ps}
