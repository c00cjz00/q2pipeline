#!/bin/bash 
#
mkdir scripts
mv *sh scripts 
mv *R scripts
mkdir classifiers 
mkdir classifiers/illumina_16S
mkdir classifiers/iontorrent_16S
mkdir classifiers/silva119
mkdir classifiers/iontorrent_ITS
mkdir classifiers/illumina_ITS
mkdir classifiers/picrust
wget http://kronos.pharmacology.dal.ca/public_files/tutorial_datasets/picrust2_tutorial_files/reference.fna.qza -O classifiers/picrust/reference.fna.qza
wget http://kronos.pharmacology.dal.ca/public_files/tutorial_datasets/picrust2_tutorial_files/reference.tre.qza -O classifiers/picrust/reference.tre.qza
wget https://www.dropbox.com/s/sjvxpat5zcvn6j9/silva-132-99-515-806-nb-classifier.qza?dl=1 -O classifiers/illumina_16S/silva-132-99-515-806-nb-classifier.qza
wget https://www.dropbox.com/s/5tckx2vhrmf3flp/silva-132-99-nb-classifier.qza?dl=1 -O classifiers/iontorrent_16S/silva-132-99-nb-classifier.qza
echo -e "\nFinished!\n"
