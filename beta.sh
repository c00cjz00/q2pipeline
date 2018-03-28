#!/bin/bash
#QIIME 2 Ion Torrent Pipeline by Peter Leary
#Step 2.10 - Beta diversity
qiime emperor plot \
  --i-pcoa ../$name/diversity/core-metrics-results/unweighted_unifrac_pcoa_results.qza \
  --m-metadata-file ../$name/"$name"map.txt \
  --o-visualization ../$name/diversity/core-metrics-results/unweighted-unifrac-emperor.qzv \
  --quiet
#
qiime emperor plot \
  --i-pcoa ../$name/diversity/core-metrics-results/bray_curtis_pcoa_results.qza \
  --m-metadata-file ../$name/"$name"map.txt \
  --o-visualization ../$name/diversity/core-metrics-results/bray-curtis-emperor.qzv \
  --quiet
