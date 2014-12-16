source code/load_sample_names.sh
## switch to data dir
pushd data

basedir=/proj/marchlab/HTSF/

mkdir HTSF_runs; pushd HTSF_runs
#cp -r $basedir/121008_UNC14-SN744_0273_AD1526ACXX/* .
#cp -r $basedir/130816_UNC15-SN850_0323_BD2BVEACXX/* .
#wget http://tacoma.med.unc.edu/amarchetti/PE_130816_UNC15-SN850_0323_BD2BVEACXX/
#cp -r $basedir/131105_UNC17-D00216_0108_AH7TRLADXX/* .
wget -m http://tacoma.med.unc.edu/amarchetti/PE_131211_UNC13-SN749_0321_BC32CYACXX/

mv tacoma.med.unc.edu/amarchetti/*/*.gz .

popd

for t in {1:5}; do
#t=4
 for s in $(seq 0 $((${#stations[@]}-1))); do
  stat=${stations[$s]}
  sampsubdir="Sample_${t}_$stat"
  mkdir $sampsubdir
  echo $sampsubdir

  if (( $t >= 4 )); then 
   pre="AM$t-$stat"
   pree=${pre/-0/-}
   for file in $(ls HTSF_runs/${pree}*.fastq.gz); do
     fil=$(basename $file)
     mv $file $sampsubdir/${fil/$pree/$pre}
   done
  else
   echo 'normal'
   mv HTSF_runs/${t}_${stations[$s]}*.fastq.gz $sampsubdir
  fi

 done
#done
popd
popd


#this is the one exception (B=bloom)
mkdir Sample_5_B; rmdir Sample_5_120; rmdir Sample_5_180
cp HTSF_runs/AM5-B-Sept-B_ATTCCT_L002_R* Sample_5_B
