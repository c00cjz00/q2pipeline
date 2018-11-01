#!/bin/bash
# Peter Leary 
# A script to pull out Illumina fastq files from subdirectories into one folder, so QIIME2 can pull them into demux.
# Requires a named folder, which contains a 'Seqs' folder, which contains all the folders containing Illumina reads 
# Example usage: ./move_fastq.sh folder –– where 'folder' is the name of your folder containing 'Seqs' and fastqs

sourcedir=$1/Seqs/                # Tells it that the fastqs are in folders in the 'Seqs' folder
destdir=$1/Seqs                   # Tells it to put the moved files just all into 'Seqs'

for f in $sourcedir/*             # Looking for files in the 'Seqs/folder' folders 
do
    mv $f/*R1*.fastq.gz $destdir  # Move forward reads into 'Seqs'
    mv $f/*R2*.fastq.gz $destdir  # More reverse reads into 'Seqs'
done                              # Done
rm -r $1/Seqs/*/                  # Delete the folders from whence the fastqs came, to be tidy 
