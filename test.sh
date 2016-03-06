#!/bin/bash
CWD='temp'
pkt=(100 300 500 1000)
rate=(100.0 33.3 20.0 10.0)
resTh=(RTS-100-throughput.txt RTS-300-throughput.txt RTS-500-throughput.txt RTS-1000-throughput.txt)
resDe=(RTS-100-latency.txt RTS-300-latency.txt RTS-500-latency.txt RTS-1000-latency.txt)
resDeNew=(RTS-100-latencyNew.txt RTS-300-latencyNew.txt RTS-500-latencyNew.txt RTS-1000-latencyNew.txt)
resNoTh=(NORTS-100-throughput.txt NORTS-300-throughput.txt NORTS-500-throughput.txt NORTS-1000-throughput.txt)
resNoDe=(NORTS-100-latency.txt NORTS-300-latency.txt NORTS-500-latency.txt NORTS-1000-latency.txt)
resNoDeNew=(NORTS-100-latencyNew.txt NORTS-300-latencyNew.txt NORTS-500-latencyNew.txt NORTS-1000-latencyNew.txt)
#=======================delete old files=========================================
for i in 0 1 2 3
do
	rm ${resTh[$i]}
	rm ${resDe[$i]}
	rm ${resNoTh[$i]}
	rm ${resNoDe[$i]}
	rm ${resDeNew[$i]}
	rm ${resNoDeNew[$i]}
done
#======================Simulation start============================================
for loop in 0 1 2 3
do
	for pair in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
	do   
		for seed in 1.0 10.0 100.0 1000.0 10000.0 100000.0 1000000.0 17560000.0 100000000.0 1000000000.0
		do  
			ns newcbr.tcl -type cbr -nn 49 -seed $seed -mc $pair -pktsize ${pkt[$loop]} -rate ${rate[$loop]} > "$CWD"
			ns question1.tcl
			awk -f throughput1.awk pktsize=${pkt[$loop]} sample1.tr >> ${resTh[$loop]}
			# awk '$4 == "AGT"' sample1.tr > latency.tr
			awk -f delay.awk sample1.tr >> ${resDe[$loop]}
			awk -f Avg_Del.awk sample1.tr >> ${resDeNew[$loop]}
			ns question2.tcl
			awk -f throughput1.awk pktsize=${pkt[$loop]} sample1.tr >> ${resNoTh[$loop]}
			# awk '$4 == "AGT"' sample1.tr > latency.tr
			awk -f delay.awk sample1.tr >> ${resNoDe[$loop]}
			awk -f Avg_Del.awk sample1.tr >> ${resNoDeNew[$loop]}
		done
		echo "pair $pair fininshed\n"
		echo "  " >> ${resTh[$loop]}
		echo "  " >> ${resDe[$loop]}
		echo "  " >> ${resDeNew[$loop]}
		echo "  " >> ${resNoTh[$loop]}
		echo "  " >> ${resNoDe[$loop]}
		echo "  " >> ${resNoDeNew[$loop]}
	done
	echo "loop $loop finished" 
done
echo "finished!!!!"