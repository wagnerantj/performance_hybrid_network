set graph1   [open "graph1.tex" w]
set graph2 	 [open "graph2.tex" w]
set topology [open "topologySize.tex" w]


set xWidth 5;	# width of output
set yWidth [expr 1.0*$xWidth*$opt(height)/$opt(width)];
set dWidth [expr 1.0*$xWidth/$gridX];
set dHeight [expr 1.0*$yWidth/$gridY];


puts $topology "\\newcommand{\\topHeight}{-$yWidth}"
puts $topology "\\newcommand{\\topHeightLabel}{$opt(height)}"
puts $topology "\\newcommand{\\topWidthLabel}{$opt(width)}"



for {set i 0} {$i < $gridX } {incr i} {
		set nodeId [expr $i*$gridY + [expr $gridY-1]/2];
		if {$nodeId == $centerNode} { continue; }

		set packetReceived [$agent_($nodeId) set packetCount_];
		set packetRate [ expr [expr $packetReceived*100]/$numberOfPackets ];
		puts $graph1 "[expr $i*$xWidth/[expr $gridX-1.0]] [expr 3.0*$packetRate/100]"		
}

for {set i 0} {$i < $gridX } {incr i} {
	for {set j 0} {$j < $gridY } {incr j} {
		set nodeId [expr $i*$gridY +$j];
		if {$nodeId == $centerNode} { continue; }

		set packetReceived [$agent_($nodeId) set packetCount_];
		set packetRate [ expr [expr $packetReceived*100]/$numberOfPackets ];
		
   
		set posX [expr $i*$dWidth-0.01]
		set posY [expr $j*$dHeight-$yWidth-1.01]
		set posX2 [expr $i*$dWidth+$dWidth+0.01]
		set posY2 [expr $j*$dHeight+$dHeight-$yWidth-0.99]

		puts $graph2 "\\fill \[black!$packetRate\] ($posX ,$posY) rectangle ($posX2,$posY2);"
	}
}





close $graph1;
close $graph2;
close $topology;
