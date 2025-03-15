import numpy as np
import os

# Function to convert ASCII-encoded Phred quality scores to numeric values
def phred_to_qscore(quality_str):
    return [ord(q) - 33 for q in quality_str.strip()]

# Define input/output directories
input_dir = "fq_raw_phred_scores"
output_dir = "fq_raw_phred_scores_numeric"
os.makedirs(output_dir, exist_ok=True)

# Process each quality score file
for quality_file in os.listdir(input_dir):
    if quality_file.endswith("_quality.txt"):
        input_path = os.path.join(input_dir, quality_file)
        output_path = os.path.join(output_dir, quality_file.replace("_quality.txt", "_phred_scores.csv"))

        # Read quality scores and convert to Phred scores
        with open(input_path, 'r') as infile:
            all_scores = [phred_to_qscore(line) for line in infile]

        # Convert to NumPy array for easy calculations
        scores_array = np.array(all_scores)

        # Save as CSV for further analysis
        np.savetxt(output_path, scores_array, delimiter=",", fmt="%d")

        print(f"Converted {quality_file} to numeric Phred scores -> {output_path}")
