#!/bin/bash
#Peter Leary
mkdir $name/demux
if [[ "$gene" == "16S" ]]; then
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $name/seqs \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path $name/demux/demux.qza
fi
if [[ "$gene" == "ITS" ]]; then
qiime tools import \
    --type 'SampleData[PairedEndSequencesWithQuality]' \
    --input-format PairedEndFastqManifestPhred33 \
    --input-path $name/manifest.* \
    --output-path $name/demux/demux.qza
#
echo -e "\nDoing ITSxpress to extract only exact ITS sequences.\n"
qiime itsxpress trim-pair-output-unmerged\
  --i-per-sample-sequences $name/demux/demux.qza \
  --p-region ITS1 \
  --p-taxa F \
  --p-cluster-id 1.0 \
  --p-threads $threads \
  --o-trimmed $name/demux/trim.qza
fi
qiime demux summarize \
--i-data $name/demux/demux.qza \
--o-visualization $name/demux/demux.qzv
#
qiime tools export --input-path $name/demux/demux.qzv --output-path $name/demux/demux
