#!/bin/bash 
# Peter Leary 
# QIIME 2 Pipeline –– Gneiss Differential Abundance -- https://docs.qiime2.org/2018.4/tutorials/gneiss/
#
mkdir $name/gneiss                          # Make an output folder 
#
qiime gneiss add-pseudocount --i-table $name/$sv/table-500.qza --p-pseudocount 1 --o-composition-table $name/gneiss/composition.qza
#
qiime gneiss correlation-clustering --i-table $name/gneiss/composition.qza --o-clustering $name/gneiss/hierarchy.qza
#
qiime gneiss ilr-transform --i-table $name/gneiss/composition.qza --i-tree $name/gneiss/hierarchy.qza --o-balances $name/gneiss/balances.qza
#
qiime gneiss ols-regression --p-formula "$column" --i-table $name/gneiss/balances.qza --i-tree $name/gneiss/hierarchy.qza --m-metadata-file $name/"$name"map.txt --o-visualization $name/gneiss/regression_summary.qzv
#
qiime gneiss dendrogram-heatmap --i-table $name/gneiss/composition.qza --i-tree $name/gneiss/hierarchy.qza --m-metadata-file $name/"$name"map.txt --m-metadata-column $column --p-color-map seismic --o-visualization $name/gneiss/heatmap.qzv
#
qiime gneiss balance-taxonomy --i-table $name/gneiss/composition.qza --i-tree $name/gneiss/hierarchy.qza --i-taxonomy $name/taxonomy/taxonomy.qza --p-taxa-level 4 --p-balance-name 'y0' --m-metadata-file $name/"$name"map.txt --m-metadata-column $column --o-visualization $name/gneiss/y0_taxa_summary.qzv
# 
mkdir $name/useful/gneiss  
qiime tools export $name/gneiss/heatmap.qzv --output-dir $name/useful/gneiss/heatmap 
qiime tools export $name/gneiss/y0_taxa_summary.qzv --output-dir $name/useful/gneiss/y0_taxa_summary
qiime tools export $name/gneiss/regression_summary.qzv --output-dir $name/useful/gneiss/regression_summary
