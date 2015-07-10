#run from Fkerg directory
#module add r

library(caroline)
dt.dir <- 'data/'

files = list.files(dt.dir)
samp.dirs = files[grep('^MMETSP073[0-9]-[^\\.]+$', files)]
samp.ids = m("^(.+)-[0-9]+$", samp.dirs)
samp.dirs = nv(samp.dirs, samp.ids)
phyloDB.dirs = nv(paste(samp.ids, 'phyloDB_ann',sep='_'), samp.ids)

for(samp.id in samp.ids){
 print(samp.id)
 counts <- read.delim(paste(dt.dir, samp.dirs[samp.id], '/readcounts/cds.dat', sep=''),row.names=1, stringsAsFactors=F)
 annot <- read.delim(paste(dt.dir, phyloDB.dirs[samp.id],'/',samp.id,'_kegg.txt', sep=''), 
                      header=F,  comment.char='#', stringsAsFactors=F)

 annot <- annot[,names(annot)[c(1,3,4,12,14,15)]]
 names(annot) <- c('id','kid','score','evalue','desc','taxid') #'gids',
 rownames(annot) <- annot$id

 annot$kid <- m(annot$kid, pattern="\\|([a-z]+:[A-Za-z0-9_\\.-]+)$")
 ca <- nerge(list(ctg=counts, ag=annot))
 ca.g <- groupBy(ca, by='kid',aggregation=c('sum','max','paste'), clmns=c('paired_aligned','kid','desc'), distinct=TRUE)
	
 write.delim(ca, paste('results/',samp.id,'-phyloDB-merged.tab',sep=''), row.names=TRUE)
 write.delim(ca.g, paste('results/',samp.id,'-phyloDB-merged.ctagg.tab',sep=''), row.names=TRUE)


## add modules too


}
