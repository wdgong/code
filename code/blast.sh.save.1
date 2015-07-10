source code/load_sample_names.sh
source code/blast_headers.sh
pushd $dir
module add blast/2.2.28

n2d=/nas02/data
pmd=/proj/marchlab/data
nsd=/netscr/data

nrsrc=$n2d/blast/
kgsrc=$n2d/KEGG/KEGG/genes/blastdb/
svsrc=$n2d/SILVA/
mrsrc=$pmd/marineRef/2014.01.27/blastdb/
mr2src=$pmd/marineRef2/
mmet18src=$pmd/MMETSP/2014.04.29/blastdbs/
mmetspsrc=$pmd/MMETSP/2014.04.22/protblastdb/
mmetsnsrc=$pmd/MMETSP/2014.04.22/nuclblastdb/

nrdir=$nsd/nr/
kgdir=$nsd/kegg/
svdir=$nsd/silva/
mrdir=$nsd/marineRef/
mr2dir=$nsd/marineRef2/
mmet18dir=$nsd/MMET18/
mmetspdir=$nsd/MMETSP/
mmetsndir=$nsd/MMETSP/

kg=KEGG.pep
mr=mR.pep
mr2=MarineRefII
sv=SSURef_NR99_115
mmet18=18s_NR_renamed.fa
mmetsp=MMETSPprot
mmetsn=MMETSPnucl

if [ ! -e $nrdir/nr.pal ]
then
 mkdir -p $nrdir
 cp $nrsrc/nr.*.p* $nrdir
 cp $nrsrc/nr.pal $nrdir
fi
if [ ! -e $kgdir/$kg.pal ]
then
 mkdir -p $kgdir
 cp $kgsrc/$kg.*.p* $kgdir
 cp $kgsrc/$kg.pal $kgdir
fi
if [ ! -e $svdir/$sv.nal ]         ## run from kure (with screen)
then
 mkdir -p $svdir
 cp $svsrc/$sv.* $svdir
fi
if [ ! -e $mmet18dir/$mmet18.nal ]         ## run from kure (with screen)
then
 mkdir -p $mmet18dir
 cp $mmet18src/$mmet18.* $mmet18dir
fi
e
if [ ! -e $mmetspdir/$mmetsp.pal ] ## run from kure (with screen)
then
 mkdir -p $mmetspdir
 cp $mmetspsrc/$mmetsp.*.p* $mmetspdir
 cp $mmetspsrc/$mmetsp.pal $mmetspdir
fi
if [ ! -e $mmetsndir/$mmetsn.nal ] ## run from kure (with screen)
then
 mkdir -p $mmetsndir
 cp $mmetsnsrc/$mmetsn.*.n* $mmetsndir
 cp $mmetsnsrc/$mmetsn.nal $mmetsndir
fi
if [ ! -e $mrdir/$mr.pal ]         ## run from kure (with screen)
then
 mkdir -p $mrdir
 cp $mrsrc/$mr.*.p* $mrdir
 cp $mrsrc/$mr.pal $mrdir
fi
if [ ! -e $mr2dir/$mr2.pal ]         ## run from kure (with screen)
then
 mkdir -p $mr2dir
 cp $mr2src/$mr2.*.p* $mr2dir
 cp $mr2src/$mr2.pal $mr2dir
fi

mem=13
nsplits=200
minresultpct=98

tasubdir=trans-abyss-v1.4.4
pushd results
mkdir blast_ta_contigs; pushd blast_ta_contigs

targets=($mmet18dir/$mmet18 $svdir/$sv $nrdir/nr $kgdir/$kg $mrdir/$mr $mr2dir/$mr2 $mmetspdir/$mmetsp)

echo "Submitting blast jobs"         # run from killdevil using screen
for (( t=1; t<=6; t++ )); do
 for ((s=0; s<=${#stations}; s++)); do
   sampsubdir=Sample_${t}_${stations[$s]}
  if [[ $t -eq 5 ]] && [[ $s>1 ]] ; then
   sampsubdir=Sample_5_B; s=4; fi;
  mkdir $sampsubdir; pushd $sampsubdir > /dev/null ; echo $sampsubdir  
  query=$dir/results/assembly/$sampsubdir/$tasubdir/merge/
  for n in $(seq 1 $nsplits); do 
   frag=$(printf "frag%03d" "$n")
    if [ ! -e "$query/$frag" ]	 # Check to make sure query file exists
    then
      echo "query file $query/$frag doesn't exist"
    else
      for target in ${targets[@]}; do 
        blasttype=blastx
        if [[ "$target" == *_* ]]
        then 
          blasttype=blastn
        fi
        tg=$(basename ${target%.*})
        outfile=$(pwd)/$sampsubdir.$tg.$n.tab
        resultct=$(grep BLASTX $outfile | wc -l)
        nseqs=$(grep "^>" $query/$frag | wc -l)
        let resultpct="(( ($resultct * 100) / $nseqs ))"
        if (($resultpct < $minresultpct)); then
         jbnm=$sampsubdir
         bsub  -M $mem -P $jbnm -n1 -q week -o $(pwd)/$jbnm.$tg.$n.out -e $(pwd)/$jbnm.$tg.$n.err \
         $blasttype \
           -db $target -query $query/$frag \
           -max_target_seqs 10 -evalue .001 \
           -out $outfile -outfmt "$fmt"
         echo "blasting $frag: only $resultpct % of sequences have blast results"
        fi 
      done
    fi
  done # end split loop
  popd > /dev/null
 done  # end station loop
done   # end time    loop

popd > /dev/null # out of blast_ta_contigs
popd > /dev/null # out of results
