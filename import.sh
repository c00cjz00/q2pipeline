#!/bin/bash
# QIIME 2 Pipeline by Peter Leary 
 
qiime tools import \
  --type EMPSingleEndSequences \
  --input-path $name/emp \
  --output-path $name/emp/emp-single-end-sequences.qza
