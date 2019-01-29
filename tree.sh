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
  
qiime tools export --input-path $name/aligned/unrooted-tree.qza --output-path $name/aligned/unrooted-tree
qiime tools export --input-path $name/aligned/rooted-tree.qza --output-path $name/aligned/rooted-tree

mkdir $name/useful/trees 
cp $name/aligned/unrooted-tree/tree.nwk $name/useful/trees/unrooted_tree.nwk 
cp $name/aligned/rooted-tree/tree.nwk $name/useful/trees/rooted_tree.nwk 