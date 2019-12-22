#!/bin/bash
# Peter Leary 
conda env remove --name qiime2-2019.10
if
[[ "$(uname)" ==  "Darwin" ]]; then                                             # Checks to see if running macOS and then downloads the right Miniconda
#wget https://www.stats.bris.ac.uk/R/bin/macosx/R-3.5.2.pkg                      # Downloads R 3.4.4 from Bristol Uni 
#sudo installer -pkg R-3.5.2.pkg -target /                                       # Installs R to the Applications folder 
#rm *pkg                                                                         # Delete R pkg to be tidy
#wget https://data.qiime2.org/distro/core/qiime2-2019.4-py35-osx-conda.yml       # Downloads the .yaml for QIIME2 
#conda env create -n qiime2-2019.4 --file qiime2-2019.4-py35-osx-conda.yml       # Creates the QIIME2 environment
#rm qiime2-2019.4-py35-osx-conda.yml                                            # Deletes the QIIME2 .yaml to be tidy 
wget https://data.qiime2.org/distro/core/qiime2-2019.10-py36-osx-conda.yml
conda env create -n qiime2-2019.10 --file qiime2-2019.10-py36-osx-conda.yml
# OPTIONAL CLEANUP
rm qiime2-2019.10-py36-osx-conda.yml
conda create -n qiime1 python=2.7 qiime matplotlib=1.4.3 mock nose -c bioconda  # Installs QIIME1 too for good measure 


elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then                      # Checks to see if running Linux and does the same things as above 
codename=$(lsb_release -c -s)                                                   # Checks which version of Ubuntu is being run
#deb https://www.stats.bris.ac.uk/R/bin/linux/ubuntu $codename/                  # Downloads appropriate version of R 
#sudo apt-get update 
#sudo apt-get install r-base 
#wget https://data.qiime2.org/distro/core/qiime2-2019.4-py35-linux-conda.yml
#conda env create -n qiime2-2019.4 --file qiime2-2019.4-py35-linux-conda.yml
#rm qiime2-2019.4-py35-linux-conda.yml
wget https://data.qiime2.org/distro/core/qiime2-2019.10-py36-linux-conda.yml
conda env create -n qiime2-2019.10 --file qiime2-2019.10-py36-linux-conda.yml
# OPTIONAL CLEANUP
rm qiime2-2019.10-py36-linux-conda.yml
conda create -n qiime1 python=2.7 qiime matplotlib=1.4.3 mock nose -c bioconda
fi 
#

#source activate qiime2-2019.10
conda activate qiime2-2019.10
jupyter serverextension enable --py qiime2 --sys-prefix
jupyter  notebook --ip=0.0.0.0


# Install Picrust2
#wget https://github.com/picrust/picrust2/releases/download/v2.0.3-b/picrust2-2.0.3-b.zip
#unzip picrust2-2.0.3-b.zip
#cd picrust2-2.0.3-b
wget https://github.com/picrust/picrust2/archive/v2.3.0-b.zip
unzip v2.3.0-b.zip
cd picrust2-2.3.0-b
conda-env update -n qiime2-2019.10 -f picrust2-env.yaml
pip install --editable .
pytest tests/test_hsp.py tests/test_metagenome_pipeline.py test/test_pathway_pipeline.py tests/test_util.py
cd ..

# Install the Picrust2 plugin for QIIME2 
#wget https://github.com/gavinmdouglas/q2-picrust2/releases/download/v0.0.2/q2-picrust2-0.0.2.zip
#unzip q2-picrust2-0.0.2.zip
#cd q2-picrust2-0.0.2
wget https://github.com/gavinmdouglas/q2-picrust2/archive/2019.7_0.zip
unzip 2019.7_0.zip
cd q2-picrust2-2019.7_0
python setup.py install
qiime dev refresh-cache
cd ..

# Tidy
#rm -r picrust2-2.0.3-b.zip
#rm -r q2-picrust2-0.0.2.zip
rm -r v2.3.0-b.zip
rm -r 2019.7_0.zip

# Install ITSXpress
conda install -c bioconda itsxpress
pip install q2-itsxpress
qiime dev refresh-cache
