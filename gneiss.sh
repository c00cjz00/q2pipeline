#!/bin/bash 
# Peter Leary 
# QIIME 2 Pipeline –– Gneiss Differential Abundance -- https://docs.qiime2.org/2018.4/tutorials/gneiss/
# Some reason, when I line break with \, it does not work..? 

mkdir $name/gneiss                          # Make an output folder 

qiime gneiss correlation-clustering --i-table $name/dada2/table.qza --o-clustering $name/gneiss/hierarchy.qza

qiime gneiss ilr-hierarchical --i-table $name/dada2/table.qza --i-tree $name/gneiss/hierarchy.qza --o-balances $name/gneiss/balances.qza

qiime gneiss ols-regression --p-formula "$column" --i-table $name/gneiss/balances.qza --i-tree $name/gneiss/hierarchy.qza --m-metadata-file $name/"$name"map.txt --o-visualization $name/gneiss/regression_summary.qzv

qiime gneiss dendrogram-heatmap --i-table $name/dada2/table.qza --i-tree $name/gneiss/hierarchy.qza --m-metadata-file $name/"$name"map.txt --m-metadata-column $column --p-color-map seismic --o-visualization $name/gneiss/heatmap.qzv

qiime gneiss balance-taxonomy --i-table $name/dada2/table.qza --i-tree $name/gneiss/hierarchy.qza --i-taxonomy $name/taxonomy/taxonomy.qza --p-taxa-level 4 --p-balance-name 'y0' --m-metadata-file $name/"$name"map.txt --m-metadata-column $column --o-visualization $name/gneiss/y0_taxa_summary.qzv

qiime gneiss balance-taxonomy --i-table $name/dada2/table.qza --i-tree $name/gneiss/hierarchy.qza --i-taxonomy $name/taxonomy/taxonomy.qza --p-taxa-level 4 --p-balance-name 'y1' --m-metadata-file $name/"$name"map.txt --m-metadata-column $column --o-visualization $name/gneiss/y1_taxa_summary.qzv

qiime gneiss balance-taxonomy --i-table $name/dada2/table.qza --i-tree $name/gneiss/hierarchy.qza --i-taxonomy $name/taxonomy/taxonomy.qza --p-taxa-level 4 --p-balance-name 'y2' --m-metadata-file $name/"$name"map.txt --m-metadata-column $column --o-visualization $name/gneiss/y2_taxa_summary.qzv

mkdir $name/useful/gneiss  
qiime tools export --input-path $name/gneiss/heatmap.qzv --output-path $name/useful/gneiss/heatmap 
qiime tools export --input-path $name/gneiss/y0_taxa_summary.qzv --output-path $name/useful/gneiss/y0_taxa_summary
qiime tools export --input-path $name/gneiss/y1_taxa_summary.qzv --output-path $name/useful/gneiss/y1_taxa_summary
qiime tools export --input-path $name/gneiss/y2_taxa_summary.qzv --output-path $name/useful/gneiss/y2_taxa_summary
qiime tools export --input-path $name/gneiss/regression_summary.qzv --output-path $name/useful/gneiss/regression_summary
