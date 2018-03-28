#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary 
#Step 2.1 - importing EMP-protocol data 
qiime tools import \
  --type EMPSingleEndSequences \
  --input-path $HOME/Desktop/QIIME2/$name/emp \
  --output-path $HOME/Desktop/QIIME2/$name/emp/emp-single-end-sequences.qza