#!/bin/bash
#Peter Leary
mkdir ~/Desktop/qiime2/$name/demux
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path ~/Desktop/QIIME2/$name/seqs \
  --source-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path ~/Desktop/qiime2/$name/demux/demux.qza
#
qiime demux summarize \
--i-data ~/Desktop/qiime2/$name/demux/demux.qza \
--o-visualization ~/Desktop/qiime2/$name/demux/demux.qzv
#
qiime tools export \
~/Desktop/qiime2/$name/demux/demux.qzv \
--output-dir ~/Desktop/qiime2/$name/demux/demux