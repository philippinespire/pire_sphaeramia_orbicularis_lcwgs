import numpy as np
import matplotlib.pyplot as plt
import os
import scipy.stats as stats

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

# Convert to NumPy arrays for statistical analysis
undetermined_scores = np.array(undetermined_scores)
sample_scores = np.array(sample_scores)

# Create a histogram
plt.figure(figsize=(10, 6))
plt.hist(undetermined_scores, bins=20, alpha=0.5, label="Undetermined Reads", color="red", edgecolor='black')
plt.hist(sample_scores, bins=20, alpha=0.5, label="Sample Reads", color="blue", edgecolor='black')
plt.xlabel("Mean Phred Quality Score")
plt.ylabel("Read Count")
plt.legend()
plt.title("Quality Score Distribution: Undetermined vs. Sample Reads")

# Save histogram to file
histogram_path = "quality_score_comparison.png"
plt.savefig(histogram_path, dpi=300)
print(f"Histogram saved to {histogram_path}")

# Perform t-test
t_stat, p_value = stats.ttest_ind(undetermined_scores, sample_scores, equal_var=False)

# Print results
print("\nStatistical Analysis (T-Test Results)")
print(f"T-Statistic: {t_stat:.4f}")
print(f"P-Value: {p_value:.4e}")

# Save results to a text file
with open("quality_score_analysis.txt", "w") as f:
    f.write("Statistical Analysis (T-Test Results)\n")
    f.write(f"T-Statistic: {t_stat:.4f}\n")
    f.write(f"P-Value: {p_value:.4e}\n")

print("Statistical analysis saved to quality_score_analysis.txt")
