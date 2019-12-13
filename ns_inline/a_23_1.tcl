
#set opt(seed) 4
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
Mac/802_11Ext set RTSThreshold_                 2346
#Mac/802_11Ext set RTSThreshold_                 100
Mac/802_11Ext set MAC_DBG                       0
Mac/802_11Ext set Logbackoff                    1

Antenna/OmniAntenna set X_                  0
Antenna/OmniAntenna set Y_                  0
Antenna/OmniAntenna set Z_                  1.5		;# as used in [1]
Antenna/OmniAntenna set Gt_                 2.5118 	;# 4dB as used in [1]
Antenna/OmniAntenna set Gr_                 2.5118	;# 4dB as used in [1]

Propagation/Shadowing2 set pathlossExp1_ 2.0 ;#path loss exponent
Propagation/Shadowing2 set pathlossExp2_ 4.0 ;#path loss exponent
Propagation/Shadowing2 set std_db1_ 5.6 ;# shadowing deviation (dB)
Propagation/Shadowing2 set std_db2_ 8.4 ;# shadowing deviation (dB)
Propagation/Shadowing2 set dist0_ 1.0 ;# reference distance (m)
Propagation/Shadowing2 set dist1_ 100.0 ;# reference distance (m)
Propagation/Shadowing2 set seed_ $opt(seed) ;# seed for RNG

#Propagation/Shadowing set pathlossExp_ 3.7 ;#path loss exponent
#Propagation/Shadowing set std_db_ 3.4 ;# shadowing deviation (dB)
#Propagation/Shadowing set dist0_ 10 ;# reference distance (m)
#Propagation/Shadowing set seed_ 0 ;# seed for RNG

#Propagation/Nakagami set use_nakagami_dist_ true	;# use Fading or not
#Propagation/Nakagami set gamma0_ 0 ;#1.9
#Propagation/Nakagami set gamma1_ 3.8
#Propagation/Nakagami set gamma2_ 3.8
#Propagation/Nakagami set d0_gamma_ 200
#Propagation/Nakagami set d1_gamma_ 500
#Propagation/Nakagami set m0_  1.5
#Propagation/Nakagami set m1_  0.75
#Propagation/Nakagami set m2_  0.5 ;#0.75
#Propagation/Nakagami set d0_m_ 80
#Propagation/Nakagami set d1_m_ 200


set val(chan)           Channel/WirelessChannel    ;# channel type
#set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(prop)           Propagation/Shadowing2  ;# radio-propagation model
#set val(prop)			Propagation/Nakagami
set val(netif)          Phy/WirelessPhyExt            ;# network interface type
set val(mac)            Mac/802_11Ext                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn) 			16                     ;# number of mobilenodes
#set opt(af) 			$opt(config-path)
#append opt(af) 		/activity.tcl
set val(af) 			./activity.tcl
#set opt(mf) 			$opt(config-path)
#append opt(mf) 		/mobility.tcl
#set val(mf) 			./mobility.tcl
set val(rp)             AODV                       ;# routing protocol
#set val(rp)             DSDV ;                      ;# routing protocol
set val(x) 				9500
set val(y) 				3500
set val(min-x) 			0
set val(min-y) 			0
set val(start) 			0.0
set val(stop) 			480.0
set val(vseed)			$opt(seed)

# ======================================================================
# Main Program
# ======================================================================
#
# Initialize Global Variables

global defaultRNG
$defaultRNG seed [expr 1 + $val(vseed)]

set ns_		[new Simulator]

set tracefd     [open w300.tr w]

#set tracer [new Trace/Var]
#$val(prop) trace Pr $tracer
#set tracer 	[open ex2bt.tr w]

$ns_ trace-all $tracefd 

set namtrace [open w300.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)



# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

# Create God
create-god $val(nn)

# New API to config node: 
# 1. Create channel (or multiple-channels);
# 2. Specify channel in node-config (instead of channelType);
# 3. Create nodes for simulations.

# Create channel #1 and #2
set chan_1_ [new $val(chan)]
set chan_2_ [new $val(chan)]

#		-channel [new $val(chan)]  \

# Create node(0) "attached" to channel #1

# configure node, please note the change below.
$ns_ node-config -adhocRouting $val(rp) \
		-llType $val(ll) \
		-macType $val(mac) \
		-ifqType $val(ifq) \
		-ifqLen $val(ifqlen) \
		-antType $val(ant) \
		-propType $val(prop) \
		-phyType $val(netif) \
		-topoInstance $topo \
		-channel $chan_1_ \
		-agentTrace ON \
		-routerTrace ON \
		-macTrace ON \
		-PhyTrace ON \
		-movementTrace OFF \

 
    
 for {set i 0} {$i < $val(nn) } {incr i} {
  set node_($i) [$ns_ node] 
  $node_($i) random-motion 0  ;# disable random motion

 }

source ./mobility.tcl
 

for {set j 0} {$j < 48 } { incr j } { 
set con_id [expr $j]
set send_time  [expr 10*$j]
set udp_($con_id) [new Agent/UDP]
$ns_ attach-agent $node_(7) $udp_($con_id)
set null_($con_id) [new Agent/Null]
$ns_ attach-agent $node_(15) $null_($con_id)
set cbr_($con_id) [new Application/Traffic/CBR]
$cbr_($con_id) set packetSize_ 512
$cbr_($con_id) set random_ 1
$cbr_($con_id) set rate_ 415000
$cbr_($con_id) attach-agent $udp_($con_id)
$ns_ connect $udp_($con_id) $null_($con_id)
$ns_ at $send_time "$cbr_($con_id) start"  
puts " j = $j, $send_time e $con_id ."
}


#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at $val(stop) "$node_($i) reset";
}
$ns_ at $val(stop) "stop"
$ns_ at $val(stop) "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ tracefd tracer
    $ns_ flush-trace
    close $tracefd
#	close $tracer
}

puts "Starting Simulation..."
$ns_ run
