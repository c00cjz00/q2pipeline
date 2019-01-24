#!/bin/bash
# QIIME 2 Pipeline by Peter Leary

qiime vsearch cluster-features-closed-reference \
--i-sequences $name/$sv/rep-seqs.qza \
--i-table $name/$sv/table.qza \
--i-reference-sequences classifiers/silva119/*.qza \
--p-perc-identity 0.99 \
--p-threads $threads \
--output-dir $name/closed \
--quiet

mkdir $name/useful/closed

qiime tools export --input-path $name/closed/clustered_table.qza --output-path $name/closed/clustered-table

qiime tools export --input-path $name/closed/clustered_sequences.qza --output-path $name/closed/clustered-sequences

biom add-metadata -i $name/closed/clustered-table/feature-table.biom -o $name/closed/clustered-table/feature-table-tax.biom --observation-metadata-fp classifiers/silva119/*.txt --observation-header OTUID,taxonomy --sc-separated taxonomy

biom convert -i $name/closed/clustered-table/feature-table-tax.biom -o $name/closed/clustered-table/feature-table-tax.txt --to-tsv --header-key taxonomy --table-type="OTU table"

cp $name/closed/clustered-table/feature-table-tax.txt $name/useful/closed/feature-table-tax.txt

cp $name/closed/clustered-sequences/dna-sequences.fasta $name/useful/closed/dna-sequences.fasta

cp $name/useful/closed/feature-table-tax.txt $name/useful/closed/feature-table-tax4fun.txt#

# Remove the D_0__ etc from the taxonomy string because they are a feature of QIIME and Tax4Fun does not like them 
sed -i '' 's/D_0__//;s/D_1__//;s/D_2__//;s/D_3__//;s/D_4__//;s/D_5__//;s/D_6__//' $name/useful/closed/feature-table-tax4fun.txt
