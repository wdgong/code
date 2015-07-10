#This code is for Sample 2-6, because Sample 1 is already done, the original code for all the samples are in ../bam2counts
cd ../../results
module add samtools/0.1.19

for i in  assembly/Sample_[2-6]_[0-9B]*/trans-abyss-v1.4.4/reads_to_contigs/Samp*.bam; do
  pushd  $(dirname $i)
  touch stats.txt
  samtools flagstat $(basename $i) >> stats.txt
  samtools view $(basename $i) | cut -f 3  >  cts.tmp
  sort cts.tmp | uniq -c > counts.tab
 popd
done
