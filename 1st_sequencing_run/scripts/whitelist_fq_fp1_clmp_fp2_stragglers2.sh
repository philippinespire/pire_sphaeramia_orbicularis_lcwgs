#!bin/bash

# Used in: Step 11. Decontaminate
## The jobs were stuck and there was no writing in the destination directory for some time now.
## Stragglers were identified by looking at both the indir ("../fq_fp1_clmp_fp2") and outdir ("../fq_fp1_clmp_fp2_fqscrn").
## These are the missing files:

### Sor-ABur_010-Ex1-3H-lcwgs-1-T.clmp.fp2_r2

indir="/home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_fp1_clmp_fp2_stragglers"
outdir="/home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_fp1_clmp_fp2_stragglers2"
id=("ABur_010")


for id in "${id[@]}"; do
	files=$(find $indir -name "*$id*clmp.fp2_r*.fq.gz")

	for file in "${files[@]}"; do
		mv $file $outdir
	done
	
	echo "${files[@]}" >> $indir/list_of_stragglers.txt
done










