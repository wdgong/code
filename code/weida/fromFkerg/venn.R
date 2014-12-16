library(caroline)
library(limma)
setwd('results')

treats <- c('733','735','736')
de.l <- lapply(treats, function(id) read.delim(paste('734.v.',id,'.ALL.tab',sep=''), stringsAsFactors=F))
names(de.l) <- treats

gene2ko <- read.delim('/nas02/data/KEGG/KEGG/genes/links/genes_ko.list', header=F, col.names=c('gene','ko'), stringsAsFactors=F)
#for(i in 1:2) gene2ko[,i] <- m(gene2ko[,i],'^.+:(.+)$')

ko <- system('pcregrep -M "ENTRY.+\nNAME.+\nDEFINITION.+" /nas02/data/KEGG/KEGG/genes/ko/ko', intern=T)
ko.df <- data.frame(ko  =m("^ENTRY\\s+(K[0-9]+)", ko[seq(1,length(ko), by=3)]),
                    name=m("^NAME\\s+(.+)"      , ko[seq(2,length(ko), by=3)]),
                    defn=m("^DEFINITION\\s+(.+)", ko[seq(3,length(ko), by=3)]),
                   stringsAsFactors=F)
rownames(ko.df) <- ko.df$ko

ko.df$ko <- paste('ko', ko.df$ko, sep=':')

add.ko.def <- function(tab){
  tmp  <- merge(x=tab, y=gene2ko, by.x=0, by.y='gene', all.x=TRUE) 
  names(tmp)[grep('Row.names',names(tmp))] <- 'gene' 
  tmp2 <- merge(x=tmp, y=ko.df, by.x='ko', all.x=TRUE)
  return(tmp2)
}

venn.all.tab <- vennMatrix(l=lapply(de.l, function(de) de$gene))
write.delim(add.ko.def(venn.all.tab), file='venn.gene.all.tab')#, row.names=T)
png('venn.gene.all.png'); vennDiagram(venn.all.tab); dev.off()


venn.up.tab <- vennMatrix(l=lapply(de.l, function(de) de[de$logFC>0 & de$PValue<.01, 'gene']))
write.delim(add.ko.def(venn.up.tab), file='venn.gene.DEup.tab')#, row.names=T)
png('venn.gene.DEup.png'); vennDiagram(venn.up.tab); dev.off()


venn.dn.tab <- vennMatrix(l=lapply(de.l, function(de) de[de$logFC<0 & de$PValue<.01, 'gene']))
write.delim(add.ko.def(venn.dn.tab), file='venn.gene.DEdn.tab')#, row.names=T)
png('venn.gene.DEdn.png'); vennDiagram(venn.dn.tab); dev.off()

