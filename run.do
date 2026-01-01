vlib work
vlog +define+SIM -f file.list +cover -covercells
##vsim -voptargs=+acc work.APB_TOP_tb -cover
vsim -voptargs=+acc work.APB_TOP_tb -cover -classdebug -uvmcontrol=all +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=apb_wrapper_test

do wave.do
##coverage save APB_TOP_tb.ucdb -onexit 
run -all
##quit -sim
##vcover report APB_TOP_tb.ucdb -details -annotate -all -output top_tbCOV.txt