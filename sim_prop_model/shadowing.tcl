# customize simulation
set gridX   31; # number of nodes in a horizontal line
set gridY 	31; # number of nodes in a vertical line
set numberOfPackets 	2000;	# packets used for sending
set opt(width)		200;	# topography width
set opt(height)		200;	# topography height

# set propagation model
set opt(prop) Propagation/Shadowing;

# parameters for shadowing
Phy/WirelessPhy set Pt_ 0.28183815 
Antenna/OmniAntenna set Gt_ 1.0	
Antenna/OmniAntenna set Gr_ 1.0 
Phy/WirelessPhy set freq_ 914e+6			
Phy/WirelessPhy set L_ 1.0   			
Propagation/Shadowing set pathlossExp_ 2.0
Propagation/Shadowing set std_db_ 2.8 	
Propagation/Shadowing set dist0_ 1.0	 	
Phy/WirelessPhy set RXThresh_ 3.3e-8 