#!/bin/bash
# QIIME 2 Ion Torrent Pipeline by Peter Leary 
# This is pretty much a carbon copy of the "Moving Pictures" tutorial on the QIIME2 website, albeit in a slightly different order.
# Check that $1 isn't empty
#
if [[ -z "$1" ]]; then
	echo -e "Error - you must enter a name for the analysis at the end of the command e.g. scripts/pipeline.sh test"
	exit
fi
#
# Make sure the folder name isn't longer than 12 characters, to keep things neat. No special characters. 
if [ "${#1}" -ge "13" ]; then
	echo -e "Error - analysis name must be no more than 12 characters\n"
	exit
fi
#
# Options bit 
# Enter which sequencing platform was used 
echo -e "\nHiya, this is a QIIME 2 pipeline for Ion Torrent and Illumina data. Please read the following options, and type your responses in carefully.\n"
#
# Enter a number where the pipeline should start from
echo -e "\nOkay listen up, here you can select which step of the pipeline you'd like to run from. Obviously, if you are running this on new data, you need to run the entire pipeline. If you choose to run from another step, you must have the files from the previous steps in the right place, as the pipeline will look for them as it would look for them if it had made them itself. This is more for people who wish to re-run certain bits of their analysis with different options. Pick a part of the pipeline and enter the number below.\n\n1. From the beginning, so importing and demultiplexing.\n2. DADA2 onwards.\n3. Closed OTU picking onwards.\n4. Assign Taxonomy.\n5. Align.\n6. Construct phylogenetic tree.\n7. Alpha diversity and beta diversity.\n8. Tax4Fun only.\n"
read step_in
#
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 3 ]] || [[ "$step_in" == 4 ]]; then
echo -e "\nStep 1. Firstly, please tell me whether this is Ion Torrent or Illumina data. Type which one it is below, and press return.\n"
read platform_in
if [[ "$platform_in" != "Illumina" ]] && [[ "$platform_in" != "Ion Torrent" ]]; then
echo -e "\nYou didn't type in your option properly. I am very fussy, and demand that you type in your option better. I am case sensitive, so if I say type Illumina, I mean Illumina, not illumina or loomina! If I say Ion Torrent, I mean that, not ion torrent or i0n 70RR3n7\n"
exit
fi
# Checking the required files from Ion Torrent or Illumina are present and accounted for
if [[ "$step_in" == 1 ]]; then
if [[ "$platform_in" == "Ion Torrent" && ! -f $1/$1.fastq ]]; then
	echo -e "Please put your files in $1 - You might need to create the folder first.\n"
	exit
