# q2pipeline
# Introduction 
QIIME2 Pipeline Scripts for IMH Group (March 2018) – By Peter Leary, Newcastle University  

A badly appropriated set of scripts based on the Moving Pictures tutorial: https://docs.qiime2.org/2018.2/tutorials/moving-pictures/ 

The intention is to perform pipeline analysis on 16S rRNA gene sequencing data from the Illumina and Ion Torrent platforms, with a few extra steps including preparing data for and running in Tax4Fun (Asshauer et al., 2015), using QIIME2 (currently 2018.2) (Caporaso et al., 2010). 
  - I will include ITS support as soon as anyone asks me for it... 

A full list of references can be found in the References Wiki.

# Caveat! 
I am not at liberty to host the reference database files (SILVA, UNITE) as they belong to their respective owners! Therefore, these scripts will not work 'as-is' as they do not contain to required feature classifiers (except Greengenes...). You can download the reference databases yourself and create your own naive-Bayes trained classifiers. However, since this set of scripts is intended for use and distribution amongst the IMH group at Newcastle University, I will be more than happy to give you a copy of my own feature classifiers, or show you how to get them from our group computer. 

# How to set up 
  - You must have QIIME2 installed, clearly. It takes about 10 minutes and is incredibly simple on macOS and Linux.
    -- https://docs.qiime2.org/2018.2/install/native/
  - You must have *both* QIIME1 and QIIME2 installed if you wish to analyse Ion Torrent Data.
    -- http://qiime.org/install/install.html
  - You must have R installed (tesed on R 3.4.3)
1. Download the .zip file containing all the scripts, unzip it, and copy the extracted folder to a useful place, e.g., Desktop. You can rename it if you like, to anything really. QIIME2 is a sensible name. 

2. Open a terminal and cd to where you saved the extracted folder, e.g.
  > cd ~/Desktop/QIIME2

And then bring life to the scripts by typing 
  > sudo chmod a+x *sh
  
  > sudo chmod a+x *R

Next, execute the script that will tidy everything up and create the right folders for you 
  > source ./setup.sh
  
And then lastly, execute the script that will install Tax4Fun and its dependencies. Make sure you install R (you don't need RStudio for this...)
  > source ./scripts/install_tax4fun.R


3. Grab a copy of the feature classifiers, either by making your own, asking me, or copying them from the group computer. Copy them into the folder labelled 'Classifiers'. Put the right classifier in the right folder i.e., V4 16S Illumina SILVA132 classifier goes in the folder labelled 'Illumina', V4-V5 16S Ion Torrent SILVA132 classifier goes in 'Ion Torrent'. The SILVA119 files for Tax4Fun go in 'SILVA119'. Make sure you don't put any folders in the Illumina, Ion Torrent, or silva119 folders, only actual files. So it should look like '/silva119/99_otus.qza' not '/silva119/silva119/99_otus.qza'. 
  
  -- These three steps are all you need to set up the scripts on your computer. You can replace the classifiers with newer versions as and when is necessary. -- 
  
  -- The following steps are how to run the pipeline each time on your own machine, assuming you've completed the first two steps properly. -- 

# How to run the pipeline 
1. Create a folder in the extracted folder (which is now on the Desktop or wherever you put it) and call it something sensible pertaining to your project. For the purposes of this readme, we'll call our project TEST
 - So you now have: ~/Desktop/QIIME2/ which contains the scripts folder, your classifiers folder, and a folder called TEST. 
  
2. In your project folder (TEST), you will place your map file along with your raw sequence data. Your map file should be called after your project, so for this example, it will be called testmap.txt
 
 -- Illumina: You will have received your demultiplexed data (already split into individual samples per barcode) in a series of folders, each containing two fastqs, the forward and reverse read. You need to put all these fastqs into one folder called 'Seqs', within your project (TEST) folder. 
  
  -- Ion Torrent: You will have one multiplexed fastq file. Put this in your project (TEST) folder. Rename your fastq to the project name, e.g., test.fastq

  - So to recap this step, in your ~/Desktop/QIIME2/TEST folder, you will have testmap.txt, and either a Seqs folder or a test.fastq file. Now you're ready to run the pipeline.

5. Open a Terminal (macOS or Linux, not compatibable with Windows PowerShell), and cd to the location of the main folder, e.g., cd ~/Desktop/QIIME2

6. enter the following command, where 'test' is replaced by whatever you've called your project folder and files. 
  > ./scripts/pipeline.sh test 
  
And follow the on-screen instructions. It will ask you to input a series of options. Read and type carefully, it's a sensitive soul is this pipeline. 
  - First it will ask whether this data is from Illumina or Ion Torrent, so type your response accordingly. It is case sensitive, so use capital I and T!
  - It will then ask you whether you'd like to use DADA2 or Deblur for the denoising/ASV step. I'll be honest with you, I have no intention of using Deblur, but type one and hit return. 

Over the next two steps, it will ask you how you'd like to trim and truncate your reads. This is quite difficult because you do not yet know the quality of your reads, or how that quality deteriorates with length. Therefore, some assumptions are required. Ideally, we'd prepare the Demux files that give you this information first, but that would mean you'd have to set the pipeline away and then come back after like 20 minutes. Also, it should be possible to get quality information straight from whoever did your sequencing. Anyway, I digress. 
  - Trimming removes *n* number of bases from the 5' end. A good number is usually 16 (Illumina) or 20-25 (Ion Torrent), to make sure any non-biological bases are definitely removed (e.g., adaptors). So, enter a number, like 16 or 25, and hit return.
  - Truncating cuts your reads off at *n* at the 3' end. This is usually to remove low quality bases at the end of reads. With Ion Torrent, my experience is that most anything past about 300 bp is low-quality and best removed. With Illumina paired-end, the forward read is usuall good quality 'til about 240 bp, and the reverse reads is usually good until about 180 bp. So, enter a number for truncating. If later you decide that these are too short/long, you can always run again with more appropriate numbers. 
  
It will then ask how many cores/threads your computer has. For most of you, using a 13" MacBook Pro, the answer is 2. So type 2 and hit return. If you have a fancier computer, it might be 4, so type that. If you have a really nice machine, like the iMac (or my 15" MacBook Pro with Intel i7) the answer is 8. So hit 8. 

Lastly, it will ask you from what step you wish to start your analysis. This is useful if you wish to rerun certain steps without rerunning the whole thing, e.g., using a new classifier without having to run DADA2 all over again. Just enter the number of the step you wish to start from, and away it goes. It does require you to have all the files from the previous steps in the right place though, because it will look for them in the same way it looks for them if it was doing the whole thing. This is fine if you've used this pipeline previously because everything will be there, but it probably won't work if you've done your own analysis because you likely called things different names and put them in different folders. 
  
Then that's it! The pipeline will do the rest! A brief overview of what the pipeline does can be found in the pipeline_overview document.
