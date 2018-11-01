#!/bin/bash
#Peter Leary
mkdir $name/dada2
if [[ "$gene" == "16S" ]]; then
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs $name/demux/demux.qza \
  --o-table $name/dada2/table \
  --o-representative-sequences $name/dada2/rep-seqs \
  --o-denoising-stats $name/$sv/stats.qza \
  --p-trim-left-f $trimleft \
  --p-trim-left-r $trimleft \
  --p-trunc-len-f $trunclen \
  --p-trunc-len-r $truncrev \
  --p-n-threads $threads
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
qiime tools export --input-path $name/$sv/table.qzv --output-path $name/useful/table
#
qiime tools export --input-path $name/$sv/table.qza --output-path $name/useful/biomtable
#
qiime tools export --input-path $name/$sv/rep-seqs.qzv --output-path $name/useful/rep-seqs
#
cp $name/useful/rep-seqs/dna-sequences.fasta $name/useful/rep-seqs/rep-seqs.txt
fi
#
if [[ "$gene" == "ITS" ]]; then 
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs $name/demux/trim.qza \
  --o-table $name/dada2/table \
  --o-representative-sequences $name/dada2/rep-seqs \
  --o-denoising-stats $name/$sv/stats.qza \
  --p-trunc-len-f 0 \
  --p-trunc-len-r 0 \
  --p-n-threads $threads \
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
qiime tools export --input-path $name/$sv/table.qzv --output-path $name/useful/table
#
qiime tools export --input-path $name/$sv/table.qza --output-path $name/useful/biomtable
#
qiime tools export --input-path $name/dada2/rep-seqs.qza --output-path $name/useful/rep-seqs
#
cp $name/useful/rep-seqs/dna-sequences.fasta $name/useful/rep-seqs/rep-seqs.txt
fi