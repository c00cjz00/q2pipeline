#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.6 - Assigning taxonomy 
# Some reason, attempting to visualize or assign taxonomy to aligned seqs doesn't work, it just bugs out. The main guide makes no allusion to assigning taxonomy to aligned seqs so I guess we don't need to worry for now.
mkdir ../$name/taxonomy 
qiime feature-classifier classify-sklearn \
  --i-classifier ../classifiers/iontorrent/*.qza \
  --i-reads ../$name/$sv/rep-seqs.qza \
  --o-classification ../$name/taxonomy/taxonomy.qza \
  --p-n-jobs -1 \
  --quiet
#
qiime metadata tabulate \
  --m-input-file ../$name/taxonomy/taxonomy.qza \
  --o-visualization ../$name/taxonomy/taxonomy.qzv \
  --quiet
#
qiime taxa barplot \
  --i-table ../$name/$sv/table.qza \
  --i-taxonomy ../$name/taxonomy/taxonomy.qza \
  --m-metadata-file ../$name/"$name"map.txt \
  --o-visualization ../$name/taxonomy/taxa-bar-plots.qzv \
  --quiet
#
qiime feature-table filter-features \
--i-table ../$name/$sv/table.qza \
--p-min-frequency 500 \
--o-filtered-table ../$name/$sv/table-500.qza \
--quiet 
#
qiime taxa barplot \
  --i-table ../$name/$sv/table-500.qza \
  --i-taxonomy ../$name/taxonomy/taxonomy.qza \
  --m-metadata-file ../$name/"$name"map.txt \
  --o-visualization ../$name/taxonomy/taxa-bar-plots-500.qzv \
  --quiet
#
qiime tools export ../$name/taxonomy/taxa-bar-plots.qzv --output-dir ../$name/useful/taxa-bar-plots
qiime tools export ../$name/taxonomy/taxa-bar-plots-500.qzv --output-dir ../$name/useful/taxa-bar-plots-500
qiime tools export ../$name/taxonomy/taxonomy.qza --output-dir ../$name/useful/
biom add-metadata -i ../$name/useful/biomtable/feature-table.biom -o ../$name/useful/biomtable/feature-table-tax.biom --observation-metadata-fp ../$name/useful/taxonomy.tsv --observation-header OTUID,taxonomy --sc-separated taxonomy
biom convert -i ../$name/useful/biomtable/feature-table-tax.biom -o ../$name/useful/biomtable/otu_table_w_tax.txt --to-tsv --table-type="OTU table" --header-key taxonomy
#
