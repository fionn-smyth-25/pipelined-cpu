#create a new project
create_project p_cpu ./vivado -part xc7a35tcpg236-1

#add files
add_files [glob ./src/*.v]
add_files -fileset sim_1 ./src/testbenches/cpu_tb.sv

#set testbench as top module
set_property top tb_cpu [get_filesets sim_1]

#run
launch_simulation
run all
