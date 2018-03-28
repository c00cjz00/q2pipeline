#!/bin/bash
#Peter Leary
mkdir $HOME/Desktop/QIIME2/$name/$sv
qiime dada2 denoise-single \
  --i-demultiplexed-seqs $HOME/Desktop/QIIME2/$name/demux/demux.qza \
  --p-trim-left $trimleft \
  --p-trunc-len $trunclen \
  --o-representative-sequences $HOME/Desktop/QIIME2/$name/$sv/rep-seqs.qza \
  --o-table $HOME/Desktop/QIIME2/$name/$sv/table.qza \
  --p-n-threads 0 \
  --p-max-ee 5 \
  --quiet
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
qiime tools export $HOME/Desktop/QIIME2/$name/$sv/table.qzv --output-dir $HOME/Desktop/QIIME2/$name/useful/table
#
qiime tools export $HOME/Desktop/QIIME2/$name/$sv/table.qza --output-dir $HOME/Desktop/QIIME2/$name/useful/biomtable
#
qiime tools export $HOME/Desktop/QIIME2/$name/$sv/rep-seqs.qzv --output-dir $HOME/Desktop/QIIME2/$name/useful/rep-seqs
cp $HOME/Desktop/QIIME2/$name/useful/rep-seqs/sequences.fasta $HOME/Desktop/QIIME2/$name/useful/rep-seqs/rep-seqs.txt