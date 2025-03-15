import numpy as np
import os

# Define input directory
input_dir = "fq_raw_phred_scores_numeric"

# Lists to store Phred quality scores
undetermined_scores = []
sample_scores = []

# Read all numeric Phred score CSV files
for file in os.listdir(input_dir):
    if file.endswith("_phred_scores.csv"):
        filepath = os.path.join(input_dir, file)
        data = np.loadtxt(filepath, delimiter=",")

        # Compute mean Phred score per read
        mean_scores = np.mean(data, axis=1)

        # Categorize the scores based on filename
        if "Undetermined" in file:
            undetermined_scores.extend(mean_scores)
        else:
            sample_scores.extend(mean_scores)

# Convert lists to NumPy arrays
undetermined_scores = np.array(undetermined_scores)
sample_scores = np.array(sample_scores)

# Compute statistics
undetermined_mean = np.mean(undetermined_scores)
undetermined_std = np.std(undetermined_scores)

sample_mean = np.mean(sample_scores)
sample_std = np.std(sample_scores)

# Print results to console
print("\nPhred Quality Score Statistics")
print(f"Undetermined Reads - Mean: {undetermined_mean:.2f}, Std Dev: {undetermined_std:.2f}")
print(f"Sample Reads - Mean: {sample_mean:.2f}, Std Dev: {sample_std:.2f}")

# Save results to a text file
with open("phred_quality_stats.txt", "w") as f:
    f.write("Phred Quality Score Statistics\n")
    f.write(f"Undetermined Reads - Mean: {undetermined_mean:.2f}, Std Dev: {undetermined_std:.2f}\n")
    f.write(f"Sample Reads - Mean: {sample_mean:.2f}, Std Dev: {sample_std:.2f}\n")

print("\nStatistics saved to phred_quality_stats.txt")
