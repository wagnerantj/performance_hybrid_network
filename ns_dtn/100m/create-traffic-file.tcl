# Get the simulation parameters (-param1 value1 -param2 value2...)
for {set i 0} {$i < $argc} {incr i} {
    global opt
    set arg [lindex $argv $i]
    if {[string range $arg 0 0] != "-"} continue
    set name [string range $arg 1 end]
    set opt($name) [lindex $argv [expr $i+1]]
}

global defaultRNG
$defaultRNG seed $opt(seed)

# Create a simulator object
set ns_ [new Simulator]

# Schedule events
# Parameters: destination, bundle size, lifetime [s], custody transfer: 0/1, return receipt: 0/1,
#             priority (not yet in use): bulk=0, normal=1, expedited=2
for { set i 1} {$i < $opt(nn)} {incr i} {
    for { set j 0} {$j < 10} {incr j} {
    if { $j % 2 == 0 } {
	  set dest 0 
	} else {
	set dest 18
	}
	set send_time  [expr 10.0 + $j*200.0 + double([ns-random] % 999)/100.0]
	#set bundle_size  [expr [ns-random] % 20001]
	puts "\$ns_ at $send_time \"\$bundle_($i) send $dest $opt(bundlesize) $opt(lifetime) 0 1 1\""
    }
}

# Run the simulation
$ns_ run
