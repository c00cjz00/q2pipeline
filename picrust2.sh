#!/bin/bash
# QIIME2 Pipeline by Peter Leary 

# Picrust2 doesn't like a zero core count, so if the user input 0, change to the maximum number of cores 
if [[ $threads = 0 ]]; then
    if [[ "$(expr substr $(uname -s) 1 5 )" == "Linux" ]]; then
    threads=$(nproc --all)
    else
    threads=$(sysctl -n hw.ncpu)
    fi
fi

mkdir $name/picrust

qiime fragment-insertion sepp --i-representative-sequences $name/$sv/rep-seqs.qza \
                              --p-threads $threads --i-reference-alignment classifiers/picrust/reference.fna.qza \
                              --i-reference-phylogeny classifiers/picrust/reference.tre.qza \
                              --output-dir $name/picrust/placed_out
                              
qiime picrust2 custom-tree-pipeline --i-table $name/$sv/table.qza \
                                    --i-tree $name/picrust/placed_out/tree.qza \
                                    --output-dir $name/picrust/q2-picrust2_output \
                                    --p-threads $threads \
                                    --p-hsp-method pic \
                                    --p-max-nsti 2

# Extract all the output files
qiime tools export --input-path $name/picrust/q2-picrust2_output/ko_metagenome.qza --output-path $name/picrust/q2-picrust2_output/ko_metagenome
qiime tools export --input-path $name/picrust/q2-picrust2_output/ec_metagenome.qza --output-path $name/picrust/q2-picrust2_output/ec_metagenome
qiime tools export --input-path $name/picrust/q2-picrust2_output/pathway_abundance.qza --output-path $name/picrust/q2-picrust2_output/pathway_abundance
qiime tools export --input-path $name/picrust/q2-picrust2_output/pathway_coverage.qza --output-path $name/picrust/q2-picrust2_output/pathway_coverage

# Convert all the extracted output files from biom to txt 
biom convert -i $name/picrust/q2-picrust2_output/ko_metagenome/feature-table.biom -o $name/picrust/q2-picrust2_output/ko_metagenome/ko_metagenome.txt --to-tsv
biom convert -i $name/picrust/q2-picrust2_output/ec_metagenome/feature-table.biom -o $name/picrust/q2-picrust2_output/ec_metagenome/ec_metagenome.txt --to-tsv
biom convert -i $name/picrust/q2-picrust2_output/pathway_abundance/feature-table.biom -o $name/picrust/q2-picrust2_output/pathway_abundance/pathway_abundance.txt --to-tsv
biom convert -i $name/picrust/q2-picrust2_output/pathway_coverage/feature-table.biom -o $name/picrust/q2-picrust2_output/pathway_coverage/pathway_coverage.txt --to-tsv

# Remove the first line from each table 
tail -n +2 $name/picrust/q2-picrust2_output/ko_metagenome/ko_metagenome.txt > $name/picrust/q2-picrust2_output/ko_metagenome/ko_metagenome-tail.txt
tail -n +2 $name/picrust/q2-picrust2_output/ec_metagenome/ec_metagenome.txt > $name/picrust/q2-picrust2_output/ec_metagenome/ec_metagenome-tail.txt
tail -n +2 $name/picrust/q2-picrust2_output/pathway_abundance/pathway_abundance.txt > $name/picrust/q2-picrust2_output/pathway_abundance/pathway_abundance-tail.txt
tail -n +2 $name/picrust/q2-picrust2_output/pathway_coverage/pathway_coverage.txt > $name/picrust/q2-picrust2_output/pathway_coverage/pathway_coverage-tail.txt

# Change the `#OTU ID` to something else because the space seems to be interpreted as a tab in R and messes up the column headers 
sed -i '' 's|#OTU ID|OTU_ID|' $name/picrust/q2-picrust2_output/ko_metagenome/ko_metagenome-tail.txt
sed -i '' 's|#OTU ID|OTU_ID|' $name/picrust/q2-picrust2_output/ec_metagenome/ec_metagenome-tail.txt
sed -i '' 's|#OTU ID|OTU_ID|' $name/picrust/q2-picrust2_output/pathway_abundance/pathway_abundance-tail.txt
sed -i '' 's|#OTU ID|OTU_ID|' $name/picrust/q2-picrust2_output/pathway_coverage/pathway_coverage-tail.txt

mkdir $name/useful/picrust

cp $name/picrust/q2-picrust2_output/ko_metagenome/ko_metagenome-tail.txt $name/useful/picrust/ko_non-normalised.txt
cp $name/picrust/q2-picrust2_output/ec_metagenome/ec_metagenome-tail.txt $name/useful/picrust/ec_non-normalised.txt
cp $name/picrust/q2-picrust2_output/pathway_abundance/pathway_abundance-tail.txt $name/useful/picrust/pathway_abundance_non-normalised.txt
cp $name/picrust/q2-picrust2_output/pathway_coverage/pathway_coverage-tail.txt $name/useful/picrust/pathway_coverage_non-normalised.txt

# Percentage normalise each number by column (sample) total 
awk -f scripts/picrust_transform.awk $name/picrust/q2-picrust2_output/ko_metagenome/ko_metagenome-tail.txt > $name/useful/picrust/ko_normalised.txt
awk -f scripts/picrust_transform.awk $name/picrust/q2-picrust2_output/ec_metagenome/ec_metagenome-tail.txt > $name/useful/picrust/ec_normalised.txt
awk -f scripts/picrust_transform.awk $name/picrust/q2-picrust2_output/pathway_abundance/pathway_abundance-tail.txt > $name/useful/picrust/pathway_abundance_normalised.txt
awk -f scripts/picrust_transform.awk $name/picrust/q2-picrust2_output/pathway_coverage/pathway_coverage-tail.txt > $name/useful/picrust/pathway_coverage_normalised.txt

# Awk script is from here: https://unix.stackexchange.com/questions/175265/how-to-calculate-percent-of-every-column 