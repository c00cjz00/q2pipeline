#!/usr/bin/env bash
# A script to download and install Miniconda, QIIME1, and QIIME2 for macOS and Linux
# Peter Leary 

if
[[ "$(uname)" ==  "Darwin" ]]; then                                             # Checks to see if running macOS and then downloads the right Miniconda
wget https://www.stats.bris.ac.uk/R/bin/macosx/R-3.4.4.pkg                      # Downloads R 3.4.4 from Bristol Uni 
sudo installer -pkg R-3.4.4.pkg -target /                                       # Installs R to the Applications folder 
rm *pkg
curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh  # Downloads the Miniconda installer 
bash Miniconda3-latest-MacOSX-x86_64.sh                                         # Executes the Miniconda installer 
rm -rf Miniconda3-latest-MacOSX-x86_64.sh                                       # Deletes the Miniconda file to be nice and tidy 
#
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then                      # Checks to see if running Linux instead, and does as above for Linux 
deb https://www.stats.bris.ac.uk/R/bin/linux/ubuntu/xenial/                     # Installs R for Ubuntu 16.04 Xenial Xerus – as this is the most recent LTS release at time of writing
curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
rm -rf Miniconda3-latest-Linux-x86_64.sh
fi
#
open -a Terminal.app install_qiime.sh                                           # Opens a new Terminal to install the two QIIMEs because Miniconda makes you close the Terminal upon installation 
echo -e "\nQIIME1 and 2 are now installing in the other window. Once these have finished, either the window will close automatically or you will see [Process Completed], in which case, you can close the window.\nEither way, you will need to open a new Terminal window to continue setting up the pipeline."
exit 0
