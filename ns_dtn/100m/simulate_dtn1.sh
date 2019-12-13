#!/bin/bash

for i in 1 2 3 4; do
    new_seed=`expr 12345670 + 2 \* $i - 1`
    ns create-traffic-file1.tcl -seed $new_seed -nn 34 -bundlesize 10000 -lifetime 3000.0 > trafficgen1.tcl
    sleep 5
    nice -n 4 /home/user/ns-allinone-2.35/ns-2.35/ns bundle-test-large-scen1.tcl -seed $new_seed -nn 34 -simtime 6000.0 -bundlesize 10000 -lifetime 3000.0 > dtn1.txt
    grep 'Destination' dtn1.txt > temp1.txt
    awk '{print $6" "$10" "$14" "$18}' temp1.txt > bundle_delays1.tr
    sed -i 's/, / /g' bundle_delays1.tr
    grep 'Source' dtn1.txt > temp1.txt
    awk '{print $2" "$10" "$14" "$18}' temp1.txt > receipt_delays1.tr
    sed -i 's/, / /g' receipt_delays1.tr
    rm temp1.txt
    mv *.nam *.tr *.txt trafficgen1.tcl Run$i
done
