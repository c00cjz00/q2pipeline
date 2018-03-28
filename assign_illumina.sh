#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.6 - Assigning taxonomy 
# Some reason, attempting to visualize or assign taxonomy to aligned seqs doesn't work, it just bugs out. The main guide makes no allusion to assigning taxonomy to aligned seqs so I guess we don't need to worry for now.
mkdir $HOME/Desktop/QIIME2/$name/taxonomy 
qiime feature-classifier classify-sklearn \
  --i-classifier $HOME/Desktop/QIIME2/silva/illumina/classifiers/132classifier251_99.qza \
  --i-reads $HOME/Desktop/QIIME2/$name/$sv/rep-seqs.qza \
  --o-classification $HOME/Desktop/QIIME2/$name/taxonomy/taxonomy.qza \
  --p-n-jobs -1 \
  --quiet
#
qiime metadata tabulate \
  --m-input-file $HOME/Desktop/QIIME2/$name/taxonomy/taxonomy.qza \
  --o-visualization $HOME/Desktop/QIIME2/$name/taxonomy/taxonomy.qzv \
  --quiet
#
qiime taxa barplot \
  --i-table $HOME/Desktop/QIIME2/$name/$sv/table.qza \
  --i-taxonomy $HOME/Desktop/QIIME2/$name/taxonomy/taxonomy.qza \
  --m-metadata-file $HOME/Desktop/QIIME2/$name/"$name"map.txt \
  --o-visualization $HOME/Desktop/QIIME2/$name/taxonomy/taxa-bar-plots.qzv \
  --quiet
#
qiime feature-table filter-features \
--i-table $HOME/Desktop/QIIME2/$name/$sv/table.qza \
--p-min-frequency 500 \
--o-filtered-table $HOME/Desktop/QIIME2/$name/$sv/table-500.qza \
--quiet 
#
qiime taxa barplot \
  --i-table $HOME/Desktop/QIIME2/$name/$sv/table-500.qza \
  --i-taxonomy $HOME/Desktop/QIIME2/$name/taxonomy/taxonomy.qza \
  --m-metadata-file $HOME/Desktop/QIIME2/$name/"$name"map.txt \
  --o-visualization $HOME/Desktop/QIIME2/$name/taxonomy/taxa-bar-plots-500.qzv \
  --quiet
#
qiime tools export $HOME/Desktop/QIIME2/$name/taxonomy/taxa-bar-plots.qzv --output-dir $HOME/Desktop/QIIME2/$name/useful/taxa-bar-plots
qiime tools export $HOME/Desktop/QIIME2/$name/taxonomy/taxa-bar-plots-500.qzv --output-dir $HOME/Desktop/QIIME2/$name/useful/taxa-bar-plots-500
qiime tools export $HOME/Desktop/QIIME2/$name/taxonomy/taxonomy.qza --output-dir $HOME/Desktop/QIIME2/$name/useful/
biom add-metadata -i $HOME/Desktop/QIIME2/$name/useful/biomtable/feature-table.biom -o $HOME/Desktop/QIIME2/$name/useful/biomtable/feature-table-tax.biom --observation-metadata-fp $HOME/Desktop/QIIME2/$name/useful/taxonomy.tsv --observation-header OTUID,taxonomy --sc-separated taxonomy
biom convert -i $HOME/Desktop/QIIME2/$name/useful/biomtable/feature-table-tax.biom -o $HOME/Desktop/QIIME2/$name/useful/biomtable/otu_table_w_tax.txt --to-tsv --table-type="OTU table" --header-key taxonomy
#