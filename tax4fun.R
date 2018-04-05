#!/usr/bin/env Rscript

# A script that will hopefully automate Tax4Fun 

cat(R.version$version.string, "\n")
args <- commandArgs(TRUE)

library(Tax4Fun)
setwd("/")

files = c("$name/useful/closed/feature-table-tax4fun.txt")
QIIMEData = importQIIMEData(files)

pathReferenceData = "classifiers/tax4fun/SILVA119"

Tax4FunOutput <- Tax4Fun(QIIMEData,pathReferenceData, fctProfiling = TRUE, refProfile = "UProC", shortReadMode = TRUE, normCopyNo = TRUE)

Tax4FunProfile <- data.frame(t(Tax4FunOutput$Tax4FunProfile))

write.table(Tax4FunProfile,"$name/useful/tax4fun/Tax4FunProfile_Export.csv",sep="\t")
