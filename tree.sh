#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.7 - Creating unrooted and midrooted phylogenetic trees 
qiime phylogeny fasttree \
  --i-alignment $name/aligned/masked-aligned-rep-seqs.qza \
  --o-tree $name/aligned/unrooted-tree.qza \
  --p-n-threads -1 \
  --quiet
#
qiime phylogeny midpoint-root \
  --i-tree $name/aligned/unrooted-tree.qza \
  --o-rooted-tree $name/aligned/rooted-tree.qza \
  --quiet
#
