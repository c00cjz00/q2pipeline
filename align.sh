#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.5 - Aligning
mkdir ../$name/aligned
qiime alignment mafft \
  --i-sequences ../$name/$sv/rep-seqs.qza \
  --o-alignment ../$name/aligned/aligned-rep-seqs.qza \
  --p-n-threads $threads \
  --quiet
#
qiime alignment mask \
  --i-alignment ../$name/aligned/aligned-rep-seqs.qza \
  --o-masked-alignment ../$name/aligned/masked-aligned-rep-seqs.qza \
  --quiet
