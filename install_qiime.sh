#!/bin/bash
# Peter Leary 
if
[[ "$(uname)" ==  "Darwin" ]]; then                                             # Checks to see if running macOS and then downloads the right Miniconda
wget https://data.qiime2.org/distro/core/qiime2-2018.2-py35-osx-conda.yml       # Downloads the .yaml for QIIME2 
conda env create -n qiime2-2018.2 --file qiime2-2018.2-py35-osx-conda.yml       # Creates the QIIME2 environment
rm qiime2-2018.2-py35-osx-conda.yml                                             # Deletes the QIIME2 .yaml to be tidy 
conda create -n qiime1 python=2.7 qiime matplotlib=1.4.3 mock nose -c bioconda  # Installs QIIME1 too for good measure 
#
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then                      # Checks to see if running Linux and does the same things as above 
wget https://data.qiime2.org/distro/core/qiime2-2018.2-py35-linux-conda.yml
conda env create -n qiime2-2018.2 --file qiime2-2018.2-py35-linux-conda.yml
rm qiime2-2018.2-py35-linux-conda.yml
conda create -n qiime1 python=2.7 qiime matplotlib=1.4.3 mock nose -c bioconda
fi 
#
exit 0                                                                          # Closes the Terminal 
