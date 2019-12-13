for {set j 0} {$j < 27 } { incr j } { 
for {set i 0} {$i < 4 } {incr i} {
set con_id [expr 4*$j + $i]
set send_time  [expr 40*$j + 10*$i]
set udp_($con_id) [new Agent/UDP]
$ns_ attach-agent $node_($i) $udp_($con_id)
set null_($con_id) [new Agent/Null]
$ns_ attach-agent $node_([expr $i + 16]) $null_($con_id)
set cbr_($con_id) [new Application/Traffic/CBR]
$cbr_($con_id) set packetSize_ 512
$cbr_($con_id) set random_ 1
$cbr_($con_id) set rate_ 415000
$cbr_($con_id) attach-agent $udp_($con_id)
$ns_ connect $udp_($con_id) $null_($con_id)
$ns_ at [expr $send_time + 10] "$cbr_($con_id) start"  
$ns_ at [expr $send_time + 20] "$cbr_($con_id) stop" 
puts "no tx = $i,  j = $j, $send_time e $con_id ."
}}


