#!/bin/bash
# QIIME 2 Pipeline by Peter Leary

mkdir $name/aligned
qiime alignment mafft \
  --i-sequences $name/$sv/rep-seqs.qza \
  --o-alignment $name/aligned/aligned-rep-seqs.qza \
  --p-n-threads $threads \
  --quiet
#
qiime alignment mask \
  --i-alignment $name/aligned/aligned-rep-seqs.qza \
  --o-masked-alignment $name/aligned/masked-aligned-rep-seqs.qza \
  --quiet

mkdir $name/useful/rep-seqs-aligned

qiime tools export --input-path $name/aligned/aligned-rep-seqs.qza --output-path $name/aligned/aligned-rep-seqs
qiime tools export --input-path $name/aligned/masked-aligned-rep-seqs.qza --output-path $name/aligned/masked-aligned-rep-seqs

cp $name/aligned/aligned-rep-seqs/aligned-dna-sequences.fasta $name/useful/rep-seqs-aligned
cp $name/aligned/masked-aligned-rep-seqs/aligned-dna-sequences.fasta $name/useful/rep-seqs-aligned/masked-aligned-dna-sequences.fasta
cp $name/useful/rep-seqs-aligned/aligned-dna-sequences.fasta $name/useful/rep-seqs-aligned/aligned-dna-sequences.txt
cp $name/useful/rep-seqs-aligned/masked-aligned-dna-sequences.fasta $name/useful/rep-seqs-aligned/masked-aligned-dna-sequences.txt