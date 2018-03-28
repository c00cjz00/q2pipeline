#!/bin/bash
#QIIME 2 pipeline by Peter Leary 
#Step 2.4 - Deblur 
mkdir ~/Desktop/qiime2/$name/$sv/
#
qiime quality-filter q-score \
 --i-demux ~/Desktop/qiime2/$name/demux/demux.qza \
 --o-filtered-sequences ~/Desktop/qiime2/$name/$sv/demux-filtered.qza \
 --o-filter-stats ~/Desktop/qiime2/$name/$sv/demux-filter-stats.qza
 #
 qiime deblur denoise-16S \
  --i-demultiplexed-seqs ~/Desktop/qiime2/$name/$sv/demux-filtered.qza \
  --p-trim-length $trunclen \
  --o-representative-sequences ~/Desktop/qiime2/$name/$sv/rep-seqs.qza \
  --o-table ~/Desktop/qiime2/$name/$sv/table.qza \
  --o-stats ~/Desktop/qiime2/$name/$sv/deblur.qza
  #
  #
qiime feature-table summarize \
  --i-table $HOME/Desktop/QIIME2/$name/$sv/table.qza \
  --o-visualization $HOME/Desktop/QIIME2/$name/$sv/table.qzv \
  --m-sample-metadata-file $HOME/Desktop/QIIME2/$name/"$name"map.txt \
  --quiet
#
qiime feature-table tabulate-seqs \
  --i-data $HOME/Desktop/QIIME2/$name/$sv/rep-seqs.qza \
  --o-visualization $HOME/Desktop/QIIME2/$name/$sv/rep-seqs.qzv \
  --quiet
#
qiime tools export $HOME/Desktop/QIIME2/$name/$sv/table.qzv --output-dir $HOME/Desktop/QIIME2/$name/$sv
#
qiime tools export $HOME/Desktop/QIIME2/$name/$sv/rep-seqs.qzv --output-dir $HOME/Desktop/QIIME2/$name/$sv