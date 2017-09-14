#!/bin/bash

# This script uses the readSummary from kamala.go. It uses the  coords from readSummary to extract just the matching records from the total reads document. 

reads=gapsIn24h_1mg_R2_reads.txt 
keys=onlySpliceL1.txt

list=$( awk '{print $2}' ${keys})

touch onlyReadsL1.txt

for num in ${list} ; do
	# grep $num ${reads} >> onlyReadsL1.txt
	echo $num
done



