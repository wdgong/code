## TO BE RUN ON KURE (needs access to proj)
#access sample names 
source code/load_sample_names.sh

pushd $dir # from load_...sh

#go to results directory
pushd results

#split each file into 200 fragments
nsplits=200

#split fasta files and write fragments into subdirectories
echo "splitting up fasta files"

for (( t=1; t<=6; t++ )); do
 for ((s=0; s<=${#stations}; s++)); do
   sname=Sample_${t}_${stations[$s]}
  if [[ $t -eq 5 ]] && [[ $s>1 ]] ; then
   sname=Sample_5_B; s=4; fi;
  subdir=assembly/$sname/trans-abyss-v1.4.4/merge/;
  pushd $subdir; echo $subdir
  $dir/../../bin/fastasplitn $sname-contigs.fa $nsplits
  popd > /dev/null
 done
done

popd > /dev/null

popd > /dev/null
