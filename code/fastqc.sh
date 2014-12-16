#Author: Christian Stackhouse
#Date Modified: 2/18/14
#Use: B-submitting raw read data to the fastqc program 

kuredir=/proj/marchlab/projects/NeuseMetatx
pushd $kuredir

source code/load_sample_names.sh
module add fastqc

pushd data; mkdir fastqc

for (( t=1; t<=6; t++ )); do
 for ((s=0; s<=${#stations}; s++)); do
   sampsubdir=Sample_${t}_${stations[$s]}
  if [[ $t -eq 5 ]] && [[ $s>1 ]] ; then
   sampsubdir=Sample_5_B; s=4; fi;
   mkdir fastqc/$sampsubdir;
   target=$sampsubdir/*.fastq
   bsub fastqc -o fastqc/$sampsubdir -f fastq $target
   
 done # end station loop
 
done # end time loop
popd # out of data

