
rm -rf work
vlib work

echo ""
echo "Compiling hdlc"
vlog +cover=bcefsx -sv ../rtl/hdlc.sv ../rtl/AddressIF.sv ../rtl/RxController.sv ../rtl/RxChannel.sv ../rtl/RxBuff.sv ../rtl/RxFCS.sv ../rtl/TxController.sv ../rtl/TxChannel.sv ../rtl/TxBuff.sv ../rtl/TxFCS.sv
vlog +cover=bcefsx -sv in_hdlc.sv test_hdlc.sv testPr_hdlc.sv bind_hdlc.sv assertions_hdlc.sv

echo ""
echo "Simulating hdlc"
vsim -assertdebug -c -coverage -voptargs="+acc" test_hdlc bind_hdlc -do "
log -r *
run -all; 
coverage report -memory -cvg -details -file coverage_rep.txt;
exit"
