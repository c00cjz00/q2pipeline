#!/usr/bin/env Rscript
# Peter Leary 
# A script that will hopefully automate Tax4Fun 

# Load the Tax4Fun program
library(Tax4Fun)
# Point to the ASV table. This is the one that was extracted from table.qza to get the BIOM file, had metadata added from taxonomy.qza, was converted to txt, and then sed'd to remove SILVA's D_0__ stuff
files = c("useful/closed/feature-table-tax4fun.txt")
# Point the file for the Tax4Fun command 
QIIMEData = importQIIMEData(files)
# Point to the SILVA119 precomputed files 
pathReferenceData = "../classifiers/tax4fun/SILVA119"
# The magic command for Tax4Fun 
Tax4FunOutput <- Tax4Fun(QIIMEData,pathReferenceData, fctProfiling = TRUE, refProfile = "UProC", shortReadMode = TRUE, normCopyNo = TRUE)
# Make the output a data frame 
Tax4FunProfile <- data.frame(t(Tax4FunOutput$Tax4FunProfile))
# Write the table to file 
write.table(Tax4FunProfile,"useful/tax4fun/Tax4FunProfile_Export.csv",sep="\t")
