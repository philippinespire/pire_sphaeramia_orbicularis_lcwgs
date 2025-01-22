#!bin/bash

# Delete the following samples from the fq_raw directory
## SoC0301809F
## SoC0301809G
## SoC0301809H

sequence_dir="/home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_raw"
#seqID=("SoC0301809F" "SoC0301809G" "SoC0301809H") # This only records G and H, not F, which is weird.
seqID=("SoC0301809")
outfile="delete_seq.out"

for file in $(find $sequence_dir -name "*.fq.gz"); do
	for seqID in "${seqID[@]}"; do
		if [[ $file =~ $seqID ]]; then
			echo "Deleting file: $file" >> $outfile
			rm -i $file
			break
		fi
	done
done


