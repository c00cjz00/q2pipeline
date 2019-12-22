conda install -c r r-essentials

in R
install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'))
devtools::install_github('IRkernel/IRkernel')
# 只在當前使用者下安裝
IRkernel::installspec()
# 或者是在系統下安裝
IRkernel::installspec(user = FALSE)
