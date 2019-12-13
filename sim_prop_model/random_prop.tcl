# customize simulation
set gridX   31; # number of nodes in a horizontal line
set gridY 	31; # number of nodes in a vertical line
set numberOfPackets 	2000;	# packets used for sending
set opt(width)		200;	# topography width
set opt(height)		200;	# topography height

# set propagation model
set opt(prop) Propagation/Random;
Propagation/Random set lossRate_ 0.25
Propagation/Random set range_ 50          
