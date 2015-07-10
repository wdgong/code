##check if there is an errer 
##directory is blast_ta_contigs
pushd ../results/blast_ta_contigs
stations=(020 070 120 180)
for ((t=1;t<=6;t++));do
for ((s=0;s<=${#stations};s++));do
samp=Sample_${t}_${stations[$s]};
if [[ $t -eq 5 ]]&&[[ $s>1 ]];then
samp=Sample_${t}_B;s=4;fi;
cd $samp
ls|grep tab\.getall\.tab|wc -l >> ../check.tab
cd ..
done
done
popd
