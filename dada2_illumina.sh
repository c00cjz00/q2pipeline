#!/bin/bash
#Peter Leary
mkdir ../$name/dada2
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs ../$name/demux/demux.qza \
  --o-table ../$name/dada2/table \
  --o-representative-sequences ../$name/dada2/rep-seqs \
  --p-trim-left-f $trimleft \
  --p-trim-left-r $trimleft \
  --p-trunc-len-f $trunclen \
  --p-trunc-len-r $truncrev \
  --verbose \
  --p-n-threads 0
#
qiime feature-table summarize \
  --i-table ../$name/$sv/table.qza \
  --o-visualization ../$name/$sv/table.qzv \
  --m-sample-metadata-file ../$name/"$name"map.txt \
  --quiet
#
qiime feature-table tabulate-seqs \
  --i-data ../$name/$sv/rep-seqs.qza \
  --o-visualization ../$name/$sv/rep-seqs.qzv \
  --quiet 
#
qiime tools export ../$name/$sv/table.qzv --output-dir ../$name/useful/table
#
qiime tools export ../$name/$sv/table.qza --output-dir ../$name/useful/biomtable
#
qiime tools export ..$name/$sv/rep-seqs.qzv --output-dir ../$name/useful/rep-seqs
#
cp ../$name/useful/rep-seqs/sequences.fasta ../$name/useful/rep-seqs/rep-seqs.txt
