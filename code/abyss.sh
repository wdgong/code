### author: David M Schruth
### date: 2013 April
### run on killdevil in bigmem queue with at least 90 GB 

source code/assemb.sh

for (( t=1; t<=6; t++ )); do
 for ((s=0; s<=${#stations}; s++)); do
   samp=Sample_${t}_${stations[$s]}; stat=${stations[$s]}
  if [[ $t -eq 5 ]] && [[ $s>1 ]] ; then
   samp=Sample_5_B; s=4;        stat=B; fi;
  tadir=$samp/trans-abyss-v$TRANSABYSS_VERSION/
  kmerdir=$tadir/assembly
  mkdir -p $kmerdir; pushd $kmerdir > /dev/null; echo $kmerdir

  #fastq_path=$(ls $dir/data/$samp/${t}_${stations[$s]}*_*_L00*_R1_001.fastq)
  #fastq_path=$(ls $dir/data/$samp/*${stations[$s]}*_L00*_R1_001.fastq)
  fastq_path=$(ls $dir/data/$samp/*$stat*_L00*_R1_001.fastq)
  fastq_pat=${fastq_path%%1_001.fastq}

  #r1=$dir/data/$samp/${t}_${stations[$s]}*_*_L00*_R1
  #r2=$dir/data/$samp/${t}_${stations[$s]}*_L00*_R2
  r1=${fastq_pat}1
  r2=${fastq_pat}2

  fq=fastq
  fq_ct=$(ls $dir/data/$samp/*.fastq | wc -l)
  fastq_strings="${r1}_001.$fq ${r2}_001.$fq"
  for ((i=2;i<=$fq_ct/2;i=i+1)); do
    id=$(printf "%03d" $i)
    fastq_strings="$fastq_strings ${r1}_${id}.$fq ${r2}_${id}.$fq"
  done

  mkdir ../reads_to_contigs                                             ## these three lines are a bit of a hack for
  echo $fastq_strings | sed s/" "/\\n/g  > ../reads_to_contigs/$samp.in ## manual creation of the fastq input file. 
  cp ../reads_to_contigs/$samp.in ../assembly/in                        ## currently used for the transabyss call

  for ((k=$kstart;k<=$kend;k=k+2)); do
    mkdir k$k;
    pushd k$k > /dev/null
    if [ ! -e "$samp-contigs.fa" ]       # Check if final contigs exist
    then
     rm $samp.$k.err; rm $samp.$k.out
     touch $k.started
    bsub -P $samp.$k -n1 -o $(pwd)/$samp.$k.out -e $(pwd)/$samp.$k.err -a openmpi -M 90 -q bigmem \
     exec abyss-pe E=0 n=5 v=-v k=$k name=$samp in="$fastq_strings" \
     OVERLAP_OPTIONS='--no-scaffold'  SIMPLEGRAPH_OPTIONS='--no-scaffold'  MERGEPATHS_OPTIONS='--greedy' mp=''
    fi
    popd > /dev/null
  done #end k-mer for-loop
  popd > /dev/null
 done # end geopoint for-loop
done # end timepoint for=loop

## after all these jobs finish, run transabyss.sh
