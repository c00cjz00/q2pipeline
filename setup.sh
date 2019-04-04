#!/bin/bash 
#
mkdir scripts
mv *sh scripts 
mv *R scripts
mv *r scripts
mv *awk scripts
mkdir classifiers 
mkdir classifiers/illumina_16S
mkdir classifiers/iontorrent_16S
mkdir classifiers/silva119
mkdir classifiers/iontorrent_ITS
mkdir classifiers/illumina_ITS
mkdir classifiers/picrust
mkdir classifiers/illumina_18S
wget http://kronos.pharmacology.dal.ca/public_files/tutorial_datasets/picrust2_tutorial_files/reference.fna.qza -O classifiers/picrust/reference.fna.qza
wget http://kronos.pharmacology.dal.ca/public_files/tutorial_datasets/picrust2_tutorial_files/reference.tre.qza -O classifiers/picrust/reference.tre.qza
wget https://data.qiime2.org/2019.1/common/silva-132-99-515-806-nb-classifier.qza -O classifiers/illumina_16S/silva-132-99-515-806-nb-classifier.qza
wget https://data.qiime2.org/2019.1/common/silva-132-99-nb-classifier.qza -O classifiers/iontorrent_16S/silva-132-99-nb-classifier.qza
echo -e "\nFinished!\n"
