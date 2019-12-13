# customize simulation
set gridX   31; # number of nodes in a horizontal line
set gridY 	31; # number of nodes in a vertical line
set numberOfPackets 	2000;	# packets used for sending
set opt(width)		200;	# topography width
set opt(height)		200;	# topography height


Propagation/APProxy set minRandomGain_ -3.0;
Propagation/APProxy set maxRandomGain_ 3.0;
Propagation/APProxy set maxGain_ 10.0;
Propagation/APProxy set angleNumber_ 7;

Propagation/fsk set frameLength_ 50.0
Propagation/fsk set pathLoss_ 3.8
Propagation/fsk set sigma_ 4.0
Propagation/fsk set dist0_ 1.0
Propagation/fsk set noiseBandwidth_ 30000
Propagation/fsk set dataRate_ 19200
Propagation/fsk set noiseFloor_ -105 

     
$defaultRNG seed 111; 

# set propagation model
set opt(propInstance) [new Propagation/APProxy]
$opt(propInstance) propagation [new Propagation/fsk]

