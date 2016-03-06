BEGIN{
}
{
if ($2 != "-t") {
	event = $1
	time = $2
	if (event == "+" || event == "-") node_id = $3
	pkt_id = $6
	pkt_size = $8
	flow_t = $5
	level = $4
	}

if (level == "AGT" && sendTime[pkt_id] == 0 && event == "s" ) {
	if (time < startTime) {
		startTime = time
		}
	sendTime[pkt_id] = time
	this_flow = flow_t
	}


if (level == "AGT" &&event == "r" ) {
		if (time > stopTime) {
			stopTime = time
			}
		
		recvdSize += pkt_size
		
		recvTime[pkt_id] = time
	}
}
END{
delay = avg_delay = recvdNum = 0
for (i in recvTime) {
	if (sendTime[i] == 0) {
		printf("\nError in delay.awk: receiving a packet that wasn't sent %g\n",i)
		}
	delay += recvTime[i] - sendTime[i]
	recvdNum ++
	}
	if (recvdNum != 0) {
		avg_delay = delay / recvdNum
		}
	else {
	     avg_delay = 0
   	}
printf("%g\n", avg_delay*1000)
}
