#!/bin/bash
# QIIME 2 Pipeline by Peter Leary

mkdir $name/$sv

if [[ "$gene" == "16S" ]]; then
qiime dada2 denoise-single \
  --i-demultiplexed-seqs $name/demux/demux.qza \
  --p-trim-left $trimleft \
  --p-trunc-len $trunclen \
  --o-representative-sequences $name/$sv/rep-seqs.qza \
  --o-table $name/$sv/table.qza \
  --o-denoising-stats $name/$sv/stats.qza \
  --p-n-threads $threads \
  --p-max-ee 5 \
  --quiet
fi
if [[ "$gene" == "ITS" ]]; then
qiime dada2 denoise-single \
  --i-demultiplexed-seqs $name/demux/demux.qza \
  --p-trim-left $trimleft \
  --p-trunc-len 0 \
  --o-representative-sequences $name/$sv/rep-seqs.qza \
  --o-table $name/$sv/table.qza \
  --o-denoising-stats $name/$sv/stats.qza \
  --p-n-threads $threads \
  --p-max-ee 5 \
  --quiet
fi
