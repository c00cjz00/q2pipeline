#!/bin/bash

# QIIME2 pipeline by Peter Leary 


qiime feature-table summarize \
  --i-table $name/$sv/table.qza \
  --o-visualization $name/$sv/table.qzv \
  --m-sample-metadata-file $name/"$name"map.txt \
  --quiet

qiime feature-table tabulate-seqs \
  --i-data $name/$sv/rep-seqs.qza \
  --o-visualization $name/$sv/rep-seqs.qzv \
  --quiet

qiime tools export --input-path $name/$sv/table.qzv --output-path $name/useful/table
qiime tools export --input-path $name/$sv/table.qza --output-path $name/useful/biomtable
qiime tools export --input-path $name/$sv/rep-seqs.qzv --output-path $name/useful/rep-seqs
cp $name/useful/rep-seqs/sequences.fasta $name/useful/rep-seqs/rep-seqs.txt
biom convert -i $name/useful/biomtable/feature-table.biom -o $name/useful/biomtable/otu_table.txt --to-tsv --table-type="OTU table"