fi
#
if [[ "$platform_in" == "Illumina" && ! $1/seqs/*fastq.gz ]]; then
	echo -e "Please put your files in $1/seqs - You might need to create the folder first.\n"
	exit
fi
fi
fi
#
# Enter the denoising/ASV protocol to use, either DADA2 or Deblur in QIIME2 
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 6 ]] || [[ "$step_in" == 7 ]]; then
echo -e "\nStep 2. Please type in the name of the denoising protocol you'd like to use by typing either DADA2 or Deblur below.\n"
read sv_in
#
if [[ "$sv_in" != "DADA2" ]] && [[ "$sv_in" != "Deblur" ]]; then
echo -e "\nYou didn't type in your option properly. I am very fussy, and demand that you type in your option better. I am case sensitive, so if I say type DADA2, I mean DADA2, not dada2 or Dada2!\n"
exit
fi
#
# Enter the value to trim all reads from the 5' end. This is essential for Ion Torrent
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 3 ]]; then
echo -e "\nStep 3a. Now I need you to tell me how you'd like to trim reads at the 5' end. For Ion Torrent, this should be ~20 bp, so type 20. For Illumina, it should be ~13, so type 13, and hit return.\n"
read trimleft_in
#
# Enter the value to truncate all reads at the 3' end. This is based on quality
echo -e "\nStep 3b. Thanks! Now type how you'd like sequences truncated at the 3' end. For Illumina, ~240 bp is sensible. For Ion Torrent, I personally recommend truncating to around 250-300, and the more conservative the better. Type in a sensible number and hit return.\n"
read trunclen_in
#
# Enter the value to truncate all reverse reads from Illumina 
if [[ "$platform_in" == "Illumina" ]]; then
	echo -e "\n3c. Illumina-option Special! Please tell me how you'd like to truncate your reverse reads at the 3' end. 180 is a very sensible number I feel.\n"
	read trunclen_rev_in
fi
fi
fi
#
# Enter the number of threads I can use
if [[ "$step_in" < 8 ]]; then
echo -e "\nStep 4. Great, now please tell me how many processors/threads your computer has. If in doubt and wish to use everything, type 0. If you have a dual core processor, the answer is 2, so type 2. If you have a quad core, it's 4. If you have a quad core i7 with hyperthreading (like the iMac), it's 8, so enter 8.\n" 
read threads_in
fi
#
# Prints out a .txt file of all the inputs the user entered
if [ ! -e $1/options.txt ]; then
echo -E -e "The options you selected for this run are:\nSequencing Platform = $platform_in \nDenoising/ASV = $sv_in\nTrim sequences 5' = $trimleft_in\nTruncate sequences 3' = $trunclen_in $trunclen_rev_in\nThreads = $threads_in\nFrom step $step_in\nHave a nice day!" > $1/options.txt
elif [ -e $1/options.txt ]; then 
echo -E -e "The options you selected for this run are:\nSequencing Platform = $platform_in \nDenoising/ASV = $sv_in\nTrim sequences 5' = $trimleft_in\nTruncate sequences 3' = $trunclen_in $trunclen_rev_in\nThreads = $threads_in\nFrom step $step_in\nHave a nice day!" > $1/options2.txt
fi
#
echo -e "\n"
#
# Splits Ion Torrent fastq into reads.fastq and barcodes.fastq, and gzips them. This is so they can be imported via the EMP protocol.
if [[ "$step_in" == 1 ]]; then
if [[ "$platform_in" == "Ion Torrent" ]]; then 
	echo -e "Prepping Ion Torrent data for import\n"
	FIRST=$(name=$1 scripts/step1.sh)
	echo $FIRST
fi
#
source activate qiime2-2018.4
#
mkdir $1/useful 
# This is where it starts playing with your data
# Ion Torrent Import
if [[ "$platform_in" == "Ion Torrent" ]]; then 
echo -e "\nImporting Ion Torrent data into QIIME2\n"
FIRST=$(name=$1 scripts/import.sh)
echo $FIRST
fi
# Ion Torrent demuxing
if [[ "$platform_in" == "Ion Torrent" ]]; then 
echo -e "\nDemultiplexing samples (that means separating samples based on barcodes)\n"
SECOND=$(name=$1 scripts/demux.sh)
echo $SECOND
fi
# Illumina import
if [[ "$platform_in" == "Illumina" ]]; then 
echo -e "\nImporting Illumina data and making demultiplexed files\n"
THIRD=$(name=$1 scripts/import_illumina.sh)
echo $THIRD
fi
fi
#
# Dada2
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 3 ]]; then
source activate qiime2-2018.4
if [[ "$platform_in" == "Ion Torrent" && "$sv_in" == "DADA2" ]]; then 
echo -e "\nDADA2-ing now. This takes me about 6 - 12 hours, so go do something else while I'm working!\n"
FOURTH=$(name=$1 sv=$sv_in trimleft=$trimleft_in trunclen=$trunclen_in threads=$threads_in scripts/dada2.sh)
echo $FOURTH
fi
#
if [[ "$platform_in" == "Illumina" && "$sv_in" == "DADA2" ]]; then 
echo -e "\nDADA2-ing now. This takes me about 6 - 12 hours, so go do something else while I'm working!\n"
FOURTH=$(name=$1 sv=$sv_in trimleft=$trimleft_in trunclen=$trunclen_in truncrev=$trunclen_rev_in threads=$threads_in scripts/dada2_illumina.sh)
echo $FOURTH
fi
#
# Deblur
if [[ "$platform_in" == "Illumina" && "$sv_in" == 'Deblur' ]]; then
echo -e "\nDebluring now. This takes about 30-60 minutes?\n"
FOURTH=$(name=$1 sv=$sv_in trimleft=$trimleft_in trunclen=$trunclen_in threads=$threads_in scripts/deblur.sh)
echo $FOURTH
fi
fi
#
# Closed-reference OTU picking via vsearch, for use with Tax4Fun 
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 4 ]]; then
source activate qiime2-2018.4
echo -e "\nClosed-reference OTU picking via vsearch - for use with Tax4Fun\n"
FIFTH=$(name=$1 sv=$sv_in threads=$threads_in scripts/closed.sh)
echo $FIFTH 
fi
#
# Assign taxonomy Ion Torrent 
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 5 ]]; then
source activate qiime2-2018.4
if [[ "$platform_in" == "Ion Torrent" ]]; then
echo -e "\nAssigning taxonomy - 99%\n"
SIXTH=$(name=$1 sv=$sv_in scripts/assign.sh)
echo $SIXTH
fi
#
# Assign taxonomy Illumina
if [[ "$platform_in" == "Illumina" ]]; then
echo -e "\nAssigning taxonomy - 99%\n"
SIXTH=$(name=$1 sv=$sv_in scripts/assign_illumina.sh)
echo $SIXTH
fi
fi
#
# Align
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 6 ]]; then
source activate qiime2-2018.4
echo -e "\nAligning\n"
SEVENTH=$(name=$1 sv=$sv_in threads=$threads_in scripts/align.sh)
echo $SEVENTH
fi
#

# Make phylogenetic tree
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 7 ]]; then
source activate qiime2-2018.4
echo -e "\nMaking phylogenetic tree\n"
EIGTH=$(name=$1 sv=$sv_in threads=$threads_in scripts/tree.sh)
echo $EIGTH
fi
#
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 8 ]]; then
source activate qiime2-2018.4
# Enter a number to be used as sampling depth for rarefaction
echo -e "\nOkay now it's your turn. Go into the output /$1/useful/table/index.html and select the second tab. Find the bottom sample with the fewest reads, and enter the number below for sampling depth.\n"
read samdep_in
echo -e "\nDoing alpha diversity\n"
NINTH=$(name=$1 sv=$sv_in sam=$samdep_in sam_max=$sammax_in scripts/alpha.sh)
echo $NINTH 
#
echo -e "\nNow doing some beta diversity\n"
TENTH=$(name=$1 sv=$sv_in scripts/beta.sh)
echo $TENTH
fi
#
# Tax4Fun time... 
if [[ "$step_in" == 1 ]] || [[ "$step_in" < 9 ]]; then
echo -e "\nDoing Tax4Fun for you!"
mkdir $1/useful/tax4fun
cd $1 
ELEVENTH=$(name=$1 ../scripts/tax4fun.R)
echo $ELEVENTH
cd ../
#
TWELFTH=$(name=$1 scripts/key_kos.sh)
echo $TWELFTH
fi
#
echo -e "\nFinished!\n"
#
