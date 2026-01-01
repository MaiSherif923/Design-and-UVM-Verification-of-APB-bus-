vlib work
vlog +define+SIM slave_tb.sv APB_Slave_GM.sv APB_slave_new.sv +cover -covercells
vsim -voptargs=+acc work.slave_tb -cover
do wave_slave.do
##vsim -voptargs=+acc work.slave_tb -cover -classdebug -uvmcontrol=all +UVM_VERBOSITY=UVM_LOW
run -all