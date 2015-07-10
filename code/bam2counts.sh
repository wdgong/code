source ../code/load_sample_names.sh
pushd $dir/results
module add samtools/0.1.19

for i in  assembly/Samp*/trans-abyss-v1.4.4/reads_to_contigs/Samp*.bam; do 
  pushd  $(dirname $i)
  touch stats.txt
  samtools flagstat $(basename $i) >> stats.txt
  samtools view $(basename $i) | cut -f 3  >  cts.tmp
  sort cts.tmp | uniq -c > counts.tab
 popd
done
