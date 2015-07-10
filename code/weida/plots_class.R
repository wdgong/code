library(caroline)
samples <- list.files(pattern='^Sample[_0-9B].*MarineRefII.xt.class.real.tab$')
lo <- matrix(1:(length(samples)+1), ncol=4, nrow=6, byrow=T)
lo[5,4] <- 19
lo[6,] <- 20:23
taxmerge<-lapply(samples,function(samp){
print(samp)
doc<-read.delim(samp,na.strings='no rank')
doc<-doc[!is.na(doc$CLASS),]})
tax<-taxmerge[[1]]
for (i in 2:length(taxmerge)){
tax<-merge(tax,taxmerge[[i]],by='CLASS')}
samp<-list.files(pattern='^Sample[_0-9B]*$')
names(tax)<-c('CLASS',samp)
sums <- apply(tax[2:ncol(tax)], 1, sum)
tax <- tax[rev(order(sums)),]
write.delim(tax, file=paste('species.read.ct.by.station-MarineRefII.tab',sep=''))
i<-sapply(tax,is.factor)
tax[i]<-lapply(tax[i],as.character)
tax_top<-leghead(tax[,2:length(tax)],n=7)
png(paste('species.read.ct.by.station-MarineRefII.png',sep=''), width=72*8, height=72*12)
layout(lo)
par(mar=rep(0,4))
for (sample in samp) {
print(sample)
pie(as.integer(tax_top[,sample]), col=tax_top$color)
}
dev.off
