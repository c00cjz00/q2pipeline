#!/usr/bin/env Rscript

# A script to install Tax4Fun and its dependencies... 

install.packages('qiimer', repos='http://cran.us.r-project.org')
install.packages('RJSONIO', repos='http://cran.us.r-project.org')
install.packages('https://cran.r-project.org/src/contrib/Archive/biom/biom_0.3.12.tar.gz')
install.packages('http://tax4fun.gobics.de/Tax4Fun/Tax4Fun_0.3.1.tar.gz')
download.file('http://tax4fun.gobics.de/Tax4Fun/ReferenceData/SILVA119.zip', destfile="classifiers/tax4fun/SILVA119")