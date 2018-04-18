# q2pipeline
# Introduction 
QIIME2 Pipeline Scripts for IMH Group (March 2018) – By Peter Leary, Newcastle University  

A collection of badly-written scripts based on the Moving Pictures tutorial: https://docs.qiime2.org/2018.2/tutorials/moving-pictures/ 

The intention is to perform pipeline analysis on 16S rRNA gene sequencing data from the Illumina and Ion Torrent platforms, with a few extra steps including preparing data for and running in Tax4Fun (Asshauer et al., 2015), using QIIME2 (currently 2018.2) (Caporaso et al., 2010) (I will include ITS support as soon as anyone asks me for it)... 

A full list of references can be found in the References Wiki.

## Caveat! 
I am not at liberty to host the reference database files (SILVA, UNITE) as they belong to their respective owners! Therefore, these scripts will not work 'as-is' as they do not contain to required feature classifiers. You can download the reference databases yourself and create your own naive-Bayes trained classifiers. However, since this set of scripts is intended for use and distribution amongst the IMH group at Newcastle University, I will be more than happy to give you a copy of my own feature classifiers, or show you how to get them from our group computer. 

# How to set up 
You must have QIIME2 installed at the very least. Additionally, you will need QIIME1 if you plan to use Ion Torrent data, and R if you wish to use Tax4Fun.   
 
 -- https://docs.qiime2.org/2018.2/install/native/
   
 -- http://qiime.org/install/install.html
    
 -- https://www.stats.bris.ac.uk/R/ 

However, there is a script in this here collection that will install R, Miniconda, QIIME2, and QIIME1 on your computer for you. I think it may require Xcode being installed on your Mac. This is available in the Mac App Store. 

1. Download the .zip file containing all the scripts, by clicking the green 'Clone or download' button on the top of the main Q2 Pipeline page. Unzip it, and copy the extracted folder to a useful place, e.g., Desktop. It will be called q2pipeline-master when you download and unzip it. You can rename it if you like, to anything really. 

2. Open a terminal and cd to where you saved the extracted folder, e.g.
  > cd ~/Desktop/q2pipeline-master

And then bring life to the scripts by typing 
  > sudo chmod a+x *sh
  
  > sudo chmod a+x *R

If you want to run the script that will install everything, like QIIME1 and 2 and R, enter the following command.
  > ./install_all.sh 

Once it's finished installing, it's best to close all current Terminal windows and cd back to /q2pipeline-master.

Okay, now execute the script that will tidy everything up and create the right folders for you 
  > source ./setup.sh
  
And then lastly, execute the script that will install Tax4Fun and its dependencies. It also downloads the SILVA119 files needed for Tax4Fun *but not for closed-reference OTU picking* – these will still need downloading. Make sure you install R first (you don't need RStudio for this...)!
  > ./scripts/install_tax4fun.R


3. Grab a copy of the feature classifiers, either by making your own, asking me, or copying them from the group computer. Copy them into the folder labelled 'Classifiers'. Put the right classifier in the right folder e.g.; 


- SILVA132 V4 99% classifier for Illumina goes in the folder labelled 'Illumina', 

- SILVA132 V4-V5 99% classifier for Ion Torrent goes in 'Ion Torrent', 

- The silva119 files for Tax4Fun go in 'silva119' – for this you need the 99_otus.qza and taxonomy string.


Make sure you don't put any folders in the Illumina, Ion Torrent, or silva119 folders, only actual files. So it should look like '/illumina/classifier.qza' not '/illumina/silva119/classifier.qza'. 
  
  -- These three steps are all you need to set up the scripts on your computer. You can replace the classifiers with newer versions as and when is necessary. -- 



  -- The following steps are how to run the pipeline each time on your own machine, assuming you've completed the first two steps properly. -- 

# How to run the pipeline 
1. Create a folder in the extracted folder (which is now on the Desktop or wherever you put it) and call it something sensible pertaining to your project. For the purposes of this readme, we'll call our project TEST
 - So you now have: ~/Desktop/q2pipeline-master/ which contains the scripts folder, your classifiers folder, and a folder called TEST. 
  
2. In your project folder (TEST), you will place your map file along with your raw sequence data. Your map file should be called after your project, so for this example, it will be called testmap.txt
 
 -- Illumina: You will have received your demultiplexed data (already split into individual samples per barcode) in a series of folders, each containing two fastqs, the forward and reverse read. You need to put all these fastqs into one folder called 'Seqs', within your project (TEST) folder. 
  
  -- Ion Torrent: You will have one multiplexed fastq file. Put this in your project (TEST) folder. Rename your fastq to the project name, e.g., test.fastq

  - So to recap this step, in your ~/Desktop/q2pipeline-master/TEST folder, you will have testmap.txt, and either a Seqs folder or a test.fastq file. Now you're ready to run the pipeline.

5. Open a Terminal (macOS or Linux, not compatibable with Windows PowerShell), and cd to the location of the main folder, e.g., cd ~/Desktop/q2pipeline-master

6. enter the following command, where 'test' is replaced by whatever you've called your project folder and files. 
  > ./scripts/pipeline.sh test 
  
And follow the on-screen instructions. It will ask you to input a series of options. Read and type carefully, it's a sensitive soul is this pipeline. 
  - First it will ask whether this data is from Illumina or Ion Torrent, so type your response accordingly. It is case sensitive, so use capital I and T!
  - It will then ask you whether you'd like to use DADA2 or Deblur for the denoising/ASV step. I'll be honest with you, I have no intention of using Deblur, but type one and hit return. 
  
  
Firstly, it will ask you from what step you wish to start your analysis. This is useful if you wish to rerun certain steps without rerunning the whole thing, e.g., using a new classifier without having to run DADA2 all over again. Just enter the number of the step you wish to start from, and away it goes. It does require you to have all the files from the previous steps in the right place though, because it will look for them in the same way it looks for them if it was doing the whole thing. This is fine if you've used this pipeline previously because everything will be there, but it probably won't work if you've done your own analysis because you likely called things different names and put them in different folders. 


Over the next few steps, it will ask you how you'd like to trim and truncate your reads. This is quite difficult because you do not yet know the quality of your reads, or how that quality deteriorates with length. Therefore, some assumptions are required. Ideally, we'd prepare the Demux files that give you this information first, but that would mean you'd have to set the pipeline away and then come back after like 20 minutes. Also, it should be possible to get quality information straight from whoever did your sequencing. Anyway, I digress. 
  - Trimming removes *n* number of bases from the 5' end. A good number is usually 13 (Illumina) or 20 (Ion Torrent), to make sure any non-biological bases are definitely removed (e.g., adaptors). So, enter a number, like 13 or 20, and hit return.
  - Truncating cuts your reads off at *n* at the 3' end. This is usually to remove low quality bases at the end of reads. With Ion Torrent, my experience is that most anything past about 300 bp is low-quality and best removed. With Illumina paired-end, the forward read is usuall good quality 'til about 240 bp, and the reverse reads is usually good until about 180 bp. So, enter a number for truncating. If later you decide that these are too short/long, you can always run again with more appropriate numbers. 
  
It will then ask how many cores/threads your computer has. For most of you, using a 13" MacBook Pro, the answer is 2. So type 2 and hit return. If you have a fancier computer, it might be 4, so type that. If you have a really nice machine, like the iMac (or my 15" MacBook Pro with Intel i7) the answer is 8. So hit 8. 

  
Then that's it! The pipeline will do the rest! A brief overview of what the pipeline does can be found in the pipeline_overview document.
