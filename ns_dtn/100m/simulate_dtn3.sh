#!/bin/bash

for i in 1 2 3 4; do
    new_seed=`expr 12345670 + 2 \* $i - 1`
    ns create-traffic-file3.tcl -seed $new_seed -nn 34 -bundlesize 10000 -lifetime 3000.0 > trafficgen3.tcl
    sleep 5
    nice -n 4 /home/user/ns-allinone-2.35/ns-2.35/ns bundle-test-large-scen3.tcl -seed $new_seed -nn 34 -simtime 6000.0 -bundlesize 10000 -lifetime 3000.0 > dtn3.txt
    grep 'Destination' dtn3.txt > temp3.txt
    awk '{print $6" "$10" "$14" "$18}' temp3.txt > bundle_delays3.tr
    sed -i 's/, / /g' bundle_delays3.tr
    grep 'Source' dtn3.txt > temp3.txt
    awk '{print $2" "$10" "$14" "$18}' temp3.txt > receipt_delays3.tr
    sed -i 's/, / /g' receipt_delays3.tr
    rm temp3.txt
    mv *.nam *.tr *.txt trafficgen3.tcl Run$i
done
