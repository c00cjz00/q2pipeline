#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.11 - Tidying up 
#
#Moving alpha and beta diversity analyses 
qiime tools export $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/faith-pd-group-significance.qzv --output-dir $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/faith-pd
#
qiime tools export $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/evenness-group-significance.qzv --output-dir $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/evenness 
#
qiime tools export $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/unweighted-unifrac-emperor.qzv --output-dir $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/unweighted-unifrac
#
qiime tools export $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/bray-curtis-emperor.qzv --output-dir $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/bray-curtis-emperor
#
cp -a $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/faith-pd/. $HOME/Desktop/QIIME2/$name/useful/alpha-div/faith-pd
#
cp -a $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/evenness/. $HOME/Desktop/QIIME2/$name/useful/alpha-div/eveness
#
cp -a $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/unweighted-unifrac/. $HOME/Desktop/QIIME2/$name/useful/beta-div/unweighted-unifrac 
#
cp -a $HOME/Desktop/QIIME2/$name/diversity/core-metrics-results/bray-curtis-emperor/. $HOME/Desktop/QIIME2/$name/useful/beta-div/bray-curtis
#