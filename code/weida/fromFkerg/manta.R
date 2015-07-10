# module add r/2.15.1
# install.packages('caroline') # CRAN install
# biocLite('http://bioconductor.org/biocLite.R')
# biocLite('edgeR') # bioconductor installs
# biocLite('manta') # bioconductor installs

library('caroline')
library('manta')
library('edgeR')

getfinm <- function(id) paste('MMETSP0',id,'-phyloDB-merged.ctagg.tab',sep='')
cmb.list <- lapply(c(733,735,736), function(id) append(getfinm(734), getfinm(id)))


for(finm.pair in cmb.list){
  
  nm.pair <- m(pattern='MMETSP0([0-9]+)-phyloDB',finm.pair)
  ofinmbase <- paste('results',paste(nm.pair, collapse='.v.'),sep='/')
  print(nm.pair)

  df.pair <- lapply(finm.pair, function(t)       read.delim(paste('results/',t,sep=''), row.names=1)      )

  names(df.pair) <- nm.pair
  cts.mrgd <- nerge(df.pair)
  cts.mrgd <- cts.mrgd[,c(paste('paired_aligned',nm.pair, sep='.'), paste('desc',nm.pair[1],sep='.'))]
  names(cts.mrgd) <- sub(paste('.',nm.pair[1],sep=''),'',sub('paired_aligned\\.','',names(cts.mrgd)))

  dge<-DGEList(cts.mrgd[,c(1,2)])
  dge$samples$group <- factor(nm.pair, levels=nm.pair)
  #dge <- estimateCommonDisp(dge)
  disp <- dispCoxReid(dge); print(disp)
  dge$common.dispersion <-  disp #.2  
  test <- exactTest(dge)

  cts.mrgd$gene <- rownames(cts.mrgd)
  out <- nerge(list(cts.mrgd, test$table))

  is.sig.col <- out$PValue < .01
  is.sig.txt <- out$PValue < .00001

  write.delim(out, paste(ofinmbase,'ALL.tab',sep='.'))

  out.sig <- subset(out, is.sig.col)
  out.sig.sub <- out.sig[order(out.sig$logFC),]

  png(paste(ofinmbase,'RA.png',sep='-'))
  raPlot(out[,nm.pair], border=c('black','red')[is.sig.col + 1])
  text(out[is.sig.txt ,c('logCPM','logFC')], out[is.sig.txt, 'gene'], pos=4)
  dev.off()

  write.delim(out.sig, paste(ofinmbase,'tab',sep='.'))
}
