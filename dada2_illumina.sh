#!/bin/bash
#Peter Leary
mkdir $HOME/Desktop/qiime2/$name/dada2
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs ~/Desktop/QIIME2/$name/demux/demux.qza \
  --o-table ~/Desktop/qiime2/$name/dada2/table \
  --o-representative-sequences ~/Desktop/qiime2/$name/dada2/rep-seqs \
  --p-trim-left-f $trimleft \
  --p-trim-left-r $trimleft \
  --p-trunc-len-f $trunclen \
  --p-trunc-len-r 180 \
  --verbose \
  --p-n-threads 0
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