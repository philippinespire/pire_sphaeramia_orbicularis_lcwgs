#!/bin/bash

# Define the number of lines to extract (100 reads = 400 lines)
NUM_LINES=400

# Ensure the output directory exists
mkdir -p fq_raw_phred

# Read file names from fq_file_list.txt and process each file
while read -r fq_file; do
    # Extract only the filename (basename) without the full path
    filename=$(basename "$fq_file")

    # Generate output file name within fq_raw_phred/
    output_file="fq_raw_phred/${filename%.fq.gz}_subset.fastq"

    # Extract the first 100 reads (400 lines) and save to the output file
    zcat "$fq_file" | head -n $NUM_LINES > "$output_file"

    # Print status message
    echo "Extracted first 100 reads from $fq_file into $output_file"
done < fq_file_list.txt
