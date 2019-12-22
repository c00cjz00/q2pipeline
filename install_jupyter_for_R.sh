
#conda install -c r r-essentials
sudo ln -s /bin/gzip /usr/bin/gzip
sudo ln -s /bin/tar /bin/gtar 
sudo apt install libxt6
sudo apt-get install libcurl4-openssl-dev libssl-dev
in R
install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'))
devtools::install_github('IRkernel/IRkernel')
# 只在當前使用者下安裝
IRkernel::installspec()
# 或者是在系統下安裝
IRkernel::installspec(user = FALSE)



------------------------------------------------------
apt install r-base

# example https://www.digitalocean.com/community/tutorials/how-to-install-r-packages-using-devtools-on-ubuntu-16-04
# sudo apt-get install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev
# sudo -i R
# install.packages('devtools')
# sudo apt-get install -y r-cran-latticeextra

pip3 install –upgrade pip
sudo apt-get install libzmq3-dev libcurl4 libcurl4-openssl-dev
sudo apt-get install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev

conda install -c r r-essentials

in R
install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'))
devtools::install_github('IRkernel/IRkernel')
# 只在當前使用者下安裝
IRkernel::installspec()
# 或者是在系統下安裝
IRkernel::installspec(user = FALSE)
