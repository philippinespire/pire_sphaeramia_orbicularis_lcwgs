#!/bin/bash

# Ensure output directory exists
mkdir -p fq_raw_phred_scores

# Read each subset FASTQ file from the list
while read -r fastq_file; do
    # Extract only the filename (without path)
    filename=$(basename "$fastq_file")

    # Define the output file name inside fq_raw_phred_scores
    output_file="fq_raw_phred_scores/${filename%.fastq}_quality.txt"

    # Extract only the Phred quality score lines (every 4th line in the FASTQ file)
    awk 'NR%4==0' "$fastq_file" > "$output_file"

    echo "Extracted quality scores from $fastq_file to $output_file"
done < fq_phred_file_list.txt
