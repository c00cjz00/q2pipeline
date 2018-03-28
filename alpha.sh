#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.9 - Alpha diversity
mkdir $HOME/Desktop/QIIME2/$name/diversity
mkdir $HOME/Desktop/QIIME2/$name/useful/alpha-div
mkdir $HOME/Desktop/QIIME2/$name/useful/beta-div
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny $HOME/Desktop/QIIME2/$name/aligned/rooted-tree.qza \
  --i-table $HOME/Desktop/QIIME2/$name/$sv/table.qza \
  --p-sampling-depth $sam \
  --m-metadata-file $HOME/Desktop/QIIME2/$name/"$name"map.txt \
  --output-dir $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results \
  --quiet
#
qiime diversity alpha-group-significance \
  --i-alpha-diversity $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file $HOME/Desktop/QIIME2/$name/"$name"map.txt \
  --o-visualization $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/faith-pd-group-significance.qzv \
  --quiet
#
qiime diversity alpha-group-significance \
  --i-alpha-diversity $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/evenness_vector.qza \
  --m-metadata-file $HOME/Desktop/QIIME2/$name/"$name"map.txt \
  --o-visualization $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/evenness-group-significance.qzv\
  --quiet
#
qiime diversity alpha-rarefaction \
  --i-table $HOME/Desktop/QIIME2/$name/$sv/table.qza \
  --i-phylogeny $HOME/Desktop/QIIME2/$name/aligned/rooted-tree.qza \
  --p-max-depth $sam \
  --m-metadata-file $HOME/Desktop/QIIME2/$name/"$name"map.txt \
  --o-visualization $HOME/Desktop/QIIME2/$name/diversity/alpha-rarefaction.qzv
#
qiime tools export $HOME/Desktop/QIIME2/$name/diversity/alpha-rarefaction.qzv --output-dir $HOME/Desktop/QIIME2/$name/useful/alpha-div/alpha-rarefaction