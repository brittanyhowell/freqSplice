#!/bin/bash

scriptDIR=/Users/brittanyhowell/Documents/University/Honours_2016/Project/freqSplice/scripts
wkDIR=/Users/brittanyhowell/Documents/University/Honours_2016/Project/freqSplice/gapTables/human1045Aggregate
outDIR=/Users/brittanyhowell/Documents/University/Honours_2016/Project/freqSplice/gapTablePlotsTables/human1045Aggregate

if [ -d $outDIR ]; then
    rm -r $outDIR
    echo "Folder $outDIR exists... replacing"
    mkdir $outDIR
else
    mkdir $outDIR
fi

cd ${scriptDIR}
cp khan.R ${wkDIR}
cd ${wkDIR}

echo "removing half baked goods"
rm *_plot_splits.pdf 
rm *_table_splits.txt 
rm *_plot_L1s.pdf 
rm *_plot_coverage.pdf


sample=$(ls *intervals.txt)

for gap in ${sample}; do

	sampleName="${gap%_intervals.txt}" 
	noGAP="$(echo $sampleName | sed 's/gapsIn//g')" # sample name generated

	intTable=${sampleName}_intervals.txt
	readSumTable=${sampleName}_readSummary.txt
	splitTable=${wkDIR}/${sampleName}_splitReads.txt

echo ${sampleName}

	Rscript khan.R ${wkDIR} ${intTable} ${sampleName}_plot_coverage.pdf ${sampleName} ${readSumTable} ${sampleName}_plot_L1s.pdf ${splitTable} ${sampleName}_plot_splits.pdf ${sampleName}_table_splits.txt
done

mv *_plot_splits.pdf ${outDIR}
mv *_table_splits.txt ${outDIR}
mv *_plot_L1s.pdf ${outDIR}
mv *_plot_coverage.pdf ${outDIR}


echo "complete"