#module add r
library(caroline)
setwd('results')
source('/proj/marchlab/src/metapathmapR/R/module.R')


gene2ko <- read.delim('/nas02/data/KEGG/KEGG/genes/links/genes_ko.list', header=F, col.names=c('gene','ko'), stringsAsFactors=F)
ko2mod <- read.delim('/nas02/data/KEGG/KEGG/genes/ko/ko_module.list', header=F, col.names=c('ko','mod'), stringsAsFactors=F)

modef.txt <- system('pcregrep -M "ENTRY.+\nNAME.+\nDEFINITION.+" /nas02/data/KEGG/KEGG/module/module', intern=T)
modef <- data.frame(mod =m("^ENTRY\\s+(M[0-9]+)\\s", modef.txt[seq(1,length(modef.txt), by=3)]),
                    name=m("^NAME\\s+(.+)\\s"        , modef.txt[seq(2,length(modef.txt), by=3)]),
                    def =m("^DEFINITION\\s+(.+)$"  , modef.txt[seq(3,length(modef.txt), by=3)]),
	           stringsAsFactors=F)

modef <- subset(modef, !is.na(mod) & !grepl('M00438',modef$def))  # from 218K to just 590 modules!
modef$mod <- rownames(modef) <- paste('md',modef$mod,sep=':')

mod.cols <- nv(read.csv('../data/module.cats.csv', stringsAsFactors=F), c('col','mod.id'))
names(mod.cols) <- paste('md',names(mod.cols),sep=':')

#modef <- nerge(list(modef, mod.cols))

treats <- c('733','735','736')
de.l <- lapply(treats, function(id) read.delim(paste('734.v.',id,'.ALL.tab',sep=''), stringsAsFactors=F))
names(de.l) <- treats

for(treat in treats){
 print(treat)

 de.g <-  merge(x=de.l[[treat]][,c('gene','logFC','logCPM','PValue')], y=gene2ko)
 de.g.m <- merge(de.g, ko2mod)

 de.g.m.def <- merge(de.g.m, modef)
 write.delim(de.g.m.def, file=paste(treat,'DE.gene.module.tab',sep='-'))

 print('grouping')
 mean.mn.mx <- c('mean','min','max')
 de.g.m.grpd <- groupBy(de.g.m, by='mod', clmns=c("mod", rep("logFC",3), rep('logCPM',3), rep("PValue",3),    "mod",    "ko"), 
                             sql=T, aggregation=c("max",     mean.mn.mx,       mean.mn.mx,      mean.mn.mx, "length", "paste"))

 de.g.m.grpd$ko_paste <- gsub('ko:','', de.g.m.grpd$ko_paste)
 de.g.m.grpd$pcts <-  sapply(rownames(de.g.m.grpd), function(mod)  moddefExpress(mod.def=modef[mod,'def'], 
                                                                                     KOs=strsplit(de.g.m.grpd[mod,'ko_paste'],',')[[1]] ,verbose=F))

 print('module name merge')
 de.g.m.grpd.def <- merge(de.g.m.grpd, modef, by.x='mod_max', by.y='mod')
 #rownames(de.g.m.grpd.def) <- sub('md:','',de.g.m.grpd.def$mod_max)
  rownames(de.g.m.grpd.def) <- de.g.m.grpd.def$mod_max
 de.g.m.grpd.def <- nerge(list(de=de.g.m.grpd.def, color=mod.cols))

 de.g.m.grpd.def <- de.g.m.grpd.def[order(de.g.m.grpd.def$PValue_avg),]
 write.delim(de.g.m.grpd.def, file=paste(treat,'DE.gene.module.grouped.tab',sep='-'))

}

