#!/bin/bash
# Script designed to combine reads from replicates. 


wkDIR=/Users/brittanyhowell/Documents/University/Honours_2016/Project/freqSplice/gapTables/human1045/
outDIR=/Users/brittanyhowell/Documents/University/Honours_2016/Project/freqSplice/gapTables/human1045All/

suffix="intervals.txt"

cd ${wkDIR} 

echo "Okay let's combine some replicates"

cat gapsIn0h_Ctrl_*${suffix} > ${outDIR}/gapsIn0h_Ctrl_All_${suffix}
echo "11%... Going well"
cat gapsIn24h_1mg_*${suffix} > ${outDIR}/gapsIn24h_1mg_All_${suffix}
echo "22%... making ground"
cat gapsIn24h_2mg_*${suffix} > ${outDIR}/gapsIn24h_2mg_All_${suffix}
echo "33%... wooo a third!"
cat gapsIn24h_5FU_*${suffix} > ${outDIR}/gapsIn24h_5FU_All_${suffix}
echo "44%... Almost half!!"
cat gapsIn24h_Ctrl_*${suffix} > ${outDIR}/gapsIn24h_Ctrl_All_${suffix}
echo "55%... You could pass a bill with that!"
cat gapsIn48h_1mg_*${suffix} > ${outDIR}/gapsIn48h_1mg_All_${suffix}
echo "66%... Starting to be actual files!"
cat gapsIn48h_2mg_*${suffix} > ${outDIR}/gapsIn48h_2mg_All_${suffix}
echo "77%... Almost there!"
cat gapsIn48h_5FU_*${suffix} > ${outDIR}/gapsIn48h_5FU_All_${suffix}
echo "88%... I can see the end!"
cat gapsIn48h_Ctrl_*${suffix} > ${outDIR}/gapsIn48h_Ctrl_All_${suffix}
echo "99%... Final touches!"
echo "I'm all done! And with no errors. Have a great day :) "

