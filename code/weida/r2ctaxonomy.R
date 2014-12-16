library(caroline)
library(XML)
library(RCurl)
for (i in 1:6){
  stations <- c('020','070','120','180')
  if (i==5) stations<-c('020','070','B')
  for (j in stations){
    samp<-paste("Sample_",i,"_",j,".MarineRefII.best.hits.real.tab",sep='')
    sample<-paste("Sample_",i,"_",j,sep='')
    tabbest<-read.delim(samp)
    tabbest<-tabbest[,c('V1','V17')]
    names(tabbest)<-c('qid','tid')
    path<-paste("/netscr/marchlab/projects/NeuseMetatx/results/assembly/",sample,"/trans-abyss-v1.4.4/reads_to_contigs/counts.tab",sep='')
    rawreads<-read.delim(path,sep='',header=F)
    names(rawreads)<-c('readcount','qid')
    tabmerge<-merge(tabbest,rawreads,by='qid')
    tabgroup<-groupBy(tabmerge,by='tid',clmns='readcount',aggregation='sum',sql=T)
    tabgroup$tid<-rownames(tabgroup)
    write.delim(tabgroup,file=paste(sample,'.MarineRefII.r2c.tab',sep=''))
    nr<-nrow(tabgroup)
    for (k in 1:nr){
      myurl<-getURL(paste('http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&id=',tabgroup$tid[k],'&retmode=xml',sep=''))
      doc<-xmlParse(myurl)
      mynode<-getNodeSet(doc,'//LineageEx/Taxon[Rank="class"]/ScientificName/text()')
      if (is.null(mynode)){mynode<-getNodeSet(doc,'//LineageEx/Taxon[Rank="phylum"]/ScientificName/text()')}
      if (is.null(mynode)){mynode<-getNodeSet(doc,'//LineageEx/Taxon[Rank="family"]/ScientificName/text()')}
      if (is.null(mynode)){mynode<-getNodeSet(doc,'//LineageEx/Taxon[Rank="kingdom"]/ScientificName/text()')}
      if (is.null(mynode)) { mynodes<-'no rank'
                             tabgroup$class[[k]]<-mynodes
      }else { mynodes<-as(mynode[[1]],'character')
              tabgroup$class[[k]]<-mynodes[[1]]
      } 
    }
    tabclass<-groupBy(tabgroup,by='class',aggregation='sum',clmns='readcount',sql=T)
    names(tabclass)<-'finalcount'
    tabclass$CLASS<-rownames(tabclass)
    write.delim(tabclass,file=paste(sample,'.MarineRefII.xt.class.withrawread.tab',sep=''))
    
  }
}

