
#Filename: question1.tcl

# Simulator Instance Creation
set ns_ [new Simulator]

#Trace File creation
set tracefile [open sample1.tr w]
#Tracing all the events and cofiguration
$ns_ trace-all $tracefile

Mac/802_11 set dataRate_ 2.0e6
#disable RTS for 802.11 MAC
Mac/802_11 set RTSThreshold_   3000
# Define options
set val(chan) Channel/WirelessChannel    ;# channel type
set val(prop) Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             49                     	   ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol
set val(x)              490   			   ;# X dimension of topography
set val(y)              490   			   ;# Y dimension of topography
set val(cp)             "./temp"  
set val(stop)			25.0			   ;# time of simulation end

# set up topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y) 

# general operational descriptor- storing the hop details in the network
create-god $val(nn)

# configure the nodes
        $ns_ node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace OFF \
			 -movementTrace OFF

#  Create the specified number of nodes [$val(nn)] and "attach" them
#  to the channel. 

for {set i 0} {$i < $val(nn) } {incr i} {
	set node_($i) [$ns_ node]	
	$node_($i) random-motion 0
	$node_($i) set X_ [expr ($i/7)*70+15]
	$node_($i) set Y_ [expr ($i%7)*70+15]
	$node_($i) set Z_ 0 		;# disable random motion
}

# 
# Define node movement model
#
puts "Loading connection pattern..."
source $val(cp)

proc stop {} {
    global ns_ tracefile
    $ns_ flush-trace
    close $tracefile 
}

$ns_ at  $val(stop).0001 "stop"
$ns_ at  $val(stop).0002 "puts \"NS EXITING...\" ; $ns_ halt"

puts $tracefile "M 0.0 nn $val(nn) x $val(x) y $val(y) rp $val(rp)"
# puts $tracefile "M 0.0 sc $val(sc) cp $val(cp) seed $val(seed)"
puts $tracefile "M 0.0 prop $val(prop) ant $val(ant)"

puts "Starting Simulation..."
$ns_ run







