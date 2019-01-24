#!/bin/bash
# QIIME2 Pipeline by Peter Leary 

mkdir $name/picrust

qiime fragment-insertion sepp --i-representative-sequences $name/dada2/table.qza \
                              --p-threads 1 --i-reference-alignment classifiers/picrust/reference.fna.qza \
                              --i-reference-phylogeny classifiers/picrust/reference.tre.qza \
                              --output-dir $name/picrust/placed_out
                              
qiime picrust2 custom-tree-pipeline --i-table $name/dada2/table.qza \
                                    --i-tree $name/picrust/placed_out/tree.qza \
                                    --output-dir $name/picrust/q2-picrust2_output \
                                    --p-threads $threads \
                                    --p-hsp-method pic \
                                    --p-max-nsti 2

qiime tools export --input-path $name/picrust/q2-picrust2_output/ko_metagenome.qza --output-path $name/picrust/q2-picrust_output/
biom convert -i $name/picrust/q2-picrust_output/ko_metagenome/feature-table.biom -o $name/picrust/q2-picrust_output/ko_metagenome/picrust_kegg.txt --to-tsv 

mkdir $name/useful/picrust

tail -n +2 $name/picrust/q2-picrust_output/ko_metagenome/picrust_kegg.txt > $name/useful/picrust/picrust_ko.txt 

awk -f scripts/picrust_transform.awk $name/useful/picrust/picrust_ko.txt > $name/useful/picrust_ko_normalised.txt 
# Awk script is from here: https://unix.stackexchange.com/questions/175265/how-to-calculate-percent-of-every-column 