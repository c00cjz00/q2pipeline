# q2pipeline
## Introduction 
QIIME2 Pipeline Scripts by Peter Leary, Newcastle University  

A collection of badly-written scripts based on the Moving Pictures tutorial: https://docs.qiime2.org/2018.8/tutorials/moving-pictures/ 

The intention is to perform pipeline analysis on 16S and ITS rRNA gene sequencing data from the Illumina and Ion Torrent platforms, with a few extra steps where appropriate, including preparing data for and running in Tax4Fun (Asshauer et al., 2015), using QIIME2 (currently 2018.8) (Caporaso et al., 2010) 

A full list of references can be found in the References Wiki. 

*By using this pipeline, you agree to not only cite the authors of QIIME and the tools used, but me and this pipeline. I think that's fair. Please reference this Github page! Thank you!* 

### Caveat! Regarding taxonomy classifiers! Read me! 
I am not supposed to host the reference database files (SILVA, UNITE) as they belong to their respective owners! Therefore, these scripts will not work 'as-is' as they do not contain to required feature classifiers. You can download the reference databases yourself and create your own naive-Bayes trained classifiers. However, if you email me at peter{dot}leary{at}ncl{dot}ac{dot}uk, I can help you out (*wink wink*)...

Although! 

Greg Caporaso over on the QIIME2 forums has posted two SILVA 132 (most recent) classifiers here https://forum.qiime2.org/t/silva-132-classifiers/3698 – one for the V4 region, one for the whole 16S. These will both do nicely for now. If you want to make your own, there's a guide here https://github.com/peterleary/q2pipeline/wiki/Creating-your-own-classifier

You can download SILVA files here: https://www.arb-silva.de/download/archive/qiime/ 

For SILVA119/Tax4Fun, you'll also need to download the SILVA_119_release.zip. From that, you'll need the 99% OTUs rep set file and corresponding taxonomy string. The rep set fasta file needs to be imported into QIIME2. Instructions for this are in the Wiki. 

# Installing QIIME
QIIME2 is super easy to install on Mac and Linux.

> https://docs.qiime2.org/2018.8/install/native/

You must have QIIME2 installed at the very least. Additionally, you will need QIIME1 if you plan to use Ion Torrent data, and R if you wish to use Tax4Fun.   
   
> http://qiime.org/install/install.html
    
> https://www.stats.bris.ac.uk/R/ 

However, there is a script in this collection that will install everything for you. I'm not sure how well it will work on your machine (it works on mine, but I have lots of extras installed that you might not), but give it a go:

`./install_all.sh`


# Setting up the pipeline 
## Part 1 – Downloading the scripts 
1. Open a terminal and `cd` to somewhere useful, e.g., `cd ~/Desktop`, then enter the following: 

`git clone https://github.com/peterleary/q2pipeline`

This saves a copy of the latest pipeline scripts to the Desktop in a folder called 'q2pipeline'. Cd into the folder `cd q2pipeline`. 

1A. Alternative to using git clone, download the .zip file containing all the scripts, by clicking the green 'Clone or download' button on the top of the main Q2 Pipeline page. Unzip it, and copy the extracted folder to a useful place, e.g., Desktop. It will be called q2pipeline-master when you download and unzip it. You can rename it if you like, to anything really. 

And then bring life to the scripts by typing 

`chmod a+x *sh`  -- *sudo* may or may not be required on your computer, e.g., `sudo chmod a+x *sh`, which will require the admin password for the first time 
  
`chmod a+x *R`

*If you want to run the script that will install everything, like QIIME1 and 2 and R, enter the following command.*

`./install_all.sh`

Once it's finished installing, it's best to close all current Terminal windows and `cd` back to `/q2pipeline-master` folder.

Okay, now execute the script that will tidy everything up and create the right folders for you 

`source ./setup.sh`
  
