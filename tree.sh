#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.7 - Creating unrooted and midrooted phylogenetic trees 
qiime phylogeny fasttree \
  --i-alignment $HOME/Desktop/QIIME2/$name/aligned/masked-aligned-rep-seqs.qza \
  --o-tree $HOME/Desktop/QIIME2/$name/aligned/unrooted-tree.qza \
  --quiet
#
qiime phylogeny midpoint-root \
  --i-tree $HOME/Desktop/QIIME2/$name/aligned/unrooted-tree.qza \
  --o-rooted-tree $HOME/Desktop/QIIME2/$name/aligned/rooted-tree.qza \
  --quiet
#