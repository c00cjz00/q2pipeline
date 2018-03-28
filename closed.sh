#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
qiime vsearch cluster-features-closed-reference \
--i-sequences ~/Desktop/qiime2/$name/$sv/rep-seqs.qza \
--i-table ~/Desktop/qiime2/$name/$sv/table.qza \
--i-reference-sequences ~/Desktop/qiime2/silva/silva119/99_otus.qza \
--p-perc-identity 0.99 \
--p-threads 8 \
--output-dir $HOME/Desktop/qiime2/$name/closed \
--quiet
#
mkdir $HOME/Desktop/qiime2/$name/useful/closed
#
qiime tools export $HOME/Desktop/qiime2/$name/closed/clustered_table.qza --output-dir $HOME/Desktop/qiime2/$name/closed/clustered-table
#
qiime tools export $HOME/Desktop/qiime2/$name/closed/clustered_sequences.qza --output-dir $HOME/Desktop/qiime2/$name/closed/clustered-sequences
#
biom add-metadata -i $HOME/Desktop/QIIME2/$name/closed/clustered-table/feature-table.biom -o $HOME/Desktop/QIIME2/$name/closed/clustered-table/feature-table-tax.biom --observation-metadata-fp ~/Desktop/qiime2/silva/silva119/taxonomy_99_7_levels.txt --observation-header OTUID,taxonomy --sc-separated taxonomy
#
biom convert -i $HOME/Desktop/qiime2/$name/closed/clustered-table/feature-table-tax.biom -o $HOME/Desktop/qiime2/$name/closed/clustered-table/feature-table-tax.txt --to-tsv --header-key taxonomy --table-type="OTU table"
#
cp $HOME/Desktop/qiime2/$name/closed/clustered-table/feature-table-tax.txt $HOME/Desktop/qiime2/$name/useful/closed/feature-table-tax.txt
#
cp $HOME/Desktop/qiime2/$name/closed/clustered-sequences/dna-sequences.fasta $HOME/Desktop/qiime2/$name/useful/closed/dna-sequences.fasta
#
cp $HOME/Desktop/qiime2/$name/useful/closed/feature-table-tax.txt $HOME/Desktop/qiime2/$name/useful/closed/feature-table-tax4fun.txt
#
sed -i '' 's/D_0__//;s/D_1__//;s/D_2__//;s/D_3__//;s/D_4__//;s/D_5__//;s/D_6__//' $HOME/Desktop/qiime2/$name/useful/closed/feature-table-tax4fun.txt