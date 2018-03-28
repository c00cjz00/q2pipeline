#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary 
#Step 1 - Splitting reads and barcodes from fastq file to make data EMP format 
#Step 1 for now must be run separetly in QIIME 1.9.1
source activate qiime1
#Check that $1 isn't empty
if [[ -z "$1" ]]; then
	echo -e "Error - you must enter a name for the analysis at the end of the command e.g.\"qiime_pipeline peter1\""
	exit
fi
#
#Make sure the folder name isn't longer than 7 characters, for some reason 
if [ "${#1}" -ge "8" ]; then
	echo -e "Error - analysis name must be no more than 7 characters\n"
	exit
fi
#
#If the fastq file in the folder isn't the same name as you tell it it is, it will tell you off 
if [ ! -f ../$1/"$1".fastq ]; then
	echo -e "FastQ file not found in ~/Desktop/qiime2/$1\n"
	exit
fi
#
echo "Okay, doing step 1. Give me 5 minutes."
extract_barcodes.py -f ../$1/$1.fastq -o ../$1/emp -l 15 -c barcode_single_end -m ../$1/"$1"map.txt
#Then to rename reads.fastq to sequences.fastq as per EMP protocol
mv ../$1/emp/reads.fastq ../$1/emp/sequences.fastq
#Then to gzip both new files as per EMP protocol
gzip ../$1/emp/sequences.fastq
gzip ../$1/emp/barcodes.fastq
#
echo "Okay, step 1 finished. Now enter the command for step 2!"
source deactivate
