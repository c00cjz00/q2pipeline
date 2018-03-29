#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.9 - Alpha diversity
mkdir $name/diversity
mkdir $name/useful/alpha-div
mkdir $name/useful/beta-div
#
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny $name/aligned/rooted-tree.qza \
  --i-table $name/$sv/table.qza \
  --p-sampling-depth $sam \
  --m-metadata-file $name/"$name"map.txt \
  --output-dir $name/diversity/core-metrics-results \
  --quiet
#
qiime diversity alpha-group-significance \
  --i-alpha-diversity $name/diversity/core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/diversity/core-metrics-results/faith-pd-group-significance.qzv \
  --quiet
#
qiime diversity alpha-group-significance \
  --i-alpha-diversity $name/diversity/core-metrics-results/evenness_vector.qza \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/diversity/core-metrics-results/evenness-group-significance.qzv\
  --quiet
#
qiime diversity alpha-rarefaction \
  --i-table $name/$sv/table.qza \
  --i-phylogeny $name/aligned/rooted-tree.qza \
  --p-max-depth $sam \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/diversity/alpha-rarefaction.qzv
#
qiime tools export $name/diversity/alpha-rarefaction.qzv --output-dir $name/useful/alpha-div/alpha-rarefaction
