#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.2 - Demultiplexing samples
mkdir $name/demux
qiime demux emp-single \
  --i-seqs $name/emp/emp-single-end-sequences.qza \
  --m-barcodes-file $name/"$name"map.txt \
  --m-barcodes-column BarcodeSequence \
  --o-per-sample-sequences $name/demux/demux.qza \
  --quiet
  #
  qiime demux summarize \
  --i-data $name/demux/demux.qza \
  --o-visualization $name/demux/demux.qzv \
  --quiet
  #
  qiime tools export --input-path $name/demux/demux.qzv --output-path  $name/demux/demux
