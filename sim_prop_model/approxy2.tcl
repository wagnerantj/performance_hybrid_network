# customize simulation
set gridX   31; # number of nodes in a horizontal line
set gridY 	31; # number of nodes in a vertical line
set numberOfPackets 	2000;	# packets used for sending
set opt(width)		200;	# topography width
set opt(height)		200;	# topography height

Propagation/APProxy set minRandomGain_ -2.0;
Propagation/APProxy set maxRandomGain_ 2.0;
Propagation/APProxy set maxGain_ 10.0;
Propagation/APProxy set angleNumber_ 10;

Phy/WirelessPhy set RXThresh_ 7.69113e-8; # 50 m

# set propagation model
set opt(propInstance) [new Propagation/APProxy]
$opt(propInstance) propagation [new Propagation/TwoRayGround]

# [expr [expr $gridX*$gridY-1] /2] calculates the middle node 
$opt(propInstance) profile [expr [expr $gridX*$gridY-1] /2]  1.0 -1.0  1.0 -1.0 \
										 1.0 -1.0  1.0 -1.0  1.0 -1.0  

