## pathway module level analysis
setwd('results')
source('/proj/marchlab/src/KEGG.module.colors.R')
library(caroline)

#for(path.cat in path.cats)
#  modef$col[modef$name==path.cat] <- path.cols[path.cat]
path.cols <- c(path.cols, nv(gray(.6),'other'))


treats <- c('733','735','736')
for(treat in treats){

  print(treat)
  p <- read.delim(paste(treat,'DE.gene.module.grouped.tab',sep='-'), stringsAsFactors=F)
  p <- rbind.data.frame(p[p$color=='gray',],p[p$color!='gray',]) #gray on bottom
  
  png(paste(treat,'DE.module.RA.png',sep='-'))
  cex <- .7   
  with(p, plot(logCPM_avg, logFC_avg, bg=hex, #color, 
                                 col=gray(.6), cex=pcts*4, 
                                 main='Modules', pch=21, log='x',
                                 ylab='Avg (mod) Fold Change [avg(R.adj)]', 
                                 xlab='Log Sum (mod) of Avg (lib) Log Read Count [log(sum(A))]'))
      
  abline(h=0, col=gray(.9))

  dev.off()
  print(head(p[rev(order(p$logFC_avg)),c('logFC_avg','pcts','color','name')]))
}

png('module.class.legend.png', height=72*11.5, width=72*6)
par(mar=rep(0,4))
plot(0,0)
with(mod.cols, legend(legend=name, pt.bg=hex,col='gray', pch=21, x='topleft'))
dev.off()


































###############
### FIGURES ###
##############

setwd(paste(project.checkout.path, 'paper/figures/',sep=''))

par(family='ariel')  #don't know if this is actually necessary or if it needs to be set within 'tiff' anyway
dev.off()

conditions <- nv(factor(x=1:2, labels=c('ambient','plusFe')), c('ref','obs'))

A.axlab <- expression(paste("A :  ",frac(paste(log[2],"(plusFe) + ",log[2],"(ambient)",sep=''),2)))
R.axlab <- expression(paste("R :   ",log[2],"(plusFe / ambient)"))

unsig.gray <- gray(.80)
## manta
manta.xlim <- c(-.5,15.3)


km.name <- 'DiatomKeggModules'
km.dir <- paste('3-',km.name,'/',sep='')

if(!file.exists(km.dir))
  dir.create(km.dir)

anoteTF <- nv(c(F,T),c('-noAnnot',''))

km.labs <- nv(toupper(letters[1:length(key.phyla)]),key.phyla)

for(anote in anoteTF){

tiff(paste(km.dir, km.name, names(anoteTF)[anote+1], '.tiff',sep=''), height=HEIGHT.MAX*1/2, width=WIDTH.ONE.COL, units='in', res=MIN.RES, pointsize=12, compression='lzw')

#par(mfcol=c(2,2))
par(mar=c(.1,1.3,.1,.1))
#for(this.phyla in key.phyla){
#  print(this.phyla)
m.e.df <- read.csv(paste(pathways.dir, 'modules', paste('pathway.module-expression-','diatoms','.csv',sep=''),sep='/'), stringsAsFactors=FALSE)
m.e.df <- subset(m.e.df, !grepl('(, prokaryotes|, bacteria)', name))
  
with(m.e.df, plot(A, R, pch='', log='x', xlim=c(1,300), ylim=c(-6.5,3.7),xaxt='n', yaxt='n', bty='l', axes=F))
abline(h=0, col=gray(.9))
with(m.e.df, points(A, R, bg=col, col=gray(.6), cex=pct*2.5, pch=21))
  
axis(side=1,  line=-8.2,  tck=-.01, cex=.6, cex.axis=.8, mgp=c(2,.05,0))#, padj=4)
axis(side=2,  at=seq(-2,4,by=2),tck=-.01,  cex=.6, cex.axis=.8, las=1, mgp=c(2,.3,0))#, hadj=2.5,) 
mtext('sum(A)', side=1, cex=.7, line=-7.5)#, line=-1.7)
mtext('avg(R)', side=2, cex=.7, line=.7, at=1)#, line=-2) #"(",frac('plusFe','ambient'),")"

if(anote){
  #with(subset(m.e.df, col!='gray')                      , text(A, R, abrv, col=gray(.3), cex=.7))
  with(subset(m.e.df, amino_acid | nitrogen_assimilation), text(A, R, abrv, col='black', cex=.6))  
}

path.cols3 <- path.cols[!names(path.cols) %in% 'polyamine']
legend('bottom',  fill=path.cols3, border='gray', cex=.6, legend=sub('_',' ',names(path.cols3)), inset=.01, ncol=2)

dev.off()

}
