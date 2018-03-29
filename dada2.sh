#!/bin/bash
#Peter Leary
mkdir $name/$sv
qiime dada2 denoise-single \
  --i-demultiplexed-seqs $name/demux/demux.qza \
  --p-trim-left $trimleft \
  --p-trunc-len $trunclen \
  --o-representative-sequences $name/$sv/rep-seqs.qza \
  --o-table $name/$sv/table.qza \
  --p-n-threads 0 \
  --p-max-ee 5 \
  --quiet
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
qiime tools export $name/$sv/rep-seqs.qzv --output-dir $name/useful/rep-seqs
#
cp $name/useful/rep-seqs/sequences.fasta $name/useful/rep-seqs/rep-seqs.txt