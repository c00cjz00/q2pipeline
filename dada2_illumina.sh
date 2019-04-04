#!/bin/bash
# QIIME 2 Pipeline by Peter Leary

mkdir $name/$sv

if [[ "$gene" == "16S" ]] || [[ "$gene" == "18S" ]]; then
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs $name/demux/demux.qza \
  --o-table $name/$sv/table \
  --o-representative-sequences $name/$sv/rep-seqs \
  --o-denoising-stats $name/$sv/stats.qza \
  --p-trim-left-f $trimleft \
  --p-trim-left-r $trimleft \
  --p-trunc-len-f $trunclen \
  --p-trunc-len-r $truncrev \
  --p-n-threads $threads
  --quiet
fi


if [[ "$gene" == "ITS" ]]; then 
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs $name/demux/trim.qza \
  --o-table $name/$sv/table \
  --o-representative-sequences $name/$sv/rep-seqs \
  --o-denoising-stats $name/$sv/stats.qza \
  --p-trunc-len-f 0 \
  --p-trunc-len-r 0 \
  --p-n-threads $threads \
  --p-max-ee 5 \
  --quiet
fi