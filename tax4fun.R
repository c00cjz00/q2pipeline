#!/usr/bin/env Rscript

# A script that will hopefully automate Tax4Fun 


library(Tax4Fun)
getwd()

files = c("useful/closed/feature-table-tax4fun.txt")
QIIMEData = importQIIMEData(files)

pathReferenceData = "../classifiers/tax4fun/SILVA119"

Tax4FunOutput <- Tax4Fun(QIIMEData,pathReferenceData, fctProfiling = TRUE, refProfile = "UProC", shortReadMode = TRUE, normCopyNo = TRUE)

Tax4FunProfile <- data.frame(t(Tax4FunOutput$Tax4FunProfile))

write.table(Tax4FunProfile,"useful/tax4fun/Tax4FunProfile_Export.csv",sep="\t")
