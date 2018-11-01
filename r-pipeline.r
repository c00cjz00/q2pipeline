#!/usr/bin/env Rscript

# Import the args 
args = commandArgs(TRUE)
project = args[1]
columns = args[2]
sample = args[3]
map.f = args[4]
SVs.f = args[5]
tax.f = args[6]
tree.f = args[7]
shannon.f = args[8]
pco.f = args[9]
bray.f = args[10]
faith_pd.f = args[11]
pielou_e.f = args[12]
pco_w.f = args[13]
otu.f = args[14]
col2 = args[15]
wd = args[16]
taxa2 = args[17]

# Import the map files 
meta = read.csv(map.f, header = TRUE, stringsAsFactors = FALSE, sep = "\t", row.names = 1)

# Extract columns from map file as selected by the user
col4 = meta[[columns]]
col5 = meta[[col2]]
col6 = meta[[sample]]

# Load libraries 
library(tidyverse)
library(qiime2R)
library(MicrobeR)
library(plotly)
library(htmlwidgets)
library(vegan)

# Import QZAs using qiime2R
metadata=read_tsv(map.f)
metadata
SVs=read_qza(SVs.f)
taxonomy=read_qza(tax.f)
tree=read_qza(tree.f)
shannon=read_qza(shannon.f)
pco=read_qza(pco.f)
bray=read_qza(bray.f)
faith_pd=read_qza(faith_pd.f)
pielou_e=read_qza(pielou_e.f)
pco_w=read_qza(pco_w.f)

# Import OTU table and transpose 
otu = read.csv(otu.f, header = TRUE, stringsAsFactors = FALSE, sep = "\t", row.names = 1, skip = 1)
otu1 = as.data.frame(otu)
otut = t(otu1)

# Set some colours and points 
col = c("lightseagreen","indianred1","lightgreen","mediumpurple","yellow","orange","black")
sp = c(21,22,23,24)
pchg = c(16,17,18,15,14,19,20,21)

taxa=read.csv(taxa2, header = TRUE, stringsAsFactors = FALSE, sep="\t", row.names = 1)

setwd(wd)

# nMDS 
nmds = metaMDS(otut, k = 2, try = 10)
pdf("stress.pdf", width = 7, height = 7)
stressplot(nmds)
dev.off()

f_hel = decostand(otut,method="hellinger")
f_bc = vegdist(f_hel, method = "bray")
f_clu = hclust(f_bc, method = "average")
f_grp = cutree(f_clu, 5)

pdf("nmds.pdf", width = 7, height = 7)
plot(nmds, type = "n", display = "sites")
points(nmds, col = col[col4],bg=col[col4], pch = pchg[col5], cex = 1)
#legend("topleft", legend = paste("Sampling Group", 1:4), col = col, pt.bg = col, bty = "n", pch = 21)
ordiellipse(nmds, groups = f_grp, display = "sites",col = "red")
orditorp(nmds,display = "sites", air = 0.1, cex = 0.8, pos = 2, labels = col6)
dev.off()

# DCA 
ord = decorana(otut)
pdf("dca.pdf", width = 7, height = 7)
plot(ord, type = "n", display = "sites")
points(ord, col = col[col4],bg=col[col4], pch = pchg[col5], cex = 1)
orditorp(ord,display = "sites", air = 0.1, cex = 0.8, pos = 2, labels = col6)
ordiellipse(ord, groups = f_grp, display = "sites",col = "red")
dev.off()

# Alpha Diversity Box Plots 
# Shannon
pdf("shannon.pdf")
boxplot(shannon$data$shannon ~ col4, range = 1, xlab = "Sample Group", ylab = "Shannon Diversity", col = c("lightseagreen","indianred1","lightgreen","mediumpurple","yellow","orange","black"))
dev.off()

# Faith
pdf("faith.pdf")
boxplot(faith_pd$data$faith_pd ~ col4, range = 1, xlab = "Sample Group", ylab = "Shannon Diversity", col = c("lightseagreen","indianred1","lightgreen","mediumpurple","yellow","orange","black"))
dev.off()

# Pielou
pdf("pielou.pdf")
boxplot(pielou_e$data$pielou_e ~ col4, range = 1, xlab = "Sample Group", ylab = "Shannon Diversity", col = c("lightseagreen","indianred1","lightgreen","mediumpurple","yellow","orange","black"))
dev.off()

# MicrobeR stuff 

conf.table2=Confidence.Filter(SVs$data,1,25)
summarized.taxa2=Summarize.Taxa(FEATURES = conf.table2, TAXONOMY = taxa)
print(paste0("We have ", nrow(summarized.taxa2$Genus), " genera in dataset."))

bar = ggplotly(Microbiome.Barplot(FEATURES = summarized.taxa2$Genus, METADATA = meta))
htmlwidgets::saveWidget(widget = bar, "barplots.html")

heat = ggplotly(Microbiome.Heatmap(FEATURES=summarized.taxa2$Genus, METADATA=meta, NTOPFEATURES = 30, ROWCLUSTER = "abundance"))
htmlwidgets::saveWidget(widget = heat, file = 'heat.html')