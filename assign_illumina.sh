#!/bin/bash
# QIIME 2 Pipeline by Peter Leary

mkdir $name/taxonomy 
if [[ "$gene" == "16S" ]]; then
qiime feature-classifier classify-sklearn \
  --i-classifier classifiers/illumina_16S/*.qza \
  --i-reads $name/$sv/rep-seqs.qza \
  --o-classification $name/taxonomy/taxonomy.qza \
  --p-n-jobs $athreads \
  --quiet
fi
if [[ "$gene" == "ITS" ]]; then
qiime feature-classifier classify-sklearn \
  --i-classifier classifiers/illumina_ITS/*.qza \
  --i-reads $name/$sv/rep-seqs.qza \
  --o-classification $name/taxonomy/taxonomy.qza \
  --p-n-jobs $athreads \
  --quiet
fi

qiime metadata tabulate \
  --m-input-file $name/taxonomy/taxonomy.qza \
  --o-visualization $name/taxonomy/taxonomy.qzv \
  --quiet

qiime taxa barplot \
  --i-table $name/$sv/table.qza \
  --i-taxonomy $name/taxonomy/taxonomy.qza \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/taxonomy/taxa-bar-plots.qzv \
  --quiet

qiime feature-table filter-features \
--i-table $name/$sv/table.qza \
--p-min-frequency 500 \
--o-filtered-table $name/$sv/table-500.qza \
--quiet 

qiime taxa barplot \
  --i-table $name/$sv/table-500.qza \
  --i-taxonomy $name/taxonomy/taxonomy.qza \
  --m-metadata-file $name/"$name"map.txt \
  --o-visualization $name/taxonomy/taxa-bar-plots-500.qzv \
  --quiet

qiime tools export --input-path $name/taxonomy/taxa-bar-plots.qzv --output-path $name/useful/taxa-bar-plots
qiime tools export --input-path $name/taxonomy/taxa-bar-plots-500.qzv --output-path $name/useful/taxa-bar-plots-500
qiime tools export --input-path $name/taxonomy/taxonomy.qza --output-path $name/useful/
biom add-metadata -i $name/useful/biomtable/feature-table.biom -o $name/useful/biomtable/feature-table-tax.biom --observation-metadata-fp $name/useful/taxonomy.tsv --observation-header OTUID,taxonomy --sc-separated taxonomy
biom convert -i $name/useful/biomtable/feature-table-tax.biom -o $name/useful/biomtable/otu_table_w_tax.txt --to-tsv --table-type="OTU table" --header-key taxonomy
biom convert -i $name/useful/biomtable/feature-table.biom -o $name/useful/biomtable/otu_table.txt --to-tsv --table-type="OTU table"