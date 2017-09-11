#!/bin/bash

scriptDIR=/Users/brittanyhowell/Documents/University/Honours_2016/Project/freqSplice/scripts
wkDIR=/Users/brittanyhowell/Documents/University/Honours_2016/Project/freqSplice/gapTables/human1045

cd ${scriptDIR}

cp khan.R ${wkDIR}


cd ${wkDIR}

sample=$(ls *report.txt)

for gap in ${sample}; do

	sampleName="${gap%_report.txt}" 
	noGAP="$(echo $sampleName | sed 's/gapsIn//g')" # sample name generated

	intTable=${sampleName}_intervals.txt

	echo ${intTable}
	wc -l ${intTable}
done