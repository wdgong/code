#module add r
library(caroline)
setwd('results')
source('/proj/marchlab/src/metapathmapR/R/module.R')


gene2ko <- read.delim('/nas02/data/KEGG/KEGG/genes/links/genes_ko.list', header=F, col.names=c('gene','ko'), stringsAsFactors=F)
ko2mod <- read.delim('/nas02/data/KEGG/KEGG/genes/ko/ko_module.list', header=F, col.names=c('ko','mod'), stringsAsFactors=F)

modef.ndf <- system('pcregrep -M "ENTRY.+\nNAME.+\nDEFINITION.+" /nas02/data/KEGG/KEGG/module/module', intern=T)
modef.cls <- system('grep -P "^[A-Z]" /nas02/data/KEGG/KEGG/module/module | grep -P  "(ENTRY|CLASS)" | pcregrep -M "ENTRY.+\nCLASS"', intern=T)


modef.nd <- data.frame(mod =m("^ENTRY\\s+(M[0-9]+)", modef.ndf[seq(1,length(modef.ndf), by=3)]),
                    name=m("^NAME\\s+(.+)"        , modef.ndf[seq(2,length(modef.ndf), by=3)]),
                    def =m("^DEFINITION\\s+(.+)$"  , modef.ndf[seq(3,length(modef.ndf), by=3)]),
	           stringsAsFactors=F)
modef.nd <- subset(modef.nd, !is.na(mod))
 
modef.c <- data.frame(mod =m("^ENTRY\\s+(M[0-9]+)", grep('ENTRY',modef.cls, value=T)),
                     clas1=m("^CLASS\\s+(.+); .+; .+$"       , grep('CLASS',modef.cls, value=T)),
                     clas2=m("^CLASS\\s+.+; (.+); .+$"       , grep('CLASS',modef.cls, value=T)),
                     clas3=m("^CLASS\\s+.+; .+; (.+)$"       , grep('CLASS',modef.cls, value=T)),
                   stringsAsFactors=F)
modef.c <- subset(modef.c, !is.na(mod))

modef <- merge(x=modef.nd, y=modef.c, on='mod', all.x=TRUE)

#mod.cols <- nv(read.csv('../data/module.cats.csv', stringsAsFactors=F), c('col','mod.id'))
#names(mod.cols) <- paste('md',names(mod.cols),sep=':')
mod.cols <- read.csv('../data/KEGG.module.class.colors.csv', stringsAsFactors=F, comment.char=';')
modef <- merge(modef, mod.cols, all.x=T, by.x='clas3', by.y='name')

modef <- subset(modef, !grepl('M00438',modef$def))  # HACK around "Error in (('K02575' %in% KOs)) | (M00438) : object 'M00438'" 
modef$mod <- rownames(modef) <- paste('md',modef$mod,sep=':')


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
# rownames(de.g.m.grpd.def) <- de.g.m.grpd.def$mod_max
# de.g.m.grpd.def <- nerge(list(de=de.g.m.grpd.def, color=mod.cols)) #handled above now

 de.g.m.grpd.def <- de.g.m.grpd.def[order(de.g.m.grpd.def$PValue_avg),]
 write.delim(de.g.m.grpd.def, file=paste(treat,'DE.gene.module.grouped.tab',sep='-'))

}

