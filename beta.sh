#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.9.1 - Beta diversity
#
# Unweighted UniFrac PCoA Plot 
qiime emperor plot \
  --i-pcoa $name/diversity/core-metrics-results/unweighted_unifrac_pcoa_results.qza \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/diversity/core-metrics-results/unweighted-unifrac-emperor.qzv \
  --quiet
#
# Bray Curtis (weighted) PCoA Plot 
qiime emperor plot \
  --i-pcoa $name/diversity/core-metrics-results/bray_curtis_pcoa_results.qza \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/diversity/core-metrics-results/bray-curtis-emperor.qzv \
  --quiet
#
# Beta Group Significance 
qiime diversity beta-group-significance \
 --i-distance-matrix $name/diversity/core-metrics-results/unweighted_unifrac_distance_matrix.qza \
 --m-metadata-file $name/"$name"map.txt \
 --m-metadata-column Treatment \
 --o-visualization $name/diversity/core-metrics-results/unweighted_unifrac_treatment_significance.qzv \
 --p-pairwise \
 --quiet
#
qiime diversity beta-group-significance \
 --i-distance-matrix $name/diversity/core-metrics-results/bray_curtis_distance_matrix.qza \
 --m-metadata-file $name/"$name"map.txt \
 --m-metadata-column Treatment \
 --o-visualization $name/diversity/core-metrics-results/bray_curtis_treatment_significance.qzv \
 --p-pairwise \
 --quiet
#
# Export all figures 
qiime tools export $name/diversity/core-metrics-results/unweighted-unifrac-emperor.qzv --output-dir $name/useful/beta-div/unweighted-unifrac-pcoa
#
qiime tools export $name/diversity/core-metrics-results/bray-curtis-emperor.qzv --output-dir $name/useful/beta-div/bray-curtis-pcoa
#
qiime tools export $name/diversity/core-metrics-results/unweighted_unifrac_treatment_significance.qzv --output-dir $name/useful/beta-div/unweighted-unifrac-significance
#
qiime tools export $name/diversity/core-metrics-results/bray_curtis_treatment_significance.qzv --output-dir $name/useful/beta-div/bray-curtis-significance
