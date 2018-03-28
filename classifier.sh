qiime feature-classifier extract-reads \
  --i-sequences ~/Desktop/qiime2/gg/97_otus.qza \
  --p-f-primer GTGNCAGCMGCCGCGGTAA \
  --p-r-primer CCGYCAATTYMTTTRAGTTT \
  --o-reads ~/Desktop/qiime2/gg/ref-seqs2.qza
  
  qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads ~/Desktop/qiime2/gg/ref-seqs.qza \
  --i-reference-taxonomy ~/Desktop/qiime2/gg/97_otu_taxonomy.qza \
  --o-classifier ~/Desktop/qiime2/gg/ggclassifier.qza