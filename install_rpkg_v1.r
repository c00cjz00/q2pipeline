#!/usr/bin/env Rscript
# example https://www.digitalocean.com/community/tutorials/how-to-install-r-packages-using-devtools-on-ubuntu-16-04
# sudo apt-get install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev
# sudo -i R
# install.packages('devtools')
# sudo apt-get install -y r-cran-latticeextra
# sudo apt-get install libzmq3-dev libcurl4 libcurl4-openssl-dev
# sudo apt-get install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev
install.packages("vegan")
source("https://bioconductor.org/biocLite.R")
biocLite("BiocInstaller")
source("https://bioconductor.org/biocLite.R")
biocLite("philr")
source("https://bioconductor.org/biocLite.R")
biocLite("DECIPHER")
source("https://bioconductor.org/biocLite.R")
biocLite("phyloseq")
source("https://bioconductor.org/biocLite.R")
biocLite("Biostrings")
devtools::install_github("jbisanz/MicrobeR")
devtools::install_github("jbisanz/qiime2R")
