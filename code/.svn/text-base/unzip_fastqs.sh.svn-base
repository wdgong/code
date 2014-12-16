## NOTE: you may want to be using "screen" before running any/all of this code!  Don't let your unzipping processes get interrupted!
source code/load_sample_names.sh
pushd data

## unzip gz files

echo "Unzipping Fastqs"  # sample_times
for (( t=1; t<=6; t++ )); do   
 for (( s=0; s<4; s++ )) ; do
   sampsubdir=Sample_${t}_${stations[$s]}
  if [[ $t -eq 5 ]] && [[ $s>1 ]] ; then  
   sampsubdir=Sample_5_B; s=4; fi; 
  for f in $(ls $sampsubdir/*.fastq.gz); do   
    if [ ! -e "${f%.gz}" ]
     then
      zcat $f > ${f%.gz}
    fi
  done
 done
done

#now Rsync these over to netscr so you can use killdevil to assemble (run inside screen!)
rsync -pPruvato /proj/marchlab/projects/NeuseMetatx/code/  /netscr/marchlab/projects/NeuseMetatx/code/
rsync -pPruvato /proj/marchlab/projects/NeuseMetatx/data/  /netscr/marchlab/projects/NeuseMetatx/data/


echo "Converting fastq files to fasta format"
for (( t=1; t<=6; t++ )); do
 for (( s=0; s<4; s++ )) ; do
   sampsubdir=Sample_${t}_${stations[$s]}
  if [[ $t -eq 5 ]] && [[ $s>1 ]] ; then
   sampsubdir=Sample_5_B; s=4; fi;
  pushd $sampsubdir
  echo $sampsubdir
  for i in $(ls *.fastq); do 
    if [ ! -e "${i%q}a" ]
    then
      awk '/^@(UNC|D7T4KXP1|HWI)/{gsub(/^@/,">",$1);print;getline;print}' $i > "${i%q}a"
    fi
  done
  popd
 done
done

popd



