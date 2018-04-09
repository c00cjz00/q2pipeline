#!/usr/bin/env bash
# A script to download and install Miniconda, QIIME1, and QIIME2 for macOS and Linux
# Peter Leary 

if
[[ "$(uname)" ==  "Darwin" ]]; then                                             # Checks to see if running macOS and then downloads the right Miniconda
curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh 
echo -e "\nPlease follow the instructions to install Miniconda.\n"
bash Miniconda3-latest-MacOSX-x86_64.sh
rm -rf Miniconda3-latest-MacOSX-x86_64.sh                                       # Deletes the Miniconda file to be nice and tidy 
#
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then                      # Checks to see if running Linux instead, and do the right thing 
curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
echo -e "\nPlease follow the instructions to install Miniconda.\n"
bash Miniconda3-latest-Linux-x86_64.sh
rm -rf Miniconda3-latest-Linux-x86_64.sh
fi
#
open -a Terminal.app install_qiime.sh                                           # Opens a new Terminal to install the two QIIMEs because Miniconda makes you close the Terminal upon installation 
echo -e "\nQIIME1 and 2 are now installing in the other window. Once these have finished, either the window will close automatically or you will see [Process Completed], in which case, you can close the window.\nEither way, you will need to open a new Terminal window to continue setting up the pipeline."
exit 