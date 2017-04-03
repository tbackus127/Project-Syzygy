# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config  -ruleid {1}  -string {{add_files}}  -suppress 
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir G:/Development/FPGA/SyzygyB100/src/SyzygyB100.cache/wt [current_project]
set_property parent.project_path G:/Development/FPGA/SyzygyB100/src/SyzygyB100.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {
  G:/Development/FPGA/SyzygyB100/src/SyzygyB100.srcs/sources_1/new/Mux2to1.v
  G:/Development/FPGA/SyzygyB100/src/SyzygyB100.srcs/sources_1/new/Reverser16B.v
  G:/Development/FPGA/SyzygyB100/src/SyzygyB100.srcs/sources_1/new/BarrelShifter16B.v
  G:/Development/FPGA/SyzygyB100/src/SyzygyB100.srcs/sources_1/new/ControlShifter.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc G:/Development/FPGA/SyzygyB100/src/constr/Basys3_Master.xdc
set_property used_in_implementation false [get_files G:/Development/FPGA/SyzygyB100/src/constr/Basys3_Master.xdc]


synth_design -top ControlShifter -part xc7a35tcpg236-1


write_checkpoint -force -noxdef ControlShifter.dcp

catch { report_utilization -file ControlShifter_utilization_synth.rpt -pb ControlShifter_utilization_synth.pb }