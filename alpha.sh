#!/bin/bash
# QIIME 2 Ion Torrent Pipeline by Peter Leary
# Step 2.9 - Alpha diversity
# Make folders ready for export 
mkdir $name/diversity
mkdir $name/useful/alpha-div
mkdir $name/useful/beta-div
#
# Run the main core phylogenetic metrics plugin 
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny $name/aligned/rooted-tree.qza \
  --i-table $name/$sv/table.qza \
  --p-sampling-depth $sam \
  --m-metadata-file $name/"$name"map.txt \
  --output-dir $name/diversity/core-metrics-results \
  --quiet
#
# Faith PD 
qiime diversity alpha-group-significance \
  --i-alpha-diversity $name/diversity/core-metrics-results/faith_pd_vector.qza \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/diversity/core-metrics-results/faith-pd-group-significance.qzv \
  --quiet
#
# Pielou Species Evenness 
qiime diversity alpha-group-significance \
  --i-alpha-diversity $name/diversity/core-metrics-results/evenness_vector.qza \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/diversity/core-metrics-results/evenness-group-significance.qzv\
  --quiet
#
# Shannon's Species Richness 
qiime diversity alpha-group-significance \
  --i-alpha-diversity $name/diversity/core-metrics-results/shannon_vector.qza \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/diversity/core-metrics-results/shannon-group-significance.qzv \
  --quiet
#
# Rarefaction curve plots 
qiime diversity alpha-rarefaction \
  --i-table $name/$sv/table.qza \
  --i-phylogeny $name/aligned/rooted-tree.qza \
  --p-max-depth $sam \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/diversity/alpha-rarefaction.qzv
#
# Export all visualisation plots 
qiime tools export --input-path $name/diversity/core-metrics-results/faith-pd-group-significance.qzv --output-path $name/useful/alpha-div/faith-pd
#
qiime tools export --input-path $name/diversity/core-metrics-results/evenness-group-significance.qzv --output-path $name/useful/alpha-div/pielou-evenness 
#
qiime tools export --input-path $name/diversity/core-metrics-results/shannon-group-significance.qzv --output-path $name/useful/alpha-div/shannon-richness
#
qiime tools export --input-path $name/diversity/alpha-rarefaction.qzv --output-path $name/useful/alpha-div/alpha-rarefaction
