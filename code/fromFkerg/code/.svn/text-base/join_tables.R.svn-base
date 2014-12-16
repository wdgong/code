library(caroline)
dt.dir <- '../data/'

files <- list.files(dt.dir)
samp.dirs <- files[grep('^MMETSP073[0-9]-[^\\.]+$', files)]


for(samp in samp.dirs){

 cntgs <- read.delim(paste(dt.dir, samp, '/readcounts/contigs.dat', sep=''),row.names=1)
 annot <- read.delim(paste(dt.dir, samp, '/annot/pfam.gff3', sep=''), header=F, comment.char='#')

 toss <- paste('V',c(2,3,4,5,7,8),sep='')
 annot<- annot[,!names(annot) %in% toss]
 names(annot) <- c('id','evalue','desc')
 annot.grpd <- groupBy(annot, by='id', clmns=c('evalue','desc'), aggregation='paste')
 annot.grpd <- annot.grpd[ sapply(rownames(annot.grpd), function(x) strsplit(x, '_')[[1]][2]) !='2',]
 rownames(annot.grpd) <- sapply(rownames(annot.grpd), function(x) strsplit(x, '_')[[1]][1])

 ca <- nerge(list(ctg=cntgs, ag=annot.grpd))

 write.delim(ca, paste(samp,'-merged.tab',sep=''), row.names=TRUE)

}
