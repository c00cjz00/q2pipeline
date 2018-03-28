#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.2 - Demultiplexing samples
mkdir $HOME/Desktop/QIIME2/$name/demux
qiime demux emp-single \
  --i-seqs $HOME/Desktop/QIIME2/$name/emp/emp-single-end-sequences.qza \
  --m-barcodes-file $HOME/Desktop/QIIME2/$name/"$name"map.txt \
  --m-barcodes-category BarcodeSequence \
  --o-per-sample-sequences $HOME/Desktop/QIIME2/$name/demux/demux.qza \
  --quiet
  #
  qiime demux summarize \
  --i-data $HOME/Desktop/QIIME2/$name/demux/demux.qza \
  --o-visualization $HOME/Desktop/QIIME2/$name/demux/demux.qzv \
  --quiet
  #
  qiime tools export $HOME/Desktop/QIIME2/$name/demux/demux.qzv --output-dir  $HOME/Desktop/QIIME2/$name/demux/demux