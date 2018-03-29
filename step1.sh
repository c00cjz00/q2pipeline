#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary 
#Step 1 - Splitting reads and barcodes from fastq file to make data EMP format 
#Step 1 for now must be run separetly in QIIME 1.9.1
source activate qiime1
extract_barcodes.py -f $name/$name.fastq -o $name/emp -l 15 -c barcode_single_end -m $name/"$name"map.txt
#Then to rename reads.fastq to sequences.fastq as per EMP protocol
mv $name/emp/reads.fastq $name/emp/sequences.fastq
#Then to gzip both new files as per EMP protocol
gzip $name/emp/sequences.fastq
gzip $name/emp/barcodes.fastq
#
source deactivate
