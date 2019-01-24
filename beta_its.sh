#!/bin/bash
# QIIME 2 Pipeline by Peter Leary

# Bray Curtis (weighted) PCoA Plot 
qiime emperor plot \
  --i-pcoa $name/diversity/core-metrics-results/bray_curtis_pcoa_results.qza \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/diversity/core-metrics-results/bray-curtis-emperor.qzv \
  --quiet

qiime emperor plot \ 
  --i-pcoa $name/diversity/core-metrics-results/jaccard_pcoa_results.qza \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/diversity/core-metrics-results/jaccard_emperor.qzv \
  --quiet
  
# Beta Group Significance 
qiime diversity beta-group-significance \
 --i-distance-matrix $name/diversity/core-metrics-results/bray_curtis_distance_matrix.qza \
 --m-metadata-file $name/"$name"map.txt \
 --m-metadata-column Treatment \
 --o-visualization $name/diversity/core-metrics-results/bray_curtis_treatment_significance.qzv \
 --p-pairwise \
 --quiet
 
qiime diversity beta-group-significance \
 --i-distance-matrix $name/diversity/core-metrics-results/jaccard_distance_matrix.qza \
 --m-metadata-file $name/"$name"map.txt \
 --m-metadata-column Treatment \
 --o-visualization $name/diversity/core-metrics-results/jaccard_treatment_significance.qzv \
 --p-pairwise \
 --quiet
 
# Export all figures 
qiime tools export --input-path $name/diversity/core-metrics-results/bray-curtis-emperor.qzv --output-path $name/useful/beta-div/bray-curtis-pcoa
qiime tools export --input-path $name/diversity/core-metrics-results/bray_curtis_treatment_significance.qzv --output-path $name/useful/beta-div/bray-curtis-significance
qiime tools export --input-path $name/diversity/core-metrics-results/jaccard_emperor.qzv --output-path $name/useful/beta-div/jaccard-pcoa
qiime tools export --input-path $name/diversity/core-metrics-results/jaccard_treatment_significance.qzv --output-path $name/useful/beta-div/jaccard-significance