And then lastly, execute the script that will install Tax4Fun and its dependencies. It also downloads the SILVA119 files needed for Tax4Fun *but not for closed-reference OTU picking* – these will still need downloading. Make sure you install R first (you don't need RStudio for this...)!

`./scripts/install_tax4fun.R`

**Note: Currently, it looks like this script is required each time you run a pipeline instance to make Tax4Fun work. I'll identify the issue soon I hope!** 


## Part 2 – Getting the feature classifiers in the right place 

2. Grab a copy of the feature classifiers, either by making your own, asking me, or copying them from the group computer. Copy them into the folder labelled 'Classifiers'. Or download from here (https://forum.qiime2.org/t/silva-132-classifiers/3698) Put the right classifier in the right folder based on sequencing platform e.g.; 

### 16S rRNA gene - SILVA 132 database 

> SILVA132 V4 99% classifier for Illumina goes in the folder labelled 'illumina_16S', 

OR

> SILVA132 V4-V5 99% classifier for Ion Torrent goes in 'iontorrent_16S', 

AND

> The SILVA119 files for Tax4Fun go in 'silva119' – for this you need the 99_otus.qza and taxonomy string.

### ITS gene - UNITE database 

> UNITE ITS dynamic classifier for Illumina and Ion Torrent can go in both the 'UNITE' folder. This is because we don't extract or truncate the reads for ITS, so the classifier is the same either way. 

Make sure you don't put any folders in the Illumina, Ion Torrent, or silva119 folders, only actual files. So it should look like '/illumina_16S/classifier.qza' not '/illumina_16S/silva119/classifier.qza'. 
  
  -- These two main steps are all you need to set up the scripts on your computer. You can replace the classifiers with newer versions as and when is necessary. -- 

You should only need to do this once. However, QIIME2 and the scripts get updated fairly regularly, so if it's been 6 months since your last analysis, set up from scratch. I know it looks faffy but it's good practice to be upto-date with everything whenever possible! 

  -- The following steps are how to run the pipeline each time on your own machine, assuming you've completed the first two steps properly. -- 

# How to run the pipeline 
## Setting up a pipeline run 
1. Create a folder in the extracted folder (which is now on the Desktop or wherever you put it) and call it something sensible pertaining to your project. For the purposes of this readme, we'll call our project TEST
 - So you now have: `~/Desktop/q2pipeline/` which contains the scripts folder, your `classifiers` folder (along with a `scripts` folder), and a folder called `TEST`. 
  
2. In your project folder (TEST), you will place your map file along with your raw sequence data. Your map file should be called after your project, so for this example, it will be called `testmap.txt`
 
> Illumina: You will have received your demultiplexed data (already split into individual samples per barcode) in a series of folders, each containing two fastqs, the forward and reverse read. You need to put all these fastqs into one folder called 'Seqs', within your project (TEST) folder. 
>> It is very important your Illumina filenames follow the standard format of x_x_L001_R1_001.fastq.gz (or R2 for reverse) – if they do not, QIIME2 will throw a fit, and you'll have to fix them. You can use the `rename` function from Homebrew to fix them all in one go. 
  
> Ion Torrent: You will have one multiplexed fastq file. Put this in your project (TEST) folder. Rename your fastq to the project name, e.g., test.fastq
>> If you have a full multiplexed fastq file and only want to run certain samples from it, or combine them with other samples, this is possible but is a bit fiddly. Email me at the address above and I can send you a sample script I have to do this. 

  - So to recap this step, in your `~/Desktop/q2pipeline-master/TEST` folder, you will have `testmap.txt`, AND either a `Seqs` folder OR a `test.fastq` file. Now you're ready to run the pipeline.  

## Running the pipeline for reals
1. Open a Terminal (macOS or Linux, not compatibable with Windows PowerShell), and `cd` to the location of the main folder, e.g., `cd ~/Desktop/q2pipeline-master`

2. enter the following command, where 'test' is replaced by whatever you've called your project folder and files. 

`./scripts/pipeline.sh test`
  
And follow the on-screen instructions. It will ask you to input a series of options. Read and type carefully, it's a sensitive soul is this pipeline. 

  
Firstly, it will ask you from what step you wish to start your analysis. This is useful if you wish to rerun certain steps without rerunning the whole thing, e.g., using a new classifier without having to run DADA2 all over again. Just enter the number of the step you wish to start from, and away it goes. It does require you to have all the files from the previous steps in the right place though, because it will look for them in the same way it looks for them if it was doing the whole thing. This is fine if you've used this pipeline previously because everything will be there, but it probably won't work if you've done your own analysis because you likely called things different names and put them in different folders. 


Next, it will ask you how you'd like to trim and truncate your reads. This can be quite difficult for a new sequencing dataset because you might not yet know the quality of your reads, or how that quality deteriorates with length. Therefore, some assumptions may be required. Ideally, we'd prepare the Demux files that give you this information first, but that would mean you'd have to set the pipeline away and then come back after like 20 minutes. Also, it should be possible for you to get quality information straight from whomever did your sequencing. Anyway, I digress. 
  - Trimming removes *n* number of bases from the 5' -> 3' end. A good number is usually 13 (Illumina) or 20 (Ion Torrent), to make sure any non-biological bases are definitely removed (e.g., adaptors). So, enter a number, like 13 or 20, and hit return.
  - Truncating cuts your reads off at *n* at the 3' -> 5' end. This is usually to remove low quality bases at the end of reads. With Ion Torrent, my experience is that most anything past about 300 bp is low-quality and best removed. With Illumina paired-end, the forward read is usually good quality all the way to ~240 bp, and the reverse reads is usually good until about 180 bp. So, enter a number for truncating. If later you decide that these are too short/long, you can always run again with more appropriate numbers. 
  >> Don't forget that if you're looking at the sequencing quality information for the reverse read, it'll be presented as 5' -> 3', so the bases you'll be truncating are from right to left, but they're the ones that match the 5' -> 3' from left to right of the forward read! 
  
It will then ask how many cores/threads your computer has. For most of you, using a 13" MacBook Pro, the answer is 2. So type 2 and hit return. If you have a fancier computer, it might be 4, so type that. If you have a really nice machine, like the iMac (or my 15" MacBook Pro with Intel i7) the answer is 8. So hit 8. 

  
Then that's it! The pipeline will do the rest! A brief overview of what the pipeline does can be found in the pipeline_overview document.
