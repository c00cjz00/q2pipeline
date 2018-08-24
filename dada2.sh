#!/bin/bash
#Peter Leary
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
#
qiime feature-table summarize \
  --i-table $name/$sv/table.qza \
  --o-visualization $name/$sv/table.qzv \
  --m-sample-metadata-file $name/"$name"map.txt \
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
