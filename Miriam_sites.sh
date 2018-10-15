#!/bin/bash
source activate qiime2-2018.8 

# Filter the ASV table 
qiime feature-table filter-samples \
    --i-table dada2/table.qza \
    --m-metadata-file Sites/"$1"_core/*.tsv \
    --o-filtered-table Sites/"$1"_core/table.qza \
    
#qiime feature-table filter-samples \
#  --i-table dada2/table.qza \
#  --m-metadata-file miriammap.txt \
#  --p-where "Treatment='$1'" \
#  --o-filtered-table Sites/"$1"_core/table.qza

# Summarize the filtered ASV table and export so as to get sampling depth number 
qiime feature-table summarize \
  --i-table Sites/"$1"_core/table.qza \
  --o-visualization Sites/"$1"_core/table.qzv \
  --m-sample-metadata-file miriammap.txt 

qiime tools export --input-path Sites/"$1"_core/table.qzv --output-path Sites/"$1"_core/table

echo -e "\nEnter the sampling depth please\n"
read sam_in 

echo -e "\nObrigado Xuxa bom dia tudo bem.\n"

mkdir Sites/"$1"_core/diversity
mkdir Sites/"$1"_core/alpha-div
mkdir Sites/"$1"_core/beta-div
#
# Run the main core phylogenetic metrics plugin 
qiime diversity core-metrics \
  --i-table Sites/"$1"_core/table.qza \
  --p-sampling-depth $sam_in \
  --m-metadata-file miriammap.txt \
  --output-dir Sites/"$1"_core/core-metrics-results \
  --quiet
#
# Pielou Species Evenness 
qiime diversity alpha-group-significance \
  --i-alpha-diversity Sites/"$1"_core/core-metrics-results/evenness_vector.qza \
  --m-metadata-file miriammap.txt \
  --o-visualization Sites/"$1"_core/core-metrics-results/evenness-group-significance.qzv\
  --quiet
#
# Shannon's Species Richness 
qiime diversity alpha-group-significance \
  --i-alpha-diversity Sites/"$1"_core/core-metrics-results/shannon_vector.qza \
  --m-metadata-file miriammap.txt \
  --o-visualization Sites/"$1"_core/core-metrics-results/shannon-group-significance.qzv \
  --quiet
#
# Rarefaction curve plots 
qiime diversity alpha-rarefaction \
  --i-table Sites/"$1"_core/table.qza \
  --p-max-depth $sam_in \
  --m-metadata-file miriammap.txt \
  --o-visualization Sites/"$1"_core/alpha-div/alpha-rarefaction.qzv
#
# Export all visualisation plots 
qiime tools export --input-path Sites/"$1"_core/core-metrics-results/evenness-group-significance.qzv --output-path Sites/"$1"_core/alpha-div/pielou-evenness 
#
qiime tools export --input-path Sites/"$1"_core/core-metrics-results/shannon-group-significance.qzv --output-path Sites/"$1"_core/alpha-div/shannon-richness
#
qiime tools export --input-path Sites/"$1"_core/alpha-div/alpha-rarefaction.qzv --output-path Sites/"$1"_core/alpha-div/alpha-rarefaction

qiime emperor plot \
  --i-pcoa Sites/"$1"_core/core-metrics-results/bray_curtis_pcoa_results.qza \
  --m-metadata-file miriammap.txt \
  --o-visualization Sites/"$1"_core/core-metrics-results/bray-curtis-emperor.qzv \
  --quiet
#
qiime emperor plot \ 
  --i-pcoa Sites/"$1"_core//core-metrics-results/jaccard_pcoa_results.qza \
  --m-metadata-file miriammap.txt \
  --o-visualization Sites/"$1"_core/core-metrics-results/jaccard_emperor.qzv \
  --quiet
# Beta Group Significance 
qiime diversity beta-group-significance \
 --i-distance-matrix Sites/"$1"_core/core-metrics-results/bray_curtis_distance_matrix.qza \
 --m-metadata-file miriammap.txt \
 --m-metadata-column WithRD \
 --o-visualization Sites/"$1"_core/core-metrics-results/bray_curtis_treatment_significance.qzv \
 --p-pairwise \
 --quiet
#
qiime diversity beta-group-significance \
 --i-distance-matrix Sites/"$1"_core/core-metrics-results/jaccard_distance_matrix.qza \
 --m-metadata-file miriammap.txt \
 --m-metadata-column WithRD \
 --o-visualization Sites/"$1"_core/core-metrics-results/jaccard_treatment_significance.qzv \
 --p-pairwise \
 --quiet
# Export all figures 
qiime tools export --input-path Sites/"$1"_core/core-metrics-results/bray-curtis-emperor.qzv --output-path Sites/"$1"_core/beta-div/bray-curtis-pcoa
qiime tools export --input-path Sites/"$1"_core/core-metrics-results/bray_curtis_treatment_significance.qzv --output-path Sites/"$1"_core/beta-div/bray-curtis-significance
qiime tools export --input-path Sites/"$1"_core/core-metrics-results/jaccard_emperor.qzv --output-path Sites/"$1"_core/beta-div/jaccard-pcoa
qiime tools export --input-path Sites/"$1"_core/core-metrics-results/jaccard_treatment_significance.qzv --output-path Sites/"$1"_core/beta-div/jaccard-significance

# noice 
mkdir Sites/"$1"_core/gneiss                          # Make an output folder 
qiime feature-table filter-features \
    --i-table Sites/"$1"_core/table.qza \
    --p-min-frequency 10 \
    --o-filtered-table Sites/"$1"_core/table_10.qza

#
qiime gneiss correlation-clustering --i-table Sites/"$1"_core/table_10.qza --o-clustering Sites/"$1"_core/gneiss/hierarchy.qza
#
qiime gneiss ilr-hierarchical --i-table Sites/"$1"_core/table_10.qza --i-tree Sites/"$1"_core/gneiss/hierarchy.qza --o-balances Sites/"$1"_core/gneiss/balances.qza
#
qiime gneiss ols-regression --p-formula "WithRD" --i-table Sites/"$1"_core/gneiss/balances.qza --i-tree Sites/"$1"_core/gneiss/hierarchy.qza --m-metadata-file miriammap.txt --o-visualization Sites/"$1"_core/gneiss/regression_summary.qzv
#
qiime gneiss dendrogram-heatmap --i-table Sites/"$1"_core/table_10.qza --i-tree Sites/"$1"_core/gneiss/hierarchy.qza --m-metadata-file miriammap.txt --m-metadata-column WithRD --p-color-map seismic --o-visualization Sites/"$1"_core/gneiss/heatmap.qzv
#
qiime gneiss balance-taxonomy --i-table Sites/"$1"_core/table_10.qza --i-tree Sites/"$1"_core/gneiss/hierarchy.qza --i-taxonomy taxonomy/taxonomy.qza --p-taxa-level 4 --p-balance-name 'y0' --m-metadata-file miriammap.txt --m-metadata-column WithRD --o-visualization Sites/"$1"_core/gneiss/y0_taxa_summary.qzv
#
qiime gneiss balance-taxonomy --i-table Sites/"$1"_core/table_10.qza --i-tree Sites/"$1"_core/gneiss/hierarchy.qza --i-taxonomy taxonomy/taxonomy.qza --p-taxa-level 4 --p-balance-name 'y1' --m-metadata-file miriammap.txt --m-metadata-column WithRD --o-visualization Sites/"$1"_core/gneiss/y1_taxa_summary.qzv
# 
qiime tools export --input-path Sites/"$1"_core/gneiss/heatmap.qzv --output-path Sites/"$1"_core/gneiss/heatmap 
qiime tools export --input-path Sites/"$1"_core/gneiss/y0_taxa_summary.qzv --output-path Sites/"$1"_core/gneiss/y0_taxa_summary
qiime tools export --input-path Sites/"$1"_core/gneiss/y1_taxa_summary.qzv --output-path Sites/"$1"_core/gneiss/y1_taxa_summary
qiime tools export --input-path Sites/"$1"_core/gneiss/regression_summary.qzv --output-path Sites/"$1"_core/gneiss/regression_summary
