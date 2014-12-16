library(caroline)
library(RCurl)
library(XML)
for (t in 1:6) {
  if (t==5) stations <- c('020','070','B')  
  else   stations <- c('020','070','120','180')
  for (s in stations) {
    samp <- paste('Sample_',t,'_',s,sep='')
    tabs<-list.files(pattern=paste('tab.tid_lineage.out$'),path=samp)
    tab<-lapply(paste(samp,tabs,sep='/'),read.delim,comment.char='#',stringsAsFactors=F,header=F)
    taball<-do.call(rbind.data.frame,tab)
    tabbest<-bestBy(df=taball,best='V4',by='V1',sql=T)
    write.delim(tabbest,file=paste(samp,'.MarineRefII.best.hits.real.tab',sep=''))
    tabtid<-groupBy(df=tabbest,by='V17',clmns='V17',aggregation='length',sql=T)
    names(tabtid)<-'count'
    tabtid$V17<-rownames(tabtid)
    write.delim(tabtid,file=paste(samp,'.MarineRefII.xt.species.real.tab',sep=''))
    nr<-nrow(tabtid)
    for (i in 1:nr){
      myurl<-getURL(paste('http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&id=',tabtid$V17[i],'&retmode=xml',sep=''))
      doc<-xmlParse(myurl)
      mynode<-getNodeSet(doc,'//LineageEx/Taxon[Rank="class"]/ScientificName/text()')
      if (is.null(mynode)) {mynodes<-'no rank'
        tabtid$class[[i]]<-mynodes
      }else { mynodes<-as(mynode[[1]],'character')
       tabtid$class[[i]]<-mynodes[[1]]
       }
   }
   tabclass<-groupBy(tabtid,by='class',aggregation='sum',clmns='count',sql=T)
   names(tabclass)<-'count'
   tabclass$CLASS<-rownames(tabclass)
   write.delim(tabclass,file=paste(samp,'.MarineRefII.xt.class.real.tab',sep=''))
  }
}

