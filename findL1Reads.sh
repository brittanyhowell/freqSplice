#!/bin/bash

# This script uses the readSummary from kamala.go. It uses the  coords from readSummary to extract just the matching records from the total reads document. 

wkDIR=/Users/brittanyhowell/Documents/University/Honours_2016/Project/freqSplice/gapTables/human1045

readSum=gapsIn0h_Ctrl_R2_readSummary.txt
keys=gapsIn0h_Ctrl_R2_70L1KEY.txt
reads=gapsIn0h_Ctrl_R2_reads.txt

# Make keys list from highly spliced L1s
# awk '{if ($7 > 70) print}' ${readSum} > ${keys}

cd ${wkDIR}

while read  chr  startL1  endL1 
do
     echo "${chr}, ${startL1}, ${endL1}!"
    cat ${reads} | awk '{if ($2 == $chr ) print}'
done < ${keys}


echo "we done, tell Jack you love him"
# touch onlyReadsL1.txt

# for num in ${list} ; do
# 	# grep $num ${reads} >> onlyReadsL1.txt
# 	echo $num
# done



