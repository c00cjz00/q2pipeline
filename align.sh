#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.5 - Aligning
mkdir $HOME/Desktop/QIIME2/$name/aligned
qiime alignment mafft \
  --i-sequences $HOME/Desktop/QIIME2/$name/$sv/rep-seqs.qza \
  --o-alignment $HOME/Desktop/QIIME2/$name/aligned/aligned-rep-seqs.qza \
  --p-n-threads 8 \
  --quiet
#
qiime alignment mask \
  --i-alignment $HOME/Desktop/QIIME2/$name/aligned/aligned-rep-seqs.qza \
  --o-masked-alignment $HOME/Desktop/QIIME2/$name/aligned/masked-aligned-rep-seqs.qza \
  --quiet