#no Sample_2_070 because it is in a mess
setwd('..')
library(caroline)
kegg<-list.files(pattern='^Sample[_0-9B]*.KEGG.xt.gene.tab$')
kegg<-kegg[-6]
keggcombine<-lapply(kegg,function(keggfile){
print(keggfile)
doc<-read.delim(keggfile,sep=' ')})
keggmerge<-keggcombine[[1]]
for (i in 2:length(keggcombine)){
print (i)
keggmerge<-merge(keggmerge,keggcombine[[i]],by='gene')}
sums<-apply(keggmerge[2:ncol(keggmerge)],1,sum)
keggmerge<-keggmerge[rev(order(sums)),]
kegg<- list.files(pattern='^Sample[_0-9B]*$')
kegg<-kegg[-6]
names(keggmerge)<-c('gene',kegg)
write.delim(df=keggmerge,file="gene.read.ct.by.ts-KEGG.tab")

