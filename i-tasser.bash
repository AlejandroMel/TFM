#!/bin/bash

# this is to allow setting $file as an environment variable
if [ "$file" == "" ] ; then
    file=${1:-"protein.fasta"}
    shift
fi

# get file directory
#	if $file is empty this will return "."
d=`dirname "$file"`

f="${file##*/}"
ext="${file##*.}"
n="${f%.*}"

echo "$0 $d/$f"

mkdir -p $d/i-tasser/$n
cp $file $d/i-tasser/$n/
cp $file $d/i-tasser/$n/seq.fasta

echo ~/contrib/I-TASSER5.1/I-TASSERmod/runI-TASSER.pl \
	-pkgdir ~/contrib/I-TASSER5.1/ \
	-libdir /db/i-tasser \
	-runstyle gnuparallel \
	-LBS true \
	-EC true \
	-GO true \
	-datadir $d/i-tasser/$n \
	-outdir $d/i-tasser/$n \
	-seqname $n \
	-light true \
        $*


~/contrib/I-TASSER5.1/I-TASSERmod/runI-TASSER.pl \
	-pkgdir ~/contrib/I-TASSER5.1/ \
	-libdir /db/i-tasser \
	-runstyle gnuparallel \
	-LBS true \
	-EC true \
	-GO true \
	-datadir $d/i-tasser/$n \
	-outdir $d/i-tasser/$n \
	-seqname $n \
	-light true \
	$* \
	|& tee -a $d/i-tasser/$n/i-tasser.log

# runstyle : serial parallel gnuparallel
# LBS: predict ligand binding site 
# EC: predict EC number
# GO: predict GO terms
# -light : run in fast mode
# -hours : maximum hours of simulations (default=5 when -light true)
# -outdir : default is same as -datadir
