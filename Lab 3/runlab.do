# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.

vlog "./alu.sv"
vlog "./alu_1bit.sv"
vlog "./clockDivider.sv"
vlog "./ControlSignal.sv"
vlog "./CPU.sv"
vlog "./D_FF.sv"
vlog "./datamem.sv"
vlog "./Datapath.sv"
vlog "./decoder2_4.sv"
vlog "./decoder3_8.sv"
vlog "./decoder5_32.sv"
vlog "./FlagReg.sv"
vlog "./fullAdder.sv"
vlog "./InstructionFetch.sv"
vlog "./instructmem.sv"
vlog "./math.sv"
vlog "./muxes.sv"
vlog "./ProgramCounter.sv"
vlog "./regfile.sv"
vlog "./register64.sv"
vlog "./SignExtend.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work cpu_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do cpu_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
