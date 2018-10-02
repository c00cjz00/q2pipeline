#!/bin/bash
# QIIME 2 Ion Torrent Pipeline by Peter Leary 
# This is pretty much a carbon copy of the "Moving Pictures" tutorial on the QIIME2 website, albeit in a slightly different order.
# Check that $1 isn't empty
#
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PUR='\033[0;35m'

if [[ -z "$1" ]]; then
	echo -e "${RED}\nError - you must enter a name for the analysis at the end of the command e.g. scripts/pipeline.sh test${NC}"
	exit
fi
#
# Make sure the folder name isn't longer than 12 characters, to keep things neat. No special characters. 
if [ "${#1}" -ge "13" ]; then
	echo -e "${RED}\nError - analysis name must be no more than 12 characters\n${NC}"
	exit
fi
#
# Options bit 
# Enter which sequencing platform was used 
echo -e "\n${PUR}QIIME2 Pipeline by Peter Leary. Last updated 24/08/2018.\n"
#
# Enter a number where the pipeline should start from
echo -e "\nOkay listen up, here you can select which step of the pipeline you'd like to run from. Obviously, if you are running this on new data, you need to run the entire pipeline. If you choose to run from another step, you must have the files from the previous steps in the right place, as the pipeline will look for them as it would look for them if it had made them itself. This is more for people who wish to re-run certain bits of their analysis with different options. Pick a part of the pipeline and enter the number below.\n\n1. From the beginning, so importing and demultiplexing.\n2. DADA2 onwards.\n3. Closed OTU picking onwards.\n4. Assign Taxonomy.\n5. Align.\n6. Construct phylogenetic tree.\n7. Alpha diversity and beta diversity.\n8. Tax4Fun only.\n9. Gneiss Differential Abundance.\n${NC}"
read step_in
echo -e "\n${GREEN}You chose step $step_in\n${NC}"
#
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 5 ]]; then
echo -e "\n${PUR}Firstly, please tell me whether this is Ion Torrent or Illumina data. Type which one it is below, and press return.\n${NC}"
read platform_in
echo -e "\n${GREEN}You chose $platform_in\n${NC}"
if [[ "$platform_in" != "Illumina" ]] && [[ "$platform_in" != "Ion Torrent" ]]; then
echo -e "\n${RED}You didn't type in your option properly. I am very fussy, and demand that you type in your option better. I am case sensitive, so if I say type Illumina, I mean Illumina, not illumina or loomina! If I say Ion Torrent, I mean that, not ion torrent or i0n 70RR3n7\n${NC}"
exit
fi
# Checking the required files from Ion Torrent or Illumina are present and accounted for
if [[ "$step_in" == 1 ]]; then
if [[ "$platform_in" == "Ion Torrent" && ! -f $1/$1.fastq ]]; then
	echo -e "\n${RED}Please put your files in $1 - You might need to create the folder first.\n${NC}"
	exit
