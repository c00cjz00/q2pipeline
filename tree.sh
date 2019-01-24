#!/bin/bash
# QIIME 2 Pipeline by Peter Leary

qiime phylogeny fasttree \
  --i-alignment $name/aligned/masked-aligned-rep-seqs.qza \
  --o-tree $name/aligned/unrooted-tree.qza \
  --p-n-threads $threads \
  --quiet

qiime phylogeny midpoint-root \
  --i-tree $name/aligned/unrooted-tree.qza \
  --o-rooted-tree $name/aligned/rooted-tree.qza \
  --quiet