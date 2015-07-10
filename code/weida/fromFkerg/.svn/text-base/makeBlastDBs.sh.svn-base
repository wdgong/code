module add blast/2.2.28

pushd ../data
mkdir blastdbs

for i in $(ls  -l  | grep '^d' | grep -v phylo | cut -c 56-); do
  makeblastdb  -in $i/contigs.fa  -dbtype 'nucl' -out blastdbs/$i -title $i; 
done