fi
#
if [[ "$platform_in" == "Illumina" && ! $1/seqs/*fastq.gz ]]; then
	echo -e "\n${RED}Please put your files in $1/seqs - You might need to create the folder first.\n${NC}"
	exit
fi
fi
fi
#
# Enter which marker gene was sequenced: 16S or ITS 
if [[ "$step_in" == 1 ]] || [[ "$step_in" == 2 ]] || [[ "$step_in" == 4 ]] || [[ "$step_in" == 4 ]] || [[ "$step_in" == 7 ]]; then 
echo -e "\n${PUR}Please tell me what marker gene was sequenced by typing either 16S or ITS below.\n${NC}"
read gene_in
echo -e "\n${GREEN}You chose $gene_in\n${NC}"
fi
# Enter the denoising/ASV protocol to use, either DADA2 or Deblur in QIIME2 
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 8 ]] || [[ "$step_in" == 9 ]]; then
echo -e "\n${PUR}Please type in the name of the denoising protocol you'd like to use (or used) by typing either DADA2 or Deblur below.\n${NC}"
read sv_in
echo -e "\n${GREEN}You chose $sv_in\n${NC}"
#
if [[ "$sv_in" != "DADA2" ]] && [[ "$sv_in" != "Deblur" ]]; then
echo -e "\n${RED}You didn't type in your option properly. I am very fussy, and demand that you type in your option better. I am case sensitive, so if I say type DADA2, I mean DADA2, not dada2 or Dada2!\n${NC}"
exit
fi
#
# Enter the value to trim all reads from the 5' end. This is essential for Ion Torrent
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 3 ]]; then
echo -e "\n${PUR}Now I need you to tell me how you'd like to trim reads at the 5' end. For Ion Torrent, this should be ~20 bp, so type 20. For Illumina, it should be ~13, so type 13, and hit return.\n${NC}"
read trimleft_in
echo -e "\n${GREEN}You chose $trimleft_in\n${NC}"
#
# Enter the value to truncate all reads at the 3' end. This is based on quality
if [[ "$gene_in" == "16S" ]]; then
echo -e "\n${PUR}Thanks! Now type how you'd like sequences truncated at the 3' end. For Illumina, ~240 bp is sensible. For Ion Torrent, I personally recommend truncating to around 250-300, and the more conservative the better. Type in a sensible number and hit return.\n${NC}"
read trunclen_in
echo -e "\n${GREEN}You chose $trunclen_in\n${NC}"
#
# Enter the value to truncate all reverse reads from Illumina 
if [[ "$platform_in" == "Illumina" ]]; then
	echo -e "\n${PUR}3c. Illumina-option Special! Please tell me how you'd like to truncate your reverse reads at the 3' end. 180 is a very sensible number I feel.\n${NC}"
	read trunclen_rev_in
    echo -e "\n${GREEN}You chose $trunclen_rev_in\n${NC}"
fi
fi
fi
fi
#
# Tell me which metadata column to use for Gneiss 
if [[ "$step_in" == 1 ]] || [[ "$step_in" == 9 ]]; then 
echo -e "\n${PUR}Please tell me what column from your sample metadata/map file to use for Gneiss. Enter the name of the column exactly as it is in your map.\n${NC}"
read column_in
echo -e "\n${GREEN}You chose $column_in\n${NC}"
fi
#
# Enter the number of threads I can use
echo -e "\n${PUR}Great, now please tell me how many processors/threads your computer has. If you just want to use everything, type 0. For 2 cores, type 2, for 4 cores, type 4 etc. If you have a quad core i7 with hyperthreading (like the iMac), the max is 8, so enter up to 8. So, enter a number between 0 - 8.\n${NC}" 
read threads_in
echo -e "\n${GREEN}You chose $threads_in\n${NC}"
# Prints out a .txt file of all the inputs the user entered
if [ ! -e $1/options.txt ]; then
echo -E -e "$(date)\nQIIME2 Pipeline by Peter Leary\nThe options you selected for this run are:\nSequencing Platform = $platform_in\nMarker gene = $gene_in\nDenoising/ASV = $sv_in\nTrim sequences 5' = $trimleft_in\nTruncate sequences 3' = $trunclen_in $trunclen_rev_in\nThreads = $threads_in\nFrom step $step_in" > $1/options.txt
elif [ -e $1/options.txt ]; then 
echo -E -e "\n$(date)\nQIIME2 Pipeline by Peter Leary\nThe options you selected for this run are:\nSequencing Platform = $platform_in\nMarker gene = $gene_in\nDenoising/ASV = $sv_in\nTrim sequences 5' = $trimleft_in\nTruncate sequences 3' = $trunclen_in $trunclen_rev_in\nThreads = $threads_in\nFrom step $step_in" >> $1/options.txt
fi
#
echo -e "\n${PUR}Okay, let's get QIIMEing!\n${NC}"
#
# Print a log.txt file as it goes along 
if [ ! -e $1/log.txt ]; then
echo -E -e "QIIME2 Pipeline by Peter Leary\nPipeline Log\n$(date)\n" > $1/log.txt
elif [ -e $1/log.txt ]; then
echo -E -e "\nQIIME2 Pipeline by Peter Leary\nPipeline Log\n$(date)\n" >> $1/log.txt
fi
#
# Splits Ion Torrent fastq into reads.fastq and barcodes.fastq, and gzips them. This is so they can be imported via the EMP protocol.
if [[ "$step_in" == 1 ]]; then
if [[ "$platform_in" == "Ion Torrent" ]]; then 
    echo -e "$(date)${GREEN}\nPrepping Ion Torrent data for import\n${NC}"
	FIRST=$(name=$1 scripts/step1.sh)
	echo $FIRST
fi
#
source activate qiime2-2018.8
#
mkdir $1/useful 
# This is where it starts playing with your data
# Ion Torrent Import
if [[ "$platform_in" == "Ion Torrent" ]]; then  
echo -E -e "$(date)\nPrep Ion Torrent data for import – step1.sh\n" >> $1/log.txt
echo -e "\n$(date)${GREEN}\nImporting Ion Torrent data into QIIME2\n${NC}"
FIRST=$(name=$1 scripts/import.sh)
echo $FIRST
fi
# Ion Torrent demuxing
if [[ "$platform_in" == "Ion Torrent" ]]; then 
echo -E -e "\n$(date)\nDemultiplexing samples – demux.sh\n" >> $1/log.txt
echo -e "\n$(date)${GREEN}\nDemultiplexing samples (that means separating samples based on barcodes)\n${NC}"
SECOND=$(name=$1 scripts/demux.sh)
echo $SECOND
fi
# Illumina import
if [[ "$platform_in" == "Illumina" ]]; then 
echo -E -e "\n$(date)\nImporting Illumina data - import_illumina.sh\n" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nImporting Illumina data and making demultiplexed files\n${NC}"
THIRD=$(name=$1 scripts/import_illumina.sh)
echo $THIRD
fi
fi
#
# Dada2
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 3 ]]; then
source activate qiime2-2018.8
if [[ "$platform_in" == "Ion Torrent" && "$sv_in" == "DADA2" ]]; then 
echo -E -e "\n$(date)\nDoing DADA2 - dada2.sh\n" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nDADA2-ing now. This can take upto a few hours, so go do something else!\n${NC}"
FOURTH=$(name=$1 sv=$sv_in trimleft=$trimleft_in trunclen=$trunclen_in threads=$threads_in gene=$gene_in scripts/dada2.sh)
echo $FOURTH
fi
#
if [[ "$platform_in" == "Illumina" && "$sv_in" == "DADA2" ]]; then 
echo -E -e "\n$(date)\nDoing DADA2 - dada2_illumina.sh\n" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nDADA2-ing now. This can take upto a few hours, so go do something else!\n${NC}"
FOURTH=$(name=$1 sv=$sv_in trimleft=$trimleft_in trunclen=$trunclen_in truncrev=$trunclen_rev_in gene=$gene_in threads=$threads_in scripts/dada2_illumina.sh)
echo $FOURTH
fi
#
# Deblur
if [[ "$platform_in" == "Illumina" && "$sv_in" == 'Deblur' ]]; then
echo -E -e "\n$(date)\nDoing Deblur - deblur.sh\n" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nDebluring now. This takes about 30-60 minutes?\n${NC}"
FOURTH=$(name=$1 sv=$sv_in trimleft=$trimleft_in trunclen=$trunclen_in threads=$threads_in scripts/deblur.sh)
echo $FOURTH
fi
fi
#
# Closed-reference OTU picking via vsearch, for use with Tax4Fun 
if [[ "$gene_in" == "16S" && "$step_in" == 1 ]] || [[ "$gene_in" == "16S" && "$step_in" < 4 ]]; then
source activate qiime2-2018.8
echo -E -e "\n$(date)\nPicking closed ref OTUs - closed.sh\n" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nClosed-reference OTU picking via vsearch - for use with Tax4Fun\n${NC}"
FIFTH=$(name=$1 sv=$sv_in threads=$threads_in scripts/closed.sh)
echo $FIFTH 
fi
#
# Identify how many cores were selected from the available to determine the --p-n-jobs number of taxonomy classification up to a maximum of 8. 
if [[ "$(expr substr $(uname -s) 1 5 )" == " Linux" ]]; then
cores=$(nproc --all)
else
cores=$(sysctl -n hw.ncpu)
fi
if [[ "$threads_in" == 1 ]]; then 
athreads="1"
elif [[ "$threads_in" == 0 ]]; then 
athreads="-1" 
elif [[ $(($cores-$threads_in)) == 1 ]]; then
athreads="-2" 
elif [[ $(($cores-$threads_in)) == 2 ]]; then
athreads="-3"
elif [[ $(($cores-$threads_in)) == 3 ]]; then
athreads="-4"
elif [[ $(($cores-$threads_in)) == 4 ]]; then
athreads="-5"
elif [[ $(($cores-$threads_in)) == 5 ]]; then
athreads="-6"
elif [[ $(($cores-$threads_in)) == 6 ]]; then
athreads="-7"
elif [[ $(($cores-$threads_in)) == 7 ]]; then
athreads="-8"
elif [[ $(($cores-$threads_in)) == 0 ]]; then
athreads="-1"
fi
# Classify taxonomy - Ion Torrent 
echo -E -e "\n$(date)\nClassifying taxonomy at 99% with $athreads jobs (that's $threads_in threads) - assign.sh\n" >> $1/log.txt 
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 5 ]]; then
source activate qiime2-2018.8
if [[ "$platform_in" == "Ion Torrent" ]]; then
echo -e "\n$(date)${GREEN}\nClassifying taxonomy - 99%\n${NC}"
SIXTH=$(name=$1 sv=$sv_in athreads=$athreads gene=$gene_in scripts/assign.sh)
echo $SIXTH
fi
#
# Classify taxonomy - Illumina
if [[ "$platform_in" == "Illumina" ]]; then
echo -E -e "\n$(date)\nClassifying taxonomy at 99% with $athreads jobs (that's $threads_in threads) - assign.sh\n" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nClassifying taxonomy - 99%\n${NC}"
SIXTH=$(name=$1 sv=$sv_in athreads=$athreads gene=$gene_in scripts/assign_illumina.sh)
echo $SIXTH
fi
fi
#
# Align
if [[ "$gene_in" == "16S" && "$step_in" == 1 ]] || [[ "$gene_in" == "16S" && "$step_in" < 6 ]]; then
source activate qiime2-2018.8
echo -E -e "\n$(date)\nAligning - align.sh\n" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nAligning\n${NC}"
SEVENTH=$(name=$1 sv=$sv_in threads=$threads_in scripts/align.sh)
echo $SEVENTH
fi
#
# Make phylogenetic tree
if [[ "$gene_in" == "16S" && "$step_in" == 1 ]] || [[ "$gene_in" == "16S" && "$step_in" < 7 ]]; then
source activate qiime2-2018.8
echo -E -e "\n$(date)\nBuilding phylogenetic tree - tree.sh\n" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nMaking phylogenetic tree\n${NC}"
EIGTH=$(name=$1 sv=$sv_in threads=$threads_in scripts/tree.sh)
echo $EIGTH
fi
#
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 8 ]]; then
source activate qiime2-2018.8
# Enter a number to be used as sampling depth for rarefaction
echo -e "\n${PUR}Okay now it's your turn. Go into the output /$1/useful/table/index.html and select the second tab. Find the bottom sample with the fewest reads, and enter the number below for sampling depth.\n${NC}"
read samdep_in
echo -e "\n${GREEN}You chose $samdep_in\n"
echo -E -e "Sampling depth = $samdep_in\n" >> $1/options.txt 
if [[ "$gene_in" == 16S ]]; then
echo -E -e "\n$(date)\nCore metrics and alpha diversity with a sampling depth of $samdep_in\n - alpha.sh" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nDoing alpha diversity\n${NC}"
NINTH=$(name=$1 sv=$sv_in sam=$samdep_in sam_max=$sammax_in scripts/alpha.sh)
echo $NINTH 
#
echo -E -e "\n$(date)\nBeta diversity - beta.sh\n" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nNow doing some beta diversity\n${NC}"
TENTH=$(name=$1 sv=$sv_in scripts/beta.sh)
echo $TENTH
fi
if [[ "$gene_in" == "ITS" ]]; then 
echo -E -e "\n$(date)\nCore metrics and alpha diversity with a sampling depth of $samdep_in\n - alpha.sh" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nDoing alpha diversity\n${NC}"
NINTH=$(name=$1 sv=$sv_in athreads=$athreads sam=$samdep_in sam_max=$sammax_in scripts/alpha_its.sh)
echo $NINTH 
#
echo -E -e "\n$(date)\nBeta diversity - beta.sh\n" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nNow doing some beta diversity\n${NC}"
TENTH=$(name=$1 athreads=$athreads sv=$sv_in scripts/beta_its.sh)
echo $TENTH
fi
fi
#
# Tax4Fun time... 
if [[ "$gene_in" == "16S" && "$step_in" == 1 ]] || [[ "$gene_in" == "16S" && "$step_in" < 9 ]]; then
echo -E -e "\n$(date)\nTax4Fun and pulling out some pathways - tax4fun.R and key_kos.sh\n" >> $1/log.txt 
echo -e "\n$(date)${GREEN}\nDoing Tax4Fun for you!\n${NC}"
mkdir $1/useful/tax4fun
./scripts/install_tax4fun.R 
cd $1 
ELEVENTH=$(name=$1 ../scripts/tax4fun.R)
echo $ELEVENTH
cd ../
#
TWELFTH=$(name=$1 scripts/key_kos.sh)
echo $TWELFTH
fi
#
if [[ "$step_in" == 1 ]] || [[ "$step_in" == 9 ]]; then 
source activate qiime2-2018.8
echo -E -e "\n$(date)\nGneiss differential abundance - gneiss.sh" >> $1/log.txt
echo -e "\n$(date)${GREEN}\nCalculating differential abundances via Gneiss\n${NC}"
THIRTEENTH=$(name=$1 sv=$sv_in column=$column_in scripts/gneiss.sh)
echo $THIRTEENTH
fi
#echo -E -e "OK" >> $1/log.txt
#
echo -e "\nFinished!\n${NC}"
# End.
