#taxa pies
# module add r/3.0.1
setwd('/proj/marchlab/projects/NeuseMetatx/')
library(caroline)

path <- 'results/blast_ta_contigs/'
samples <- list.files(pattern='^Sample[_0-9B]*$',path=path, )
setwd(path)

lo <- matrix(1:(length(samples)+1), ncol=4, nrow=6, byrow=T)
lo[5,4] <- 19
lo[6,] <- 20:23


annot.dbs <- c('mR','nr')
for(db in annot.dbs){
  tax.nv <- lapply(samples, function(samp) {
		print(samp)
                  v <- nv(read.delim(paste(samp,'.',db,'.xt.species.tab',sep='')),c('count','species'))
                  v[!is.na(names(v)) & names(v)!=' ']
  })  #sample 1 180 and 4 120 are still messed up with un matching double quotes... can't seem to find it.

  tax <- nerge(tax.nv, all=TRUE) 

  names(tax)<- samples
  sums <- apply(tax, 1, sum, na.rm=TRUE)
  tax <- tax[rev(order(sums)),]

 #tax <- tax[,grep("Sample_5",names(tax))]

  write.delim(tax, file=paste('species.read.ct.by.station-',db,'.tab',sep=''))
  tax[is.na(tax)] <- 0

  tax_top <- leghead(tax,n=7)

  png(paste('species.read.ct.by.station-',db,'.png',sep=''), width=72*8, height=72*12)
  layout(lo)
  par(mar=rep(0,4))
  for(samp in samples){
   print(samp)
   pie(as.integer(tax_top[,samp]), col=tax_top$color, lables=NULL)
  }
  dev.off()

}


