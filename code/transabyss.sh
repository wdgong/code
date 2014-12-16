## author: David M Schruth
### date: 2013 April
### run on killdevil in bigmem queue with at least 120 GB 

source code/assemb.sh

module add transabyss/1.4.4

##  RUN THIS NEXT SECTION ONLY AFTER THE abyss.sh CODE HASE FULLY and SUCCESSFULLY RUN

for (( t=1; t<=6; t++ )); do
 for ((s=0; s<=${#stations}; s++)); do
   samp=Sample_${t}_${stations[$s]}
  if [[ $t -eq 5 ]] && [[ $s>1 ]] ; then
   samp=Sample_5_B; s=4; fi;
  tadir=$samp/trans-abyss-v$TRANSABYSS_VERSION/
  pushd $tadir > /dev/null; echo $tadir

  ncontigfiles=$(ls assembly/k*/*contigs.fa | wc -l)
  if (( $ncontigfiles == $ks ))
  then
   if [ ! -e "merge/$samp-contigs.fa" ] || [ ! -e reads_to_contigs/*fastq.sorted.bam.bai ]; 
   then
    echo $samp
    ## trans abyss phase "0" (merge) and "r" (align to contigs)
    bsub -P $samp.ta -n1 -o $(pwd)/$samp.ta.out -e $(pwd)/$samp.ta.err -M 512 -q bigmem \
    $TRANSABYSS_PATH/wrappers/trans-abyss.py -0r \
     --project=Neuse \
     --topdir=$dir/results/assembly \
     --assembly_dir $dir/results/assembly \
     --library=$samp \
     --readlength=100 \
     --run_transcriptome \
     --local
   fi
  fi
  popd > /dev/null
 done # end geopoint for-loop
done # end timepoint for-loop

popd > /dev/null
popd > /dev/null


