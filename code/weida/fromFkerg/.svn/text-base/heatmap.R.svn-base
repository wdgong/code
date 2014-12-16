#module add r

library(caroline)
library(gplots)
setwd('results')

#files = list.files()
#samp.dirs = files[grep('^MMETSP073[0-9]-phyloDB-merged.ctagg.tab$', files)]
#samp.ids = m("MMETSP0([0-9]+)", samp.dirs)
#samp.dirs = nv(samp.dirs, samp.ids)

#cts <- lapply(samp.ids, function(sid) nv(read.delim(samp.dirs[sid], stringsAsFactors=F), c('paired_aligned','kid')))
#names(cts) <- samp.ids

#ct.mtx.sm <- nerge(cts)
#ct.mtx.sm$sum <- apply(ct.mtx.sm, 1, sum, na.rm=TRUE)
#ct.mtx.sm <- ct.mtx.sm[order(ct.mtx.sm$sum, decreasing=T), ]
#write.delim(ct.mtx.sm, 'pDB.cts.kid-sm.tab', row.names=T)

#ct.mtx.bg <- nerge(cts, all=T)
#ct.mtx.bg$sum <- apply(ct.mtx.bg, 1, sum, na.rm=TRUE)
#ct.mtx.bg <- ct.mtx.bg[order(ct.mtx.bg$sum, decreasing=T), ]
#write.delim(ct.mtx.bg, 'pDB.cts.kid-bg.tab', row.names=T)

treats <- paste('73',c(3,5,6),sep='')
de.l <- lapply(treats, function(trt) nv(read.delim(paste(trt,'DE.gene.module.grouped.tab',sep='-'), stringsAsFactors=F), c('logFC_avg','mod_max')))
de.tab <- nerge(de.l)
names(de.tab) <- treats
rownames(de.tab) <- sub('md:','',rownames(de.tab))

write.delim(de.tab, file='heatmap.tab', row.names=TRUE)

png('heatmap.png', height=72*11, width=72*6)
heatmap.2(as.matrix(de.tab), lwid=c(.2,1), lhei=c(.15,1))
dev.off()

png('heatmap-legend.png', height=72*11, width=72*6)
heatmap.2(as.matrix(de.tab), lwid=c(.3,1), lhei=c(.3,1))
dev.off()


#png('heatmatrix.png', height=72*6, width=72*3)
#heatmatrix(as.matrix(de.tab))
#dev.off()





