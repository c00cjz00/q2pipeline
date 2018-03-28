#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.11 - Tidying up 
#
#Moving alpha and beta diversity analyses 
qiime tools export ../$name/diversity/core-metrics-results/faith-pd-group-significance.qzv --output-dir ../$name/diversity/core-metrics-results/faith-pd
#
qiime tools export ../$name/diversity/core-metrics-results/evenness-group-significance.qzv --output-dir ../$name/diversity/core-metrics-results/evenness 
#
qiime tools export ../$name/diversity/core-metrics-results/unweighted-unifrac-emperor.qzv --output-dir ../$name/diversity/core-metrics-results/unweighted-unifrac
#
qiime tools export ../$name/diversity/core-metrics-results/bray-curtis-emperor.qzv --output-dir ../$name/diversity/core-metrics-results/bray-curtis-emperor
#
cp -a ../$name/diversity/core-metrics-results/faith-pd/. ../$name/useful/alpha-div/faith-pd
#
cp -a ../$name/diversity/core-metrics-results/evenness/. ../$name/useful/alpha-div/eveness
#
cp -a ../$name/diversity/core-metrics-results/unweighted-unifrac/. ../$name/useful/beta-div/unweighted-unifrac 
#
cp -a ../$name/diversity/core-metrics-results/bray-curtis-emperor/. ../$name/useful/beta-div/bray-curtis
#
