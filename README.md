# q2pipeline
# Introduction 
QIIME2 Pipeline Scripts for IMH Group (March 2018) – By Peter Leary, Newcastle University  

A badly appropriated set of scripts based on the Moving Pictures tutorial: https://docs.qiime2.org/2018.2/tutorials/moving-pictures/ 

The intention is to perform pipeline analysis on 16S and ITS rRNA gene sequencing data from the Illumina and Ion Torrent platforms, with a few extra steps including preparing data for and running in Tax4Fun (Asshauer et al., 2015), using QIIME2 (currently 2018.2) (Caporaso et al., 2010). 

These scripts employ the SILVA132 and 119 databases (for taxonomic and Tax4Fun analysis respectively) (Quast et al., 2011) for 16S, and the UNITE 7.2 database for ITS (Kõljalg et al., 2005). 

A full list of references can be found in the References file. 

# Caveat! 
I am not at liberty to host the reference database files (SILVA, UNITE) as they belong to their respective owners! Therefore, these scripts will not work 'as-is' as they do not contain to required feature classifiers. You can download the reference databases yourself and create your own naive-Bayes trained classifiers. However, since this set of scripts is intended for use and distribution amongst the IMH group at Newcastle University, I will be more than happy to give you a copy of my own feature classifiers, or show you how to get them from our group computer. 

# How to set up 
1. Download the .zip file containing all the scripts, unzip it, and copy the extracted folder to a useful place, e.g., Desktop

2. Open a terminal and cd to where you saved the extracted folder, e.g.
  > cd ~/Desktop/QIIME2 
And then bring life to the scripts by typing 
  > sudo chmod a+x scripts/*sh 

2. Grab a copy of the feature classifiers, either by making your own, asking me, or copying them from the group computer. Copy them into the folder labelled 'Classifiers'. Put the right classifier in the right folder i.e., V4 16S Illumina SILVA132 classifier goes in the folder labelled 'Illumina', ITS2 UNITE Ion Torrent classifier goes in the folder labelled 'Unite'.
  
  -- These two steps you only need to do once to set up the scripts on your computer. You can replace the classifiers with newer versions as and when is necessary. -- 
  
  -- The following steps are how to run the pipeline each time on your own machine, assuming you've completed the first two steps properly. -- 
  
3. Create a folder in the extracted folder (which is now on the Desktop or wherever you put it) and call it something sensible pertaining to your project. For the purposes of this readme, we'll call our project MUSE (because you should all listen to more MUSE.)
  So you now have: ~/Desktop/QIIME2/ which contains the scripts folder, your classifiers folder, and a folder called MUSE. 
  
4. In your project folder (MUSE), you will place your map file along with your raw sequence data. Your map file should be called after your project, so for this example, it will be called musemap.txt
  -- Illumina: You will have received your demultiplexed data (already split into individual samples per barcode) in a series of folders, each containing two fastqs, the forward and reverse read. You need to put all these fastqs into one folder called 'Seqs', within your project (MUSE) folder. 
  -- Ion Torrent: You will have one multiplexed fastq file. Put this in your project (MUSE) folder. Rename your fastq to the project name, e.g., muse.fastq

So to recap this step, in your ~/Desktop/QIIME2/MUSE folder, you will have musemap.txt, and either a Seqs folder or a muse.fastq file. Now you're ready to run the pipeline.

5. Open a Terminal (macOS or Linux, not compatibable with Windows PowerShell), and cd to the location of the scripts folder, e.g., cd ~/Desktop/QIIME2

6. enter the following command 
  > scripts/pipeline.sh 
