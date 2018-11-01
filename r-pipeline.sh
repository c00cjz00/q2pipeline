#!/bin/bash
# Peter Leary - 10/10/2018
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PUR='\033[0;35m'

# Make sure a project name was entered 
if [[ -z "$1" ]]; then
	echo -e "${RED}\nError - you must enter a name for the analysis at the end of the command e.g. scripts/pipeline.sh test${NC}"
	exit
fi

# Make sure the project folder has the required files
#if [[ ! -r $1/dada2 || $1/taxonomy || $1/diversity ]]; then
#echo -e "\n${RED}You don't seem to have the required files. Have you run the main pipeline, and is everything in the right place?${NC}\n"
#exit
#fi

map=$1/"$1"map.txt
SVs=$1/dada2/table.qza
tax=$1/taxonomy/taxonomy.qza
tree=$1/aligned/rooted-tree.qza
shannon=$1/diversity/core-metrics-results/shannon_vector.qza
pco=$1/diversity/core-metrics-results/unweighted_unifrac_pcoa_results.qza
bray=$1/diversity/core-metrics-results/bray_curtis_pcoa_results.qza
faith_pd=$1/diversity/core-metrics-results/faith_pd_vector.qza
pielou_e=$1/diversity/core-metrics-results/evenness_vector.qza
pco_w=$1/diversity/core-metrics-results/weighted_unifrac_pcoa_results.qza
otu=$1/useful/biomtable/otu_table.txt
taxa2=$1/useful/taxonomy2.*
mkdir $1/useful/R
wd=$1/useful/R

# Start of main section of pipeline 
echo -e "\n${PUR}R bit of the QIIME2 Pipeline by Peter Leary. Last updated 10/10/2018.\n"

# Options 
echo -e "\n${PUR}So I need to know several things about your data in order to do this analysis. Please read the following options and type in your responses carefully${NC}\n"

# Number of sample groups 
echo -e "\n${PUR}Firstly, what column from the metadata file am I comparing against? Please enter the name of the column exactly.${NC}\n"
read column_in 

col='meta$'$column_in 

echo -e "\n${PUR}Do you have a second column you would like to include for the points of the nMDS? If yes, type it in below. If not, just press return.${NC}\n"
read column2_in

col2='meta$'$column2_in

echo -e "\n${PUR}Next, what column would you like to label the samples by? E.g., depth, replicate? Please enter the column name below.${NC}\n"
read sample_in

Rscript scripts/r-pipeline.R $1 $column_in $sample_in $map $SVs $tax $tree $shannon $pco $bray $faith_pd $pielou_e $pco_w $otu $column2_in $wd $taxa2