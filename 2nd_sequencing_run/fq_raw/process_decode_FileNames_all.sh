#!/bin/bash

# Define input and output files
TSV_FILE="Sor_lcwgs-SeqLane_SequenceNameDecode.tsv"
TXT_FILE="origFileNames_ALL.txt"
OUTPUT_FILE="Sor_lcwgs-SeqLane_SequenceNameDecode_ALL.tsv"

# Ensure input files exist
if [[ ! -f "$TSV_FILE" || ! -f "$TXT_FILE" ]]; then
  echo "Error: One or both input files are missing!"
  exit 1
fi

# Create a temporary file for mapping Sequence_Name to Extraction_ID
awk -F'\t' 'NR>1 {print $1, $2}' "$TSV_FILE" > seq_map.tmp

# Prepare a temporary file for unique values
TEMP_OUTPUT="temp_output.tsv"
echo -e "Sequence_Name\tExtraction_ID" > "$TEMP_OUTPUT"

# Process each line in the input TXT file (excluding header)
tail -n +2 "$TXT_FILE" | while read -r line; do
  # Remove the last 8 characters from Sequence_Name
  sequence_name_trimmed="${line:0:-8}"

  # Extract the prefix (characters before the first underscore)
  prefix=$(echo "$line" | cut -d'_' -f1)

  # Find corresponding Extraction_ID from seq_map.tmp
  extraction_id=$(awk -v pfx="$prefix" '$1 == pfx {print $2}' seq_map.tmp)

  # If no match is found, assign "UNKNOWN"
  [[ -z "$extraction_id" ]] && extraction_id="UNKNOWN"

  # Write to temporary output file
  echo -e "$sequence_name_trimmed\t$extraction_id" >> "$TEMP_OUTPUT"
done

# Sort and remove duplicate lines, then save as final output file
sort -u "$TEMP_OUTPUT" > "$OUTPUT_FILE"

# Cleanup temporary files
rm seq_map.tmp "$TEMP_OUTPUT"

echo "Processing complete. Output saved to $OUTPUT_FILE"
