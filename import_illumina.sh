#!/bin/bash
#Peter Leary
mkdir $name/demux
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $name/seqs \
  --source-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path $name/demux/demux.qza
#
qiime demux summarize \
--i-data $name/demux/demux.qza \
--o-visualization $name/demux/demux.qzv
#
qiime tools export $name/demux/demux.qzv --output-dir $name/demux/demux
