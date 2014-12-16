#stats assemb
# module add r/3.0.1
setwd('/proj/marchlab/projects/NeuseMetatx/')
library(seqinr)
library(caroline)
path='results/assembly/'
samples <- list.files(pattern='^Sample[_0-9B]*$',path=path)

f.summaries.tab <- matrix(numeric(), nrow=length(samples), ncol=8,
                                   dimnames=list(samples,c('seqct','min','1Q','median','mean','3Q','max','N50')))

for (samp in samples){
 message(samp)

 f <- read.fasta(paste(path,samp,'/trans-abyss-v1.4.4/merge/',samp,'-contigs.fa',sep=''))
 f.lengths <- sapply(f, length)
 f.seqct <- length(f)

 f.len.sum <- summary(f.lengths)
 f.N50 <- median(rep(f.lengths, f.lengths))
 f.summaries.tab[samp,] <- c(f.seqct,f.len.sum, f.N50)

 sink(paste(path,samp,'-contig.length-stem+leaf.txt',sep=''))
 stem(f.lengths)
 sink()
}

write.delim(f.summaries.tab, file=paste(path,'stats-contig.length.dists.tab',sep=''),row.names=TRUE)

