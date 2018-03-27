#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary 
#This is pretty much a carbon copy of the "Moving Pictures" tutorial on the QIIME2 website, albeit in a slightly different order.
#Check that $1 isn't empty
source activate qiime2-2018.2
#
if [[ -z "$1" ]]; then
	echo -e "Error - you must enter a name for the analysis at the end of the command e.g. scripts/pipeline.sh test"
	exit
fi
#
#Make sure the folder name isn't longer than 12 characters, for some reason 
if [ "${#1}" -ge "13" ]; then
	echo -e "Error - analysis name must be no more than 12 characters\n"
	exit
fi
#
#Options bit 
echo -e "\nHiya, this is a QIIME 2 pipeline for Ion Torrent and Illumina data. Please read the following options, and type your responses in carefully.\n"
#
echo -e "\nStep 1. Firstly, please tell me whether this is Ion Torrent or Illumina data. Type which one it is below, and press return.\n"
read platform_in
#
if [[ "$platform_in" == "Ion Torrent" && ! -f ../$1/$1.fastq ]]; then
	echo -e "Please put your files in ~/Desktop/QIIME2/$1 - You might need to create the folder first\n"
	exit
fi
#
if [[ "$platform_in" == "Ion Torrent" && ! -f ../$1/emp/*gz ]]; then
	echo -e "Ah, you're running Ion Torrent data, so you need to run 'step1.sh $1' first. Sorry!\n"
	exit
fi
#
if [[ "$platform_in" == "Illumina" && ! -r ../$1/seqs/ ]]; then
	echo -e "Please put your files in ~/Desktop/QIIME2/$1/seqs - You might need to create the folder first\n"
	exit
fi
#
echo -e "\nStep 2. Please type in the name of the denoising protocol you'd like to use by typing either DADA2 or Deblur below\n"
read sv_in
#
echo -e "\nStep 5a. Now I need you to tell me how you'd like to trim reads at the 5' end. For Ion Torrent, this should be ~20 bp, so type 20. For Illumina, it should be ~13, so type 13, and hit return.\n"
read trimleft_in
#
echo -e "\nStep 5b. Thanks! Now type how you'd like sequences truncated at the 3' end. This depends on a few things, like amplicon length, quality. You should already have an idea of sequence quality from either the Ion Torrent server or from the Illumina results. You want to keep reads above an average Phred score of 25 where possible. >200bp should give you pretty good taxonomy assignment, but the longer the better (and slower). Type in a reasonable number, say 270, or 400, below. If you're analysing Northumbria Illumina data, truncate to 240 bp.\n"
read trunclen_in
echo -e "\n"
#
echo -E -e "The options you selected for this run are:\nSequencing Platform = $platform_in \nDenoising/ASV = $sv_in\nTrim sequences 5' = $trimleft_in\nTruncate sequences 3' = $trunclen_in" > ../$1/options.txt
#
mkdir ../$1/useful 
#This is where it starts playing with your data
#Ion Torrent Import
if [[ "$platform_in" == "Ion Torrent" ]]; then 
echo -e "\nImporting Ion Torrent data into QIIME2\n"
FIRST=$(name=$1 $HOME/qiime/QIIME2/import.sh)
echo $FIRST
fi
#Ion Torrent demuxing
if [[ "$platform_in" == "Ion Torrent" ]]; then 
echo -e "\nDemultiplexing samples (that means separating samples based on barcodes)\n"
SECOND=$(name=$1 $HOME/qiime/QIIME2/demux.sh)
echo $SECOND
fi
#Illumina import
if [[ "$platform_in" == "Illumina" ]]; then 
echo -e "\nImporting Illumina data and making demultiplexed files\n"
THIRD=$(name=$1 $HOME/qiime/qiime2/import_illumina.sh)
echo $THIRD
fi
#
#Dada2
if [[ "$platform_in" == "Ion Torrent" && "$sv_in" == "DADA2" ]]; then 
echo -e "\nDADA2-ing now. This takes me about 6 - 12 hours, so go do something else while I'm working!\n"
FOURTH=$(name=$1 sv=$sv_in trimleft=$trimleft_in trunclen=$trunclen_in $HOME/qiime/QIIME2/dada2.sh)
echo $FOURTH
fi
#
if [[ "$platform_in" == "Illumina" && "$sv_in" == "DADA2" ]]; then 
echo -e "\nDADA2-ing now. This takes me about 6 - 12 hours, so go do something else while I'm working!\n"
FOURTH=$(name=$1 sv=$sv_in trimleft=$trimleft_in trunclen=$trunclen_in $HOME/qiime/QIIME2/dada2_illumina.sh)
echo $FOURTH
fi
#
#Deblur
if [[ "$sv_in" == 'Deblur' ]]; then
echo -e "\nDebluring now. This takes about 30-60 minutes?\n"
FOURTH=$(name=$1 sv=$sv_in trimleft=$trimleft_in trunclen=$trunclen_in $HOME/qiime/QIIME2/deblur.sh)
echo $FOURTH
fi
#
#Closed-reference OTU picking via vsearch, for use with Tax4Fun 
echo -e "\nClosed-reference OTU picking via vsearch - for use with Tax4Fun\n"
FIFTH=$(name=$1 sv=$sv_in $HOME/qiime/qiime2/closed.sh)
echo $FIFTH 
#
#Align
echo -e "\nAligning\n"
SIXTH=$(name=$1 sv=$sv_in $HOME/qiime/QIIME2/align.sh)
echo $SIXTH
#
#Assign taxonomy Ion Torrent 
if [[ "$platform_in" == "Ion Torrent" ]]; then
echo -e "\nAssigning taxonomy - 99%\n"
EIGTH=$(name=$1 sv=$sv_in $HOME/qiime/QIIME2/assign.sh)
echo $EIGTH
fi
#
#Assign taxonomy Illumina
if [[ "$platform_in" == "Illumina" ]]; then
echo -e "\nAssigning taxonomy - 99%\n"
EIGTH=$(name=$1 sv=$sv_in $HOME/qiime/QIIME2/assign_illumina.sh)
echo $EIGTH
fi
#
#Make phylogenetic tree
echo -e "\nMaking phylogenetic tree\n"
NINTH=$(name=$1 sv=$sv_in $HOME/qiime/QIIME2/tree.sh)
echo $NINTH
#
echo -e "\nOkay now it's your turn. Go into the output ~/Desktop/QIIME2/$1/useful/table/index.html and select the second tab. Find the bottom sample with the fewest reads, and enter the number below for sampling depth.\n"
read samdep_in
echo -e "\nDoing alpha diversity\n"
TENTH=$(name=$1 sv=$sv_in sam=$samdep_in sam_max=$sammax_in $HOME/qiime/QIIME2/alpha.sh)
echo $TENTH 
#
echo -e "\nNow doing some beta diversity\n"
ELEVNTH=$(name=$1 sv=$sv_in $HOME/qiime/QIIME2/beta.sh)
echo $ELEVNTH
#
echo -e "\nTidying up and making a folder of useful stuff\n"
TWELFTH=$(name=$1 sv=$sv_in $HOME/qiime/QIIME2/final.sh)
echo $TWELFTH
#
echo -e "\nFinished!\n"
#
