source code/load_sample_names.sh

pushd data
 echo "sample nfastas nseqs" > ../results/stats.agg-data.tab
 for (( t=1; t<=6; t++ )); do
  for ((s=0; s<=${#stations}; s++)); do
    samp=Sample_${t}_${stations[$s]};
   if [[ $t -eq 5 ]] && [[ $s>1 ]] ; then
    samp=Sample_5_B; s=4; fi;
    nfastas=$(ls -l $samp/*.fasta | wc -l)
    nseqs=$(grep "^>" $samp/*.fasta | wc -l)
    echo "$samp $nfastas $nseqs" >>  ../results/stats.agg-data.tab
  done
 done
popd


pushd results
 echo 'transcript counts'
 echo "sample nfiles nfseqs nqueries" > assembly/stats.agg-assemb.tab
 for (( t=1; t<=6; t++ )); do
  for ((s=0; s<=${#stations}; s++)); do
    samp=Sample_${t}_${stations[$s]};
   if [[ $t -eq 5 ]] && [[ $s>1 ]] ; then
    samp=Sample_5_B; s=4; fi;
   nfiles=$(ls -l assembly/$samp/trans-abyss-v1.4.4/merge/frag* | wc -l)
   nseqs=$(grep "^>" assembly/$samp/trans-abyss-v1.4.4/merge/frag* | wc -l)
   nseqs2=$(grep "^>" assembly/$samp/trans-abyss-v1.4.4/merge/*contigs.fa | wc -l)
   echo "$samp $nfiles $nseqs $nseqs2" >>  assembly/stats.agg-assemb.tab
  done
 done


 echo 'blast results'
targets=(nr KEGG)
for tg in ${targets[@]}; do
 echo "sample nfiles nhits nqueries pcthit" > blast_ta_contigs/stats.agg-blast.$tg.tab
 for (( t=1; t<=6; t++ )); do
  for ((s=0; s<=${#stations}; s++)); do
    samp=Sample_${t}_${stations[$s]};
   if [[ $t -eq 5 ]] && [[ $s>1 ]] ; then
    samp=Sample_5_B; s=4; fi;
   nfiles=$(ls -l    blast_ta_contigs/$samp/*$tg*tab | wc -l)
   nqueries=$(grep BLAST blast_ta_contigs/$samp/*$tg*tab | wc -l)
   nhits=$(cat  blast_ta_contigs/$samp.$tg.best.hits.tab | wc -l)
   let pcthit="(( ($nhits * 100) / $nqueries ))"
   echo "$samp $nfiles $nhits $nqueries $pcthit" >> blast_ta_contigs/stats.agg-blast.$tg.tab
  done
 done
done
popd


