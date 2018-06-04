#!/bin/bash 
# Peter Leary 
# QIIME 2 Pipeline –– Gneiss Differential Abundance -- https://docs.qiime2.org/2018.4/tutorials/gneiss/

mkdir $name/gneiss                          # Make an output folder 

qiime gneiss add-pseudocount \              # Adds 1 to every ASV abundance because you can't log zero 
  --i-table $name/$sv/table.qza \
  --p-pseudocount 1 \
  --o-composition-table $name/gneiss/composition.qza

qiime gneiss correlation-clustering \       # Clustering of ASVs to get Principle Balances 
  --i-table $name/gneiss/composition.qza \
  --o-clustering $name/gneiss/hierarchy.qza

qiime gneiss ilr-transform \                # ILR transformation: log ratios 
  --i-table $name/gneiss/composition.qza \
  --i-tree $name/gneiss/hierarchy.qza \
  --o-balances $name/gneiss/balances.qza

qiime gneiss ols-regression \               # God now I've no idea anymore 
  --p-formula "Treatment" \
  --i-table $name/gneiss/balances.qza \
  --i-tree $name/gneiss/hierarchy.qza \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/gneiss/regression_summary.qzv

qiime gneiss dendrogram-heatmap \           # More magic 
  --i-table $name/gneiss/composition.qza \
  --i-tree $name/gneiss/hierarchy.qza \
  --m-metadata-file $name/"$name"map.txt \
  --m-metadata-column Treatment \
  --p-color-map seismic \
  --o-visualization $name/gneiss/heatmap.qzv

qiime gneiss balance-taxonomy \             # Magic as above but for taxons insteady of ASV
  --i-table $name/gneiss/composition.qza \
  --i-tree $name/gneiss/hierarchy.qza \
  --i-taxonomy $name/taxonomy/taxonomy.qza \
  --p-taxa-level 4 \
  --p-balance-name 'y0' \
  --m-metadata-file $name/"$name"map.txt \
  --m-metadata-column Treatment \
  --o-visualization $name/gneiss/y0_taxa_summary.qzv
  
mkdir $name/useful/gneiss  
qiime tools export $name/gneiss/heatmap.qzv --output-dir $name/useful/gneiss/heatmap 
qiime tools export $name/gneiss/y0_taxa_summary.qzv --output-dir $name/useful/gneiss/y0_taxa_summary
qiime tools export $name/gneiss/regression_summary.qzv --output-dir $name/useful/gneiss/regression_summary
