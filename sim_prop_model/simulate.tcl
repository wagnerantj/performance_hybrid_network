set opt(chan)           Channel/WirelessChannel;# channel layer
set opt(netif)          Phy/WirelessPhy;		# physical layer
set opt(ant)            Antenna/OmniAntenna;    # antenna model
set opt(macLayer)       Mac;				# mac layer
set opt(ifq)            Queue/DropTail;		# message queue, ifq
set opt(lenIfq)         50;				# max packet in ifq
set opt(linkLayer)      LL;				# link layer
set opt(routing)        DumbAgent;		      # routing protocol
set opt(agent)		Agent/NbhAgent;		# simulation agent

Agent/NbhAgent set packetCount_ 0

# topology
set gridX   31; # number of nodes in a horizontal line
set gridY 	31; # number of nodes in a vertical line
set numberOfPackets 	2000;	# packets used for sending
set opt(width)		200;	# topography width
set opt(height)		200;	# topography height


set argArray [split $argv];
if { $argc != 1 } {
	puts "use: ns simulate.tcl <propagation file>";
} else {
	source  [lindex $argArray 0];

	set opt(numOfNodes)   	[expr $gridX*$gridY];	# number of mobilenodes
	set centerNode 		[expr [expr $opt(numOfNodes)-1] /2]

	source  "tcl/initialize.tcl";
	source  "tcl/writeOutput.tcl";
}






