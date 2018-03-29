#!/bin/bash
#QIIME 2 pipeline by Peter Leary 
#Step 2.4 - Deblur 
mkdir $name/$sv/
#
qiime quality-filter q-score \
 --i-demux $name/demux/demux.qza \
 --o-filtered-sequences $name/$sv/demux-filtered.qza \
 --o-filter-stats $name/$sv/demux-filter-stats.qza
 #
 qiime deblur denoise-16S \
  --i-demultiplexed-seqs $name/$sv/demux-filtered.qza \
  --p-trim-length $trunclen \
  --o-representative-sequences $name/$sv/rep-seqs.qza \
  --o-table $name/$sv/table.qza \
  --o-stats $name/$sv/deblur.qza
  #
  #
qiime feature-table summarize \
  --i-table $name/$sv/table.qza \
  --o-visualization $name/$sv/table.qzv \
  --m-sample-metadata-file $name/"$name"map.txt \
  --quiet
#
qiime feature-table tabulate-seqs \
  --i-data $name/$sv/rep-seqs.qza \
  --o-visualization $name/$sv/rep-seqs.qzv \
  --quiet
#
qiime tools export $name/$sv/table.qzv --output-dir $name/useful/table
#
qiime tools export $name/$sv/table.qza --output-dir $name/useful/biomtable
#
qiime tools export ..$name/$sv/rep-seqs.qzv --output-dir $name/useful/rep-seqs
#
cp $name/useful/rep-seqs/sequences.fasta $name/useful/rep-seqs/rep-seqs.txt
