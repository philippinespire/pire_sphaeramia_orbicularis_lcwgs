#!/bin/bash

# Rename neutral snp list files with the correct naming pattern

git mv neutral_fdr_snp_list_depth1_15_notrans.txt neutral_fdr_snp_list_depth1_15_notrans_subset.txt
git mv neutral_fdr_snp_list_depth1_15_notrans.chrs neutral_fdr_snp_list_depth1_15_notrans_subset.chrs
git mv neutral_fdr_snp_list_depth1_15_notrans.regions neutral_fdr_snp_list_depth1_15_notrans_subset.regions

# Git add changes
git add neutral_fdr*

# Commit the changes with a detailed message
git commit -m "Renaming neutral snp list files from the script selection_sob_subset.R to standardize the outfile pattern with 'subset' to indicate that the angsd pipeline identified SorCPnd041 as a PC2 outlier and was removed from the dataset."

# Push changes to the repository
git push
