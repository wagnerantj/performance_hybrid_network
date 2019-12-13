
#set opt(seed) 4
#set opt(nn) 12
#set opt(simtime) 400
#set opt(mobility) mobility.tcl
#set opt(trafego) trafego_3x3_450.tcl


#=========================================================
#Phy param
#=========================================================

Phy/WirelessPhyExt set CSThresh_                3.9810717055349694e-13	;# -94 dBm wireless interface sensitivity
Phy/WirelessPhyExt set Pt_                      0.1			;# equals 20dBm when considering antenna gains of 1.0
#Phy/WirelessPhyExt set Pt_                      1.0			;# equals 30dBm when considering antenna gains of 1.0
Phy/WirelessPhyExt set freq_                    5.9e+9
Phy/WirelessPhyExt set noise_floor_             1.26e-13    		;# -99 dBm for 10MHz bandwidth
Phy/WirelessPhyExt set L_                       1.0         		;# default radio circuit gain/loss
Phy/WirelessPhyExt set PowerMonitorThresh_      3.981071705534985e-18   ;# -174 dBm power monitor sensitivity (=level of gaussian noise)
Phy/WirelessPhyExt set HeaderDuration_          0.000040    		;# 40 us
Phy/WirelessPhyExt set BasicModulationScheme_   0
Phy/WirelessPhyExt set PreambleCaptureSwitch_   1
Phy/WirelessPhyExt set DataCaptureSwitch_       1
Phy/WirelessPhyExt set SINR_PreambleCapture_    3.1623;     		;# 5 dB
Phy/WirelessPhyExt set SINR_DataCapture_        10.0;      		;# 10 dB
Phy/WirelessPhyExt set trace_dist_              1e6         		;# PHY trace until distance of 1 Mio. km ("infinity")
Phy/WirelessPhyExt set PHY_DBG_                 0

Mac/802_11Ext set CWMin_                        15
Mac/802_11Ext set CWMax_                        1023
Mac/802_11Ext set SlotTime_                     0.000013
Mac/802_11Ext set SIFS_                         0.000032
Mac/802_11Ext set ShortRetryLimit_              7
Mac/802_11Ext set LongRetryLimit_               4
Mac/802_11Ext set HeaderDuration_               0.000040
Mac/802_11Ext set SymbolDuration_               0.000008
Mac/802_11Ext set BasicModulationScheme_        0
Mac/802_11Ext set use_802_11a_flag_             true
#Mac/802_11Ext set RTSThreshold_                 100
Mac/802_11Ext set RTSThreshold_                 2346
Mac/802_11Ext set MAC_DBG                       0
Mac/802_11Ext set Logbackoff                    1

Propagation/APProxy set minRandomGain_ 0;
Propagation/APProxy set maxRandomGain_ 0;
Propagation/APProxy set maxGain_ 10.00;
Propagation/APProxy set angleNumber_ 8;

Antenna/OmniAntenna set X_                  0
Antenna/OmniAntenna set Y_                  0
Antenna/OmniAntenna set Z_                  1.5		;# as used in [1]
#Antenna/OmniAntenna set Gt_                 2.5118 	;# 4dB as used in [1]
#Antenna/OmniAntenna set Gr_                 2.5118	;# 4dB as used in [1]
Antenna/OmniAntenna set Gt_                 1 	;# 4dB as used in [1]
Antenna/OmniAntenna set Gr_                 1	;# 4dB as used in [1]

Propagation/Shadowing2 set pathlossExp1_ 2.0 ;#path loss exponent
Propagation/Shadowing2 set pathlossExp2_ 4.0 ;#path loss exponent
Propagation/Shadowing2 set std_db1_ 5.6 ;# shadowing deviation (dB)
Propagation/Shadowing2 set std_db2_ 8.4 ;# shadowing deviation (dB)
Propagation/Shadowing2 set dist0_ 1.0 ;# reference distance (m)
Propagation/Shadowing2 set dist1_ 100.0 ;# reference distance (m)
Propagation/Shadowing2 set seed_ $opt(seed) ;# seed for RNG

LL set mindelay_		50us
LL set delay_			25us
LL set bandwidth_		0	;# not used

Agent/Null set sport_		0
Agent/Null set dport_		0
Agent/CBR set sport_		0
Agent/CBR set dport_		0
Agent/TCPSink set sport_	0
Agent/TCPSink set dport_	0
Agent/TCP set sport_		0
Agent/TCP set dport_		0
Agent/TCP set packetSize_	1460


set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/Shadowing2  ;# radio-propagation model
#set val(prop)           Propagation/Shadowing   ;# radio-propagation model
set val(netif)          Phy/WirelessPhyExt            ;# network interface type
set val(mac)            Mac/802_11Ext                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                        ;# max packet in ifq
set val(nn) 			$opt(nn)                    ;# number of mobilenodes
#set val(rp)             DYMOUM                       ;# routing protocol
set val(rp)             AODV                       ;# routing protocol
#set val(rp)             DSDV                       ;# routing protocol
set val(x) 				3500
set val(y) 				3500
set val(start) 			0.0
set val(stop) 			$opt(simtime)
#set val(err)        	UniformErrorProc
set val(vseed)			$opt(seed)
set val(mv)				$opt(mobility)
set val(traf)			$opt(trafego)
# ======================================================================
# Main Program
# ======================================================================
#
# Initialize Global Variables

Node/MobileNode instproc getIfq { param0} {
    $self instvar ifq_    
    return $ifq_($param0) 
}

Node/MobileNode instproc getPhy { param0} {
    $self instvar netif_    
    return $netif_($param0) 
}

global defaultRNG
$defaultRNG seed [expr 1 + $val(vseed)]

set ns_		[new Simulator]
set tracefd     [open redes_sem_fio.tr w]
$ns_ trace-all $tracefd

set namtrace [open redes_sem_fio.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)

proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
}

# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

# Create God
create-god $val(nn)

# create propagation proxy instance
set opt(propInstance) [new Propagation/APProxy]
$opt(propInstance) propagation [new $val(prop)]
if { [info exists opt(propInstance)] } {
	$ns_ node-config -propInstance $opt(propInstance) 
} else {
	$ns_ node-config -propType $val(prop) 
}


# New API to config node: 
# 1. Create channel (or multiple-channels);
# 2. Specify channel in node-config (instead of channelType);
# 3. Create nodes for simulations.

# Create channel #1 and #2
set chan_1_ [new $val(chan)]
set chan_2_ [new $val(chan)]

# Create node(0) "attached" to channel #1

# configure node, please note the change below.
$ns_ node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
		-macType $val(mac) \
		-ifqType $val(ifq) \
		-ifqLen $val(ifqlen) \
		-antType $val(ant) \
		-phyType $val(netif) \
		-topoInstance $topo \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace ON \
		-PhyTrace ON \
		-movementTrace OFF \
		-channel $chan_1_ 
 
    
 for {set i 0} {$i < $val(nn) } {incr i} {
  set node_($i) [$ns_ node] 
  $node_($i) random-motion 0  ;# disable random motion
  $ns_ initial_node_pos $node_($i) 20
  $opt(propInstance) profile $node_($i)  2.5118 -10 2.5118 -10 2.5118 -10 2.5118 -10
 }

source ./$val(mv)
 
source ./$val(traf)

#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at $val(stop) "$node_($i) reset";
}

$ns_ at  [expr $val(stop)+0.1] "stop"
$ns_ at [expr $val(stop)+0.1] "puts \"NS EXITING...\" ; $ns_ halt"

puts "Starting Simulation..."
$ns_ run
