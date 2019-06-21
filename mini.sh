#!/bin/bash
# Where $2 = name of project / $2 = number to filter to 

source activate qiime2-2019.4

qiime feature-table filter-features --i-table $1/DADA2/table.qza --p-min-frequency $2 --o-filtered-table $1/DADA2/table-"$2".qza 

qiime feature-table filter-seqs --i-table $1/DADA2/table-"$2".qza --i-data $1/DADA2/rep-seqs.qza --o-filtered-data $1/DADA2/rep-seqs-"$2".qza

qiime alignment mafft --i-sequences $1/DADA2/rep-seqs-"$2".qza --o-alignment $1/aligned/aligned-rep-seqs-"$2".qza --p-n-threads 12

qiime alignment mask --i-alignment $1/aligned/aligned-rep-seqs-"$2".qza --o-masked-alignment $1/aligned/masked-aligned-rep-seqs-"$2".qza

qiime phylogeny fasttree --i-alignment $1/aligned/masked-aligned-rep-seqs-"$2".qza --o-tree $1/aligned/unrooted-tree-"$2".qza --p-n-threads 12

qiime phylogeny midpoint-root --i-tree $1/aligned/unrooted-tree-"$2".qza --o-rooted-tree $1/aligned/rooted-tree-"$2".qza

qiime feature-classifier classify-sklearn --i-classifier classifiers/illumina_16S/*.qza --i-reads $1/DADA2/rep-seqs-"$2".qza --o-classification $1/taxonomy/taxonomy-"$2".qza --p-n-jobs -8
