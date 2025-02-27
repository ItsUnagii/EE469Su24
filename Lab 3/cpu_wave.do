onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu_tb/clk
add wave -noupdate /cpu_tb/reset
add wave -noupdate -radix decimal /cpu_tb/dut/instFetch/PC/out
add wave -noupdate /cpu_tb/dut/instFetch/InstructionMemory/instruction
add wave -noupdate -expand -group Flags /cpu_tb/dut/signal/NegativeFlag
add wave -noupdate -expand -group Flags /cpu_tb/dut/signal/CoutFlag
add wave -noupdate -expand -group Flags /cpu_tb/dut/signal/OverflowFlag
add wave -noupdate -expand -group Flags /cpu_tb/dut/signal/ZeroFlag
add wave -noupdate -radix binary -childformat {{{/cpu_tb/dut/data/TheRegisterFile/registerData[31]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[30]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[29]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[28]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[27]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[26]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[25]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[24]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[23]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[22]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[21]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[20]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[19]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[18]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[17]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[16]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[15]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[14]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[13]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[12]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[11]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[10]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[9]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[8]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[7]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[6]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[5]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[4]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[3]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[2]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[1]} -radix decimal} {{/cpu_tb/dut/data/TheRegisterFile/registerData[0]} -radix decimal}} -expand -subitemconfig {{/cpu_tb/dut/data/TheRegisterFile/registerData[31]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[30]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[29]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[28]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[27]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[26]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[25]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[24]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[23]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[22]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[21]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[20]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[19]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[18]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[17]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[16]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[15]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[14]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[13]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[12]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[11]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[10]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[9]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[8]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[7]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[6]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[5]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[4]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[3]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[2]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[1]} {-radix decimal} {/cpu_tb/dut/data/TheRegisterFile/registerData[0]} {-radix decimal}} /cpu_tb/dut/data/TheRegisterFile/registerData
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28926257 ps} 0}
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
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {132890626 ps}
