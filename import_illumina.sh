#!/bin/bash
#Peter Leary
mkdir $name/demux
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $name/seqs \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path $name/demux/demux.qza
#
qiime demux summarize \
--i-data $name/demux/demux.qza \
--o-visualization $name/demux/demux.qzv
#
qiime tools export --input-path $name/demux/demux.qzv --output-path $name/demux/demux
