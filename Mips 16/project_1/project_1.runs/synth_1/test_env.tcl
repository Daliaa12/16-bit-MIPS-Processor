# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {C:/Users/dalia/OneDrive/Desktop/AC MIPS 16/LAB4/project_1/project_1.cache/wt} [current_project]
set_property parent.project_path {C:/Users/dalia/OneDrive/Desktop/AC MIPS 16/LAB4/project_1/project_1.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Users/dalia/OneDrive/Desktop/AC MIPS 16/LAB4/project_1/project_1.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  {C:/Users/dalia/OneDrive/Desktop/AC MIPS 16/LAB4/project_1/project_1.srcs/sources_1/new/REG_FILE.vhd}
  C:/Users/dalia/OneDrive/Desktop/AC/SSD.vhd
  C:/Users/dalia/OneDrive/Desktop/AC/MPG.vhd
  {C:/Users/dalia/OneDrive/Desktop/AC MIPS 16/LAB4/project_1/project_1.srcs/sources_1/new/MainControl.vhd}
  {C:/Users/dalia/OneDrive/Desktop/AC MIPS 16/LAB4/project_1/project_1.srcs/sources_1/new/InstructionF.vhd}
  {C:/Users/dalia/OneDrive/Desktop/AC MIPS 16/LAB4/project_1/project_1.srcs/sources_1/new/IDD.vhd}
  {C:/Users/dalia/OneDrive/Desktop/AC MIPS 16/LAB4/project_1/project_1.srcs/sources_1/new/EX.vhd}
  {C:/Users/dalia/OneDrive/Desktop/AC MIPS 16/LAB4/project_1/project_1.srcs/sources_1/new/MEM.vhd}
  {C:/Users/dalia/OneDrive/Desktop/AC MIPS 16/LAB4/project_1/project_1.srcs/sources_1/new/test_env.vhd}
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/dalia/OneDrive/Desktop/AC/Basys3_test_env.xdc
set_property used_in_implementation false [get_files C:/Users/dalia/OneDrive/Desktop/AC/Basys3_test_env.xdc]


synth_design -top test_env -part xc7a35tcpg236-1


write_checkpoint -force -noxdef test_env.dcp

catch { report_utilization -file test_env_utilization_synth.rpt -pb test_env_utilization_synth.pb }