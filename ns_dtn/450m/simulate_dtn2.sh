#!/bin/bash

for i in 1 2 3 4; do
    new_seed=`expr 12345670 + 2 \* $i - 1`
    ns create-traffic-file2.tcl -seed $new_seed -nn 43 -bundlesize 10000 -lifetime 3000.0 > trafficgen2.tcl
    sleep 5
    nice -n 4 /home/user/ns-allinone-2.35/ns-2.35/ns bundle-test-large-scen2.tcl -seed $new_seed -nn 43 -simtime 6000.0 -bundlesize 10000 -lifetime 3000.0 > dtn2.txt
    grep 'Destination' dtn2.txt > temp2.txt
    awk '{print $6" "$10" "$14" "$18}' temp2.txt > bundle_delays2.tr
    sed -i 's/, / /g' bundle_delays2.tr
    grep 'Source' dtn2.txt > temp2.txt
    awk '{print $2" "$10" "$14" "$18}' temp2.txt > receipt_delays2.tr
    sed -i 's/, / /g' receipt_delays2.tr
    rm temp2.txt
    mv *.nam *.tr *.txt trafficgen2.tcl Run$i
done
