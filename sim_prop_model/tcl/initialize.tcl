set ns_	[new Simulator]
set chan_	[new $opt(chan)]
set topo_	[new Topography]

#set basic packet tracing
set tracefd     [open "trace.tr" w]
$ns_ trace-all 	$tracefd

#create god object
set god_	[create-god $opt(numOfNodes)]

# create topology object
$topo_ load_flatgrid $opt(width) $opt(height)

# general node configuration

if { [info exists opt(propInstance)] } {
	$ns_ node-config -propInstance $opt(propInstance) 
} else {
	$ns_ node-config -propType $opt(prop) 
}



$ns_ node-config \
	-adhocRouting $opt(routing) \
	-llType $opt(linkLayer) \
	-macType $opt(macLayer) \
	-ifqType $opt(ifq) \
	-ifqLen $opt(lenIfq) \
	-antType $opt(ant) \
	-phyType $opt(netif) \
	-topoInstance $topo_ \
	-channel $chan_ \
	-agentTrace OFF \
	-routerTrace OFF \
	-macTrace OFF \
	-movementTrace OFF




for {set i 0} {$i < $opt(numOfNodes)} {incr i} {
	# init mobile nodes
	set node_($i) [$ns_ node]

	# disable random motion
	$node_($i) random-motion 0

	# register node.
	$god_ new_node $node_($i)

	# initial node position
	$ns_ initial_node_pos $node_($i) 10

	# init agent
	set agent_($i) [new $opt(agent)]
		
	# attach agent to node.
	$node_($i) attach $agent_($i)
} 



set dWidth [expr 1.0*$opt(width)/[expr $gridX-1]];
set dHeight [expr 1.0*$opt(height)/[expr $gridY-1]];

for {set i 0} {$i < $gridX } {incr i} {
	for {set j 0} {$j < $gridY } {incr j} {
 		set nodeId [expr $i*$gridY + $j];
		$node_($nodeId) set X_ [expr $i*$dWidth];
		$node_($nodeId) set Y_ [expr $j*$dHeight];
		$node_($nodeId) set Z_ 0.000000000000;
	}
}

for {set j 0} {$j < $numberOfPackets } {incr j} {
     $ns_ at [expr 20 + $j*1] "$agent_($centerNode) send"
}
$ns_ at [expr 30 + $numberOfPackets]  "$ns_ halt"

# start simulation
$ns_ run;

$ns_ flush-trace
close $tracefd
