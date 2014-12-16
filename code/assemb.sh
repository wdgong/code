### author: David M Schruth
### date: 2013 April
### header file for both abyss.sh and transabyss.sh

module add python/2.7.1
module add perl/5.12.0
module add samtools/0.1.18
module add abyss/1.3.5
module add gmap/2012-06-20

TRANSABYSS_VERSION=1.4.4

source code/load_sample_names.sh
pushd $dir/results
asmbdir=assembly
mkdir $asmbdir; pushd $asmbdir > /dev/null

kstart=52
kend=96
kstep=2
ks=$(( (kend-kstart)/$kstep +1 ))

