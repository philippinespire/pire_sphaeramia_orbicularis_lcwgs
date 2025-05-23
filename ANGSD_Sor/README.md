<img src="http://www.fishbiosystem.ru/PERCIFORMES/Apogonidae/Foto/(Sphaeramia%20orbicularis)%2092f.jpg" alt="Sor" width="300"/>

# ANGSD: *Sphaeramia orbicularis* lcWGS data from Pandanon Island

Following the [ANGSD pipeline](https://github.com/philippinespire/pire_lcwgs_data_processing/tree/main/scripts/ANGSD_wahab) for *Sphaeramia orbicularis* lcWGS data from the 1st & 2nd sequencing runs from Pandanon Island. 

```
/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```

[ANGSD](https://www.popgen.dk/angsd/index.php/ANGSD) is a software package that can calculate genotype likelihoods from mapped lcwgs data. Along with accessory packages such as [pcangsd](https://www.popgen.dk/software/index.php/PCAngsd) and [realSFS](https://www.popgen.dk/angsd/index.php/RealSFS), ANGSD can be used to perform a number of useful analyses, including estimating population structure, genetic divergence, genetic diversity, and loci potentially under selection. Scripts were adapted from the Therkildsen Lab's [GitHub](https://github.com/therkildsen-lab) to perform analyses in ANGSD.

Outline of potential analyses using ANGSD: 
  1) Combining sequencing runs
  2) SNP calling
  3) Generating genotype likelihoods and making a beagle.gz file
  4) Running PCANGSD: PCA and Admixture Analyses
  5) (Optional) Running PCANGSD: Selection Scan
  6) (Optional) Running winPCA to detect chromosome inversions
  7) Generating Site Allele Frequencies
  8) Calculating FST across the whole genome
  9) Generate site frequency spectra for each site/era
  10) Calculate per-site thetas
  11) Calculate neutrality test statistics

---

<details><summary>1. Pre-processing</summary>

### 1. Pre-processing

Create an ANGSD directory within your species' lcwgs processing directory. 
```
cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs

mkdir ANGSD_Sor
```

Copy GenErode output \*.bam files to be analyzed by ANGSD into the ANGSD_Sor directory. For Albatross/historical samples these are the `.merged.rmdup.merged.realn.rescaled.bam` files that have been rescaled to account for historic DNA damage. For contemporary files these are the `.merged.rmdup.merged.realn.bam` files.
```
cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor

# Count modern GenErode output *.bam files
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/results/modern/mapping/reference.genbank.Sor20k/*.merged.rmdup.merged.realn.bam | wc -l
64

# Copy modern GenErode output *.bam files
rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/results/modern/mapping/reference.genbank.Sor20k/*.merged.rmdup.merged.realn.bam /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor &

# Count historical GenErode output *.bam files
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/results/historical/mapping/reference.genbank.Sor20k/*.merged.rmdup.merged.realn.rescaled.bam | wc -l
22

# Copy historical GenErode output *.bam files
rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/results/historical/mapping/reference.genbank.Sor20k/*.merged.rmdup.merged.realn.rescaled.bam /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor &

# Confirm all files have been copied. This is the number of individuals!
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor/*.bam | wc -l
86
```

</details>


<details><summary>2. SNP Calling</summary>

### 2. SNP Calling

An initial SNP calling step is used to identify a set of SNPs with a reasonable depth that can be assessed across the historic and contemporary samples.

Copy the `snp_calling.sbatch` script from ANGSD_wahab. 
```
cp /archive/carpenterlab/pire/pire_lcwgs_data_processing/scripts/ANGSD_wahab/snp_calling.sbatch ./
```

First make .txt files with list of all \*.bam files and a list of all \*.bam files with their full path.
```
ls *.bam > bam_list_all.txt

ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor/*.bam > bam_list_all_fullpath.txt
```

Generate an index for all .bam files, which will provide a supplementary index file (.bai) for each .bam file. 
```
salloc 

module load samtools

crun samtools index -M *.bam
```

Confirm that there are the same number of .bai and .bam files. This is the number of individuals!
```
ls *.bam | wc -l
86

ls *.bai | wc -l
86
```

Edit the `snp_calling.sbatch` script to fit your data. 
- After `-b`, add the full directory pathway to the file name of the `bam_list_all_fullpath.txt` file.
- After `-ref`, change the pathway to the correct reference genome for your species. Use the `reference.genbank.Sor20k.fasta` reference genome from `GenErode_Sor_20k/reference`.
- setMinDepth: Minimum depth filter should be 1x the number of individuals: 86
- setMaxDepth: Maximum depth filter should be 15x the number of individuals: 1290
- minInd: Minimum individual filter should be half of the total number of individuals (round up for a whole number): 45
- Parameters that stayed the same from the original script are a map quality filter (minMapQ) of 30, a minimum allele frequency filter (minMaf) of 0.001, and a SNP p-value (SNP_pval) of 1e-6. 
```
nano snp_calling.sbatch

crun angsd \
        -b /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor/bam_list_all_fullpath.txt \
		-ref /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \
		-out angsd_depth1_15_notrans -GL 1 -doGlf 2 -doMaf 1 -doMajorMinor 1 -doCounts 1 -doDepth 1 -maxDepth 10000 -dumpCounts 1 -doIBS 1 -makematrix 1 -doCov 1 -noTrans 1  \
        -setMinDepth 86 -setMaxDepth 1290 -minInd 45 \
        -minMapQ 30 \
        -SNP_pval 1e-6 -minMaf 0.001 \
        -P 40 \
        -remove_bads 1 -only_proper_pairs 1 -C 50
```

Run `snp_calling.sbatch` and specify the output directory. 
```
sbatch snp_calling.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 4258993
2/5/25 @ 14:47 PST

Check output file. 
```
less angsd_snp-4258993.out

Filtering complete: Observed: 104 different chromosomes from file:global_snp_list_depth1_15_notrans.txt
```

---

**
`angsd_depth1_15_notrans.beagle.gz` created by `snp_calling.sbatch` right? And `get_beagle.sbatch` creates output files with the format `angsd_depth1_15_notrans.beagle.gz`. But it creates another `beagle.gz` file, which is named `angsd_depth1_15_notrans.beagle.gz.beagle.gz`. But in the next steps, the PCA & Admix scripts use the file `angsd_depth1_15_notrans.beagle.gz`, which is the one created by `snp_calling.sbatch`, not `get_beagle.sbatch`. In `pire_salarias_fasciatus_lcwgs/angsd_analysis`, there are no `*.beagle.gz.beagle.gz` output files from `get_beagle.sbatch`. It looks like they have been renamed to `angsd_depth1_15_notrans_renamed.beagle.gz`.
**

snp_calling.SBATCH
-out angsd_depth1_15_notrans

get_beagle.SBATCH
-out angsd_depth1_15_notrans.beagle.gz

get_beagle_subset.SBATCH
-out angsd_depth1_15_notrans_subset.beagle.gz

angsd_get_beagle.sbatch (Tzo)
-out angsd_allpop_neutral_alloutputs

angsd_admix.sbatch (Tzo)
-b angsd_allpop_neutral.beagle.gz

angsd_pca.sbatch (Tzo)
-b angsd_allpop_neutral.beagle.gz

```
cd pire_salarias_fasciatus_lcwgs/angsd_analysis

ls -ltrh *.beagle.gz

-rw-r--r-- 1 m1salvad carpenter 2.6G Dec  4 12:06 angsd_depth1_15_notrans.beagle.gz
-rw-r--r-- 1 m1salvad carpenter 1.9G Dec 10 00:10 angsd_depth1_15_notrans_noinv.beagle.gz
-rw-r--r-- 1 m1salvad carpenter 1.8G Dec 13 00:50 angsd_depth1_15_notrans_noinv_subset.beagle.gz
-rw-r--r-- 1 bnreid   carpenter 2.3G Jan 14 14:26 angsd_depth1_15_notrans_renamed.beagle.gz
-rw-r--r-- 1 m1salvad carpenter 848M Jan 17 15:18 abas_sites_notrans.beagle.gz
-rw-r--r-- 1 m1salvad carpenter 1.6G Jan 17 18:41 cbas_sites_notrans.beagle.gz
-rw-r--r-- 1 m1salvad carpenter 2.4G Jan 29 00:12 angsd_depth1_15_notrans_subset.beagle.gz
-rw-r--r-- 1 m1salvad carpenter 2.2G Jan 31 11:28 angsd_depth1_15_notrans_subset_renamed.beagle.gz

```
**

---

</details>


<details><summary>3. Generate genotype likelihoods & a beagle.gz file</summary>

### 3. Generate genotype likelihoods & a beagle.gz file 

Genotype likelihoods will be used for all downstream analyses (PCA, admixture, estimating diversity, FST, and selection).
Use the get_beagle.sbatch file to generate a .beagle.gz file containing genotype likelihoods for the set of SNPs identified in the SNP calling step. 

Copy the `get_beagle.sbatch` script from ANGSD_wahab. 
```
cp /archive/carpenterlab/pire/pire_lcwgs_data_processing/scripts/ANGSD_wahab/get_beagle.sbatch ./
```

Edit `get_beagle.sbatch`.
- After `-anc`, change the pathway to the correct reference genome for your species. Use the `reference.genbank.Sor20k.fasta` reference genome from `GenErode_Sor_20k/reference`.
```
nano get_beagle.sbatch

crun angsd \
        -b bam_list_all.txt \
        -anc /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \
        -out angsd_depth1_15_notrans.beagle.gz \
		-out angsd_depth1_15_notrans_snplist \
        -doSaf 1 -noTrans 1 -GL 1 -doGlf 2 -doMaf 1 -doMajorMinor 3 -doCounts 1 -doDepth 1 -dumpCounts 1 \
        -P 8 \
        -sites global_snp_list_depth1_15_notrans.txt -rf global_snp_list_depth1_15_notrans.chrs
```

59M     angsd_depth1_15_notrans.beagle.gz
61M     angsd_depth1_15_notrans_snplist.beagle.gz

git mv angsd_depth1_15_notrans.beagle.gz.beagle.gz angsd_depth1_15_notrans_snplist.beagle.gz 


Run `get_beagle.sbatch` and specify the output directory.
```
sbatch get_beagle.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
Job ID: 4262442
2/6/25 @ 08:2 PST

Check output file. 
```
less angsd_beagle-4262442.out

Arguments and parameters for all analysis are located in .arg file
Total number of sites analyzed: 1290537418
Number of sites retained after filtering: 44118
```

----

**File naming error! 

All subsequent scripts that used `angsd_depth1_15_notrans.beagle.gz` used the wrong file. The `angsd_depth1_15_notrans.beagle.gz` file was generated by `snp_calling.sbatch`, not `get_beagle.sbatch`. The downstream scripts require the `.beagle.gz` file generated from `get_beagle.sbatch`, which contains genotype likelihoods for the set of SNPs identified in the SNP calling step, which was named `angsd_depth1_15_notrans.beagle.gz.beagle.gz`. The steps that this affected are PCANGSD & WinPCA. The PCANGSD scripts that this affected are `pcangsd_pca.sbatch`, `pcangsd_admix.sbatch`, and `pcangsd_selection.sbatch`. The outfile pattern of all future `get_beagle.sbatch` runs should be `--out angsd_depth1_15_notrans_snplist`. However, instead of rerunning `get_beagle.sbatch`, these files can just be rename, and the scripts can be edited. 

Copy the rename scripts from ANGSD_wahab. 
```
cp /archive/carpenterlab/pire/pire_lcwgs_data_processing/scripts/ANGSD_wahab/rename*.sh .
```
git commit -m "adding rename scripts to rename get beagle output files and edit pcangsd scripts with the correct input beagle.gz file"

Run the script `rename_get_beagle_output_files.sh` to rename all of the output files from the `get_beagle.sbatch` script to standardize the outfile pattern (`-out`) as `angsd_depth1_15_notrans_snplist` instead of `angsd_depth1_15_notrans.beagle.gz`. This will have to be edited for a `subset` run. 

<details><summary>rename_get_beagle_output_files.sh</summary>

```
#!/bin/bash

# Move files with the correct naming pattern
mv angsd_depth1_15_notrans.beagle.gz.pos.gz angsd_depth1_15_notrans_snplist.pos.gz
mv angsd_depth1_15_notrans.beagle.gz.beagle.gz angsd_depth1_15_notrans_snplist.beagle.gz
mv angsd_depth1_15_notrans.beagle.gz.mafs.gz angsd_depth1_15_notrans_snplist.mafs.gz
mv angsd_depth1_15_notrans.beagle.gz.saf.gz angsd_depth1_15_notrans_snplist.saf.gz
mv angsd_depth1_15_notrans.beagle.gz.saf.pos.gz angsd_depth1_15_notrans_snplist.saf.pos.gz
mv angsd_depth1_15_notrans.beagle.gz.saf.idx angsd_depth1_15_notrans_snplist.saf.idx

# Git move files that are tracked with the correct naming pattern
git mv angsd_depth1_15_notrans.beagle.gz.arg angsd_depth1_15_notrans_snplist.arg
git mv angsd_depth1_15_notrans.beagle.gz.depthSample angsd_depth1_15_notrans_snplist.depthSample
git mv angsd_depth1_15_notrans.beagle.gz.depthGlobal angsd_depth1_15_notrans_snplist.depthGlobal

# Git add changes
git add angsd_depth1_15_notrans_snplist.arg angsd_depth1_15_notrans_snplist.depthSample angsd_depth1_15_notrans_snplist.depthGlobal

# Commit the changes with a detailed message
git commit -m "Renaming output files from the script get_beagle.gz to standardize the outfile pattern as 'angsd_depth1_15_notrans_snplist' instead of 'angsd_depth1_15_notrans.beagle.gz', which was confusing."

# Push changes to the repository
git push
```

</p>
</details>

```
bash rename_get_beagle_output_files.sh
```

Use the script `rename_pcangsd_sbatch_beagle_filename.sh` to rename all of the input beagle.gz scripts in the `pcangsd_*.sbatch` scripts from `-b angsd_depth1_15_notrans.beagle.gz` to `-b angsd_depth1_15_notrans_snplist.beagle.gz`. These scripts can then be run without any further changes. The output will overwrite the output from the previous incorrect runs. 

<details><summary>rename_pcangsd_sbatch_beagle_filename.sh</summary>

```
#!/bin/bash

# Ensure the loop does not run if no files match
shopt -s nullglob

# Find all .sbatch files that match the pattern pcangsd_*.sbatch
for file in pcangsd_*.sbatch; do
    # Replace '.beagle.gz' with '_snplist.beagle.gz' in the file content
    sed -i 's/\.beagle\.gz/_snplist.beagle.gz/g' "$file"
    echo "Updated: $file"
done

echo "All matching pcangsd_*.sbatch scripts have been updated."

# Check for changes before committing
if git diff --quiet; then
    echo "No changes detected, skipping commit."
else
    git add pcangsd_*.sbatch
    git commit -m "Replaced '.beagle.gz' with '_snplist.beagle.gz' as the '-b beagle.gz' input file. This is the correct file (angsd_depth1_15_notrans_snplist.beagle.gz) created from get_beagle.sbatch not the one created from snp_calling.sbatch (angsd_depth1_15_notrans.beagle.gz)."
    git push
fi
```

</p>
</details>

```
bash rename_pcangsd_sbatch_beagle_filename.sh
```

**Rerun `pcangsd_pca.sbatch`, `pcangsd_admix.sbatch`, and `pcangsd_selection.sbatch`. They should not have to be edited, but check first. 

**SUBSET

Remove the 1 outliers identified by `pca.R` and create a `subset` run. 

Identify outliers using `pca.R`. These file names were output to the file `PC2_outliers.txt`.
```
PC2_lower_threshold <- -0.02

PC2 Outliers:
SorCPnd041.merged.rmdup.merged.realn.bam
```

Use grep to remove the outliers in `PC2_outliers.txt` from `bam_list_all.txt` to create the subset file `bam_list_all_subset.txt`.
```
grep -v -f PC2_outliers.txt bam_list_all.txt > bam_list_all_subset.txt
```

Count the number of lines in the bam list files. There should be 1 less line in the subset file. 
```
wc -l bam_list_all.txt
86

wc -l bam_list_all_subset.txt
85
```

Copy the `get_beagle.sbatch` script.  
```
cp get_beagle.sbatch get_beagle_subset.sbatch
```

Edit `get_beagle_subset.sbatch`.
- After `-anc`, change the pathway to the correct reference genome for your species. Use the `reference.genbank.Sor20k.fasta` reference genome from `GenErode_Sor_20k/reference`.
```
crun angsd \
        -b bam_list_all_subset.txt \
        -anc /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \
		-out angsd_depth1_15_notrans_subset_snplist \
        -doSaf 1 -noTrans 1 -GL 1 -doGlf 2 -doMaf 1 -doMajorMinor 3 -doCounts 1 -doDepth 1 -dumpCounts 1 \
        -P 8 \
        -sites global_snp_list_depth1_15_notrans.txt -rf global_snp_list_depth1_15_notrans.chrs
```

Run `get_beagle_subset.sbatch` and specify the output directory.
```
sbatch get_beagle_subset.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 4288314
2/22/25 @ 12:18 PST

Check output file. 
```
less angsd_beagle-4288314.out

Total number of sites analyzed: 1290396307
Number of sites retained after filtering: 44118
```

</details>


<details><summary>4. PCANGSD: PCA</summary>

### 4. PCANGSD: PCA

**Correct beagle file: `angsd_depth1_15_notrans_snplist.beagle.gz`

Run `pcangsd_pca.sbatch` and specify the output directory.
```
crun pcangsd -b angsd_depth1_15_notrans_snplist.beagle.gz  --maf 0.001 --threads 16 --out angsd_notrans_snps_pca

sbatch pcangsd_pca.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 4265575
2/8/25 @ 06:29 PST

Check output files.
```
less pcangsd_pca-4265575.out

PCAngsd did not converge!
Saved covariance matrix as angsd_notrans_snps_pca.cov
```

Run again but with `--it 500` argument.

----

**Correct beagle file: `angsd_depth1_15_notrans_snplist.beagle.gz`

Run `pcangsd_pca_it500.sbatch` and specify the output directory.
```
crun pcangsd -b angsd_depth1_15_notrans_snplist.beagle.gz --it 500 --maf 0.001 --threads 16 --out angsd_notrans_snps_pca_it500

sbatch pcangsd_pca_it500.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 4265576
2/8/25 @ 06:32 PST

Check output files.
```
less pcangsd_pca-4265576.out

PCAngsd converged.
Saved covariance matrix as angsd_notrans_snps_pca_it500.cov
```

**Subset. Remove outlier on PC2. 

----

**Subset

Copy
```
cp pcangsd_pca.sbatch pcangsd_pca_subset.sbatch
```

Edit
```
crun pcangsd -b angsd_depth1_15_notrans_subset_snplist.beagle.gz  --maf 0.001 --threads 16 --out angsd_notrans_snps_subset_pca
```

Run.
```
sbatch pcangsd_pca_subset.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706351
2/24/25 @ 13:27 PST

Check output files.
```
less pcangsd_pca-10706351.out

PCAngsd did not converge!
Saved covariance matrix as angsd_notrans_snps_subset_pca.cov
```

**Run subset with 500 iterations

----

**Subset w/ it500

Copy
```
cp pcangsd_pca_subset.sbatch pcangsd_pca_subset_it500.sbatch
```

Edit
```
crun pcangsd -b angsd_depth1_15_notrans_subset_snplist.beagle.gz --maf 0.001 --threads 16 --it 500 --out angsd_notrans_snps_subset_it500_pca
```

Run.
```
sbatch pcangsd_pca_subset_it500.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706352
2/24/25 @ 13:30 PST

Check output files.
```
less pcangsd_pca-10706352.out

PCAngsd converged.
Saved covariance matrix as angsd_notrans_snps_subset_it500_pca.cov
```

**Check PCA & Admix plots.

----

**DEPRECATED: wrong beagle.gz

1.1 `pcangsd_pca.sbatch`

Copy the `pcangsd_pca.sbatch` script from ANGSD_wahab. 
```
cp /archive/carpenterlab/pire/pire_lcwgs_data_processing/scripts/ANGSD_wahab/pcangsd_pca.sbatch ./
```

Edit the `pcangsd_pca.sbatch` script to fit your paths and filenames.
- Change the output file to `--out angsd_notrans_snps_pca`.
- Change the input file to `-b angsd_depth1_15_notrans.beagle.gz` to create the genotype likelihood file.
```
nano pcangsd_pca.sbatch

crun pcangsd -b angsd_depth1_15_notrans_snplist.beagle.gz  --maf 0.001 --threads 16 --out angsd_notrans_snps_pca
```

Run `pcangsd_pca.sbatch` and specify the output directory.
```
sbatch pcangsd_pca.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 4262558
2/6/25 @ 16:00 PST


Check output files.
```
less pcangsd_pca-4262558.out

PCAngsd did not converge!
Saved covariance matrix as angsd_notrans_snps_pca.cov
```

Run again but with `--it 500` argument. 

----

**DEPRECATED: wrong beagle.gz

1.2 `pcangsd_pca_it500.sbatch`

Copy the `pcangsd_pca.sbatch` script and rename it to `pcangsd_pca_it500.sbatch` to indicate a file with 500 iterations.
```
cp pcangsd_pca.sbatch pcangsd_pca_it500.sbatch
```

Edit the `pcangsd_pca_it500.sbatch` script to fit your paths and filenames.
- Add another argument called `--it 500` to specify 500 iterations.
- Change the output file to `--out angsd_notrans_snps_pca_it500`.
- Change the input file to `-b angsd_depth1_15_notrans.beagle.gz` to create the genotype likelihood file.
```
crun pcangsd -b angsd_depth1_15_notrans.beagle.gz --it 500 --maf 0.001 --threads 16 --out angsd_notrans_snps_pca_it500
```

Run `pcangsd_pca_it500.sbatch` and specify the output directory.
```
sbatch pcangsd_pca_it500.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 4262564
2/6/25 at 16:12 PST

Check output files.
```
less pcangsd_pca-4262564.out

PCAngsd did not converge!
Saved covariance matrix as angsd_notrans_snps_pca_it500.cov
```

Run again but with `--it 2000` argument. 

----

**DEPRECATED: wrong beagle.gz

1.2 `pcangsd_pca_it2000.sbatch`

Copy the `pcangsd_pca.sbatch` script and rename it to `pcangsd_pca_it2000.sbatch` to indicate a file with 2000 iterations.
```
cp pcangsd_pca_it500.sbatch pcangsd_pca_it2000.sbatch
```

Edit the `pcangsd_pca_it2000.sbatch` script to fit your paths and filenames.
- Add another argument called `--it 2000` to specify 2000 iterations.
- Change the output file to `--out angsd_notrans_snps_pca_it2000`.
- Change the input file to `-b angsd_depth1_15_notrans.beagle.gz` to create the genotype likelihood file.
```
nano pcangsd_pca_it2000.sbatch

crun pcangsd -b angsd_depth1_15_notrans.beagle.gz --it 2000 --maf 0.001 --threads 16 --out angsd_notrans_snps_pca_it2000
```

Run `pcangsd_pca_it2000.sbatch` and specify the output directory.
```
sbatch pcangsd_pca_it2000.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 4262568
2/6/25 @ 16:36 PST

Check output file.
```
less pcangsd_pca-4262568.out

PCAngsd converged.
Saved covariance matrix as angsd_notrans_snps_pca_it2000.cov
```

</details>


<details><summary>5. PCANGSD: Admix</summary>

### 5. PCANGSD: Admix

**Rerun with correct beagle file: `angsd_depth1_15_notrans_snplist.beagle.gz`

2.1. `pcangsd_admix_it500.sbatch`

Copy. 
```
cp pcangsd_admix_it2000.sbatch pcangsd_admix_it500.sbatch
```

Edit. 
```
crun pcangsd -b angsd_depth1_15_notrans_snplist.beagle.gz --admix --maf 0.001 --threads 16 --it 500 --out angsd_notrans_snps_admix_it500
```

Run `pcangsd_admix_it500.sbatch` and specify the output directory.
```
sbatch pcangsd_admix_it500.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 4288128
2/22/25 @ 18:15 PST

Check output files.
```
less pcangsd_admix_notrans-4288128.out

Converged.
Frobenius error: 4.64700984954834
Log-likelihood: -2531394.93233
Saved admixture proportions as angsd_notrans_snps_admix_it500.admix.2.Q
Saved ancestral allele frequencies proportions as angsd_notrans_snps_admix_it500.admix.2.P
```

**K = 2. PCA identified a PC2 outlier. Remove the outlier, subset the data, rerun get_beagle, admix, PCA. 

----

**Subset

`pcangsd_admix_subset.sbatch`

Copy. 
```
cp pcangsd_admix_it500.sbatch pcangsd_admix_subset.sbatch
```

Edit. 
```
crun pcangsd -b angsd_depth1_15_notrans_subset_snplist.beagle.gz --admix --maf 0.001 --threads 16 --out angsd_notrans_snps_subset_admix
```

Run.
```
sbatch pcangsd_admix_subset.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706353
2/24/25 @ 13:35 PST

Check output files.
```
less pcangsd_admix_notrans-10706353.out

PCAngsd did not converge!
Saved covariance matrix as angsd_notrans_snps_subset_admix.cov

Converged.
Frobenius error: 4.810359954833984
Log-likelihood: -2491962.18719
Saved admixture proportions as angsd_notrans_snps_subset_admix.admix.2.Q
Saved ancestral allele frequencies proportions as angsd_notrans_snps_subset_admix.admix.2.P
```

**Run with 500 iterations.

----

**Subset w/ 500 iterations

`pcangsd_admix_subset.sbatch`

Copy. 
```
cp pcangsd_admix_subset.sbatch pcangsd_admix_subset_it500.sbatch
```

Edit. 
```
crun pcangsd -b angsd_depth1_15_notrans_subset_snplist.beagle.gz --admix --maf 0.001 --threads 16 --it 500 --out angsd_notrans_snps_subset_it500_admix
```

Run.
```
sbatch pcangsd_admix_subset_it500.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706354
2/24/25 @ 13:39 PST

Check output files.
```
less pcangsd_admix_notrans-10706354.out

PCAngsd converged.
Saved covariance matrix as angsd_notrans_snps_subset_it500_admix.cov

Converged.
Frobenius error: 4.595200061798096
Log-likelihood: -2492302.10064
Saved admixture proportions as angsd_notrans_snps_subset_it500_admix.admix.2.Q
Saved ancestral allele frequencies proportions as angsd_notrans_snps_subset_it500_admix.admix.2.P
```

**Check PCA & Admix plots

----

**DEPRECATED: wrong beagle.gz

2.3 `pcangsd_admix_it2000.sbatch`

Copy the `pcangsd_admix.sbatch` script and rename to `pcangsd_admix_it2000.sbatch` to indicate a file with 500 iterations.
```
cp /archive/carpenterlab/pire/pire_lcwgs_data_processing/scripts/ANGSD_wahab/pcangsd_admix.sbatch pcangsd_admix_it2000.sbatch
```

Edit the `pcangsd_admix_it2000.sbatch` script to fit your paths and filenames.
- Add another argument called `--it 2000` to specify 2000 iterations.
- Change the output file to `--out angsd_admix_notrans_it2000`.
- Change the input file to `--b angsd_depth1_15_notrans.beagle.gz` to have the genotype likelihood file.
```
crun pcangsd -b angsd_depth1_15_notrans.beagle.gz --admix --it 2000 --maf 0.001 --threads 16 --out angsd_admix_notrans_it2000
```

Run `pcangsd_admix_it2000.sbatch` and specify the output directory.
```
sbatch pcangsd_admix_it2000.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 4262570
2/6/25 @ 14:41 PST

Check output file.
```
less pcangsd_admix_notrans-4262570.out

Converged.
Frobenius error: 8.388299942016602
Log-likelihood: -2725545.80557
Saved admixture proportions as angsd_admix_notrans_it2000.admix.2.Q
Saved ancestral allele frequencies proportions as angsd_admix_notrans_it2000.admix.2.P
```

---

</details>


<details><summary>5. PCANGSD: Admixture STATS</summary>

### 5. PCANGSD: Admixture STATS

**Analyze results

After running `pcangsd_admix_it500.sbatch`, analyze the output files `angsd_admix.#.Q` and `bam_list.txt` with the script `admixture.R`. This can be done on [ODU OnDemand RStudio](https://ondemand.wahab.hpc.odu.edu/), or this script and output files can be downloaded and run locally.

**Subset with 500 iterations

Copy the R script `admixture.R` from ANGSD_Abu.
```
cp /archive/carpenterlab/pire/pire_lethrinus_variegatus_lcwgs/ANGSD_Lva/admixture_subset_k2.R ./admixture_subset_it500_k2.R
```

Run `admixture.R` in RStudio to get the admixture proportions plot. 
```
K = 2

k2_angsd_not <- read.table("angsd_notrans_snps_subset_it500_admix.admix.2.Q")

bamlist=read.table("bam_list_all_subset.txt")

Number of Albatross (historical) BAM files: 22

Number of Contemporary (modern) BAM files: 63

Total number of BAM files: 85
```
Plot: `sor_plot_angsd_notrans_snps_subset_it500_admix_2_Q.png`


</details>


<details><summary>5. PCANGSD: PCA STATS</summary>

### 5. PCANGSD: PCA STATS

** Analyze results

After running `running pcangsd_pca_it500.sbatch`, analyze the output files`angsd_snps_pca.cov` and `bam_list.txt` with the script `pca.R`. This can be done on [ODU OnDemand RStudio](https://ondemand.wahab.hpc.odu.edu/), or this script and output files can be downloaded and run locally.

Copy the R script `pca.R` from ANGSD_wahab.
```
cp /archive/carpenterlab/pire/pire_ambassis_buruensis_lcwgs/ANGSD_Abu/pca_it500_subset_k2.R ./pca_it500_k2.R
```

Run `pca.R` in RStudio to get the PCA for historical and contemporary individuals. 
```
cov_matrix_angsd <- as.matrix(read.table("angsd_notrans_snps_pca_it500.cov"))

bamlist=read.table("bam_list_all.txt")

Number of Albatross (historical) BAM files: 22

Number of Contemporary (modern) BAM files: 64

Total number of BAM files: 86


PC2_lower_threshold <- -0.02

PC2 Outliers:
SorCPnd041.merged.rmdup.merged.realn.bam

```
Plot: `sor_plot_angsd_notrans_snps_pca_it500_cov.png`

**1 PC2 outlier: Remove SorCPnd041 using PC2_outliers.txt. Check admixture results. Then rerun as subset of dataset. 

----

**Subset with 500 iterations

Copy the R script `pca.R`.
```
cp /archive/carpenterlab/pire/pire_lethrinus_variegatus_lcwgs/ANGSD_Lva/pca_subset_k2.R ./pca_subset_it500_k2.R
```

Run `pca.R` in RStudio to get the PCA for historical and contemporary individuals. 
```
cov_matrix_angsd <- as.matrix(read.table("angsd_notrans_snps_subset_it500_pca.cov"))

bamlist=read.table("bam_list_all_subset.txt")

Number of Albatross (historical) BAM files:

Number of Contemporary (modern) BAM files:

Total number of BAM files:
```
Plot: `sor_plot_angsd_notrans_snps_subset_it500_pca_cov_k2.png`



----

3. Analyze results

After running `running pcangsd_pca_it500_noinv_subset.sbatch` & `pcangsd_admix_it500_noinv_subset.sbatch`, analyze the output files`angsd_snps_pca.cov`, `bam_list.txt`, and `angsd_admix.2.Q` with the scripts `admixture.R` and `pca.R`. This can be done on [ODU OnDemand RStudio](https://ondemand.wahab.hpc.odu.edu/), or these output files and scripts can be downloaded and run locally. Run the `admixture.R` before `pca.R`.

Run `admixture.R` in RStudio to get the admixture proportions plot. 

Run `pca.R` in RStudio to get the PCA for historical and contemporary individuals. 

--> Once you have run admixture and PCA, if you have individual outliers or evidence of inversions (a "three-stripe" pattern in the PCA) you may want to revisit step #3, removing outlier individuals and/or chromosomes containing inversions (identifiable by running separate PCAs for each chromosome). WinPCA (step #6, still in development) can also help to pinpoint inverted regions.

</details>


<details><summary>5. (Optional) Running PCANGSD for a Selection Scan</summary>

### 5. (Optional) Running PCANGSD for a Selection Scan

5.1 `pcangsd_selection.sbatch`

Copy script. 
```
cp /archive/carpenterlab/pire/pire_lethrinus_variegatus_lcwgs/ANGSD_Lva/pcangsd_selection.sbatch ./pcangsd_selection_subset_it500.sbatch
```

Edit. 
```
crun pcangsd -b angsd_depth1_15_notrans_subset_snplist.beagle.gz  --maf 0.001 --threads 16 --it 500 --out angsd_notrans_snps_subset_it500_selection --selection --sites_save
```

Run `pcangsd_selection_subset_it500.sbatch` and specify the output directory.
```
sbatch pcangsd_selection_subset_it500.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706359
2/24/25 @ 15:15 PST

Check output files.
```
less pcangsd_selection-10706359.out

PCAngsd converged.
Saved covariance matrix as angsd_notrans_snps_subset_it500_selection.cov

Performing selection scan (FastPCA) for 1 PCs.
Saved test statistics as angsd_notrans_snps_subset_it500_selection.selection

Creating boolean vector of sites surviving filters.
Saved boolean vector of sites kept after filtering as angsd_notrans_snps_subset_it500_selection.sites
``` 

</details>


<details><summary>6. (Optional) Running winPCA to detect chromosome inversions (still in testing on Wahab)</summary>

### 6. (Optional) Running winPCA to detect chromosome inversions (still in testing on Wahab)

Make sure to install any Python packagedependencies needed for winPCA. 
```
mamba install numpy pandas numba scikit-allel plotly
```

Run salloc. Unlike sbatch, which submits a batch job script for later execution, salloc allocates resources immediately and starts an interactive shell session within the allocation. This is useful for testing, debugging, or running commands interactively on a compute node. 

```
salloc
```
Make a list of unique chromosome names (or identifiers) from the beagle file. Save this to a file named ncbi_chromnames.
```
gunzip -c angsd_depth_1_15_notrans.beagle.gz | ‘ awk { print $1 } ‘ | cut -c 1-11 | uniq > ncbi_chromnames
#extracts unique chromosome names (or identifiers) from the beagle file by printing the first field of the file (chromosome name), the first 11 characters of that field, and prints it to ncbi_chromnames file
```

Create a new beagle.gz file with the inversions using sed command to make the format compliant with running winPCA. Make sure to use the original beagle.gz file that does include inversions (angsd_depth_1_15_notrans.beagle.gz). Instead of our chromosome names being like NC_043745.1_651, they should be listed as chr1_SNPmarker#. In Excel, paste unique chromosome names into one column, and a list of the necessary chromosome names (chr1, chr2, chr3 …) in another column. This is needed for your sed file. Copy these two columns into a new file in the command line named sedfile. 
```
vi sedfile 
#Make sure to paste your two columns

gunzip - c angsd_depth_1_15_notrans.beagle.gz  | sed -f sedfile > angsd_depth_1_15_notrans_renamed.beagle.gz
#compresses a .gz file, applies sed transformations, and creates a new .beagle file with the modifications.

gunzip -c angsd_depth1_15_notrans_renamed.beagle.gz | less
#view format of new beagle file to check that it is the same as the format used for winPCA.
```

Try running winPCA on the fourth chromosome since we know this chromosome has inversions. 
```
module load ngsTools/2024

crun.ngsTools winpca pca angsd_depth_1_15_notrans_renamed.beagle.gz chr4:1-27169852 chr4
#Chr4:27169852 is chromosome name and size
#1- is the size of the windows analysis 
```

</details>


<details><summary>7. Generating Site Allele Frequencies</summary>

### 7. Generating Site Allele Frequencies

Make two bam lists: one with only Albatross individuals (`ACeb`) and one with only contemporary individuals (`CPnd`). If necessary, adjust these to use the subsetted bam list that excludes outlier individuals. 

```
grep "ACeb" bam_list_all_subset.txt > bam_list_all_subset_ACeb.txt 

grep "CPnd" bam_list_all_subset.txt > bam_list_all_subset_CPnd.txt
```

Copy the `saf_beagle_maf.sbatch` script from ANGSD_wahab. 
```
cp /archive/carpenterlab/pire/pire_corythoichthys_haematopterus_lcwgs/ANGSD_Cha/saf_beagle_maf_subset_APnd.sbatch ./saf_beagle_maf_subset_ACeb.sbatch

cp /archive/carpenterlab/pire/pire_corythoichthys_haematopterus_lcwgs/ANGSD_Cha/saf_beagle_maf_subset_CPnd.sbatch ./

cp saf_beagle_maf_subset_CPnd.sbatch saf_beagle_maf_subset.sbatch
```

**Albatross
Edit the Albatross `saf_beagle_maf_subset_ACeb.sbatch` script to fit your data.
- Change the input bam list (`-b`) to the historical .bam list: `-b bam_list_all_subset_ACeb.txt`
- Change the ancestral state (`-anc`) to the GenErode reference genome since we don't know the ancestral states: `-anc /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \`
- Change the reference genome (`-ref`) to the GenErode reference genome: `-ref /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \`
- Change the output (`-out`) to indicate historical sites: `-out ACeb_sites_notrans`
```
crun angsd \
        -b bam_list_all_subset_ACeb.txt \
        -anc /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \
        -ref /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \
        -out ACeb_sites_notrans_subset \
		-doSaf 1 -noTrans 1 -GL 1 -doGlf 2 -doMaf 1 -doMajorMinor 3 -doCounts 1 -doDepth 1 -dumpCounts 1 -P 8 \
        -sites global_snp_list_depth1_15_notrans.txt -rf global_snp_list_depth1_15_notrans.chrs
```

Run.
```
sbatch saf_beagle_maf_subset_ACeb.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706360
2/24/25 @ 17:00

Check output.
```
less angsd_saf-10706360.out

Total number of sites analyzed: 642698877
Number of sites retained after filtering: 40244
```

**Contemporary
Edit the Contemporary `saf_beagle_maf_subset_CPnd.sbatch` script to fit your data.
- Change the input bam list (`-b`) to the contemporary .bam list: `-b bam_list_all_subset_CPnd.txt`
- Change the ancestral state (`-anc`) to the GenErode reference genome since we don't know the ancestral states: `-anc /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \`
- Change the reference genome (`-ref`) to the GenErode reference genome: `-ref /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \`
- Change the output (`-out`) to indicate contemporary sites: `-out CPnd_sites_notrans`
```
crun angsd \
        -b bam_list_all_subset_CPnd.txt \
        -anc /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \
        -ref /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \
        -out CPnd_sites_notrans_subset \
		-doSaf 1 -noTrans 1 -GL 1 -doGlf 2 -doMaf 1 -doMajorMinor 3 -doCounts 1 -doDepth 1 -dumpCounts 1 -P 8 \
        -sites global_snp_list_depth1_15_notrans.txt -rf global_snp_list_depth1_15_notrans.chrs
```

Run.
```
sbatch saf_beagle_maf_subset_CPnd.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706361
2/24/25 @ 17:02

Check output.
```
less angsd_saf-10706361.out

Total number of sites analyzed: 1289667115
Number of sites retained after filtering: 44118
```


Edit the **All** `saf_beagle_maf_subset.sbatch` script to fit your data.
- Change the input bam list (`-b`) to the all .bam list: `-b bam_list_all_subset.txt`
- Change the ancestral state (`-anc`) to the GenErode reference genome since we don't know the ancestral states: `-anc /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \`
- Change the reference genome (`-ref`) to the GenErode reference genome: `-ref /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \`
- Change the output (`-out`) to indicate all sites: `-out all_sites_notrans_subset`
- Make sure the `-sites` for the SNP list is set correctly: `-sites global_snp_list_depth1_15_notrans.txt`
- Make sure the right chromosomes (`-rf`) is set correctly: `-rf global_snp_list_depth1_15_notrans.chrs`
```
crun angsd \
        -b bam_list_all_subset.txt \
        -anc /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \
        -ref /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta \
        -out all_sites_notrans_subset \
		-doSaf 1 -noTrans 1 -GL 1 -doGlf 2 -doMaf 1 -doMajorMinor 3 -doCounts 1 -doDepth 1 -dumpCounts 1 -P 8 \
        -sites global_snp_list_depth1_15_notrans.txt -rf global_snp_list_depth1_15_notrans.chrs
```

Run `saf_beagle_maf_subset.sbatch` and specify the output directory.
```
sbatch saf_beagle_maf_subset.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 
3/8/25 @  PST

Check output file.
```
less 


```


Copy the script `concat_pos_gz_files.sbatch` to concatenate the files, remove duplicates, preserve header. 
```
cp ../../pire_corythoichthys_haematopterus_lcwgs/ANGSD_Cha/concat_pos_gz_files.sbatch ./
```

Run script. 
```
bash concat_pos_gz_files.sbatch ACeb_sites_notrans_subset.pos.gz CPnd_sites_notrans_subset.pos.gz combined_sites_notrans_subset.pos.gz
```


</details>


<details><summary>8. Calculating genome-wide and windowed FST</summary>

### 8. Calculating genome-wide and windowed FST

**Genome-wide Fst

Copy the `fst.sbatch` script from ANGSD_wahab. This script gets pairwise Fst estimates from angsd for each population/group pair.
```
cp /archive/carpenterlab/pire/pire_corythoichthys_haematopterus_lcwgs/ANGSD_Cha/fst_subset.sbatch ./
```

Edit the `fst.sbatch` script to fit your data. It uses the `*.saf.idx` output files from Step 7. Generating Allele Frequencies.
- Change the SAF directory (`SAFDIR`) to your ANGSD_Sor directory: `SAFDIR=${1:-/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor}`
- Change population 1 (`POP1`) to: `POP1=${4:-ACeb_sites_notrans_subset}`
- Change population 2 (`POP2`) to: `POP2=${5:-CPnd_sites_notrans_subset}`
```
SAFDIR=${1:-/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor}
POP1=${4:-ACeb_sites_notrans_subset}
POP2=${5:-CPnd_sites_notrans_subset}


```

Run `fst.sbatch`. The script specifies the output directory so you do not have to add the add the `/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor` argument.
```
sbatch fst_subset.sbatch
```
JobID: 10706373
2/24/25 @ 19:48

Check output.
```
less angsd_fst-10706373.out

FST.Unweight[nObs:40244]:0.031002 Fst.Weight:0.048889
```

**Windowed Fst

Windowed Fst can be calculated in ANGSD based on the output of `fst.sbatch` using the `fst_window.sbatch` script. Currently the script uses a window size of 50kbp and a step size of 10kbp, though this can be adjusted (however note that this will reduce the number of SNPs per window and potentially increase the "noise" of Fst estimates).

Copy the `fst_window.sbatch` script from ANGSD_wahab. 
```
cp /archive/carpenterlab/pire/pire_corythoichthys_haematopterus_lcwgs/ANGSD_Cha/fst_window_subset.sbatch ./
```

Edit the `fst_window_subset.sbatch` script to fit your data. It uses the `*.saf.idx` output files from Step 7. Generating Allele Frequencies. The difference between the scripts `fst.sbatch` and `fst_window.sbatch` is the windowed Fst argument: `-win 50000 -step 10000`.
- Change the SAF directory (`SAFDIR`) to your ANGSD_Sor directory: `SAFDIR=${1:-/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor}`
- Change population 1 (`POP1`) to: `POP1=${4:-ACeb_sites_notrans_subset}`
- Change population 2 (`POP2`) to: `POP2=${5:-CPnd_sites_notrans_subset}`
```
SAFDIR=${1:-/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor}
POP1=${4:-ACeb_sites_notrans_subset}
POP2=${5:-CPnd_sites_notrans_subset}

crun.angsd realSFS fst stats2 $POP1'_'$POP2'.alpha_beta.fst.idx' -win 50000 -step 10000 > $POP1'_'$POP2'.window_fst.txt'
```

Run `fst_window_subset.sbatch`. The script specifies the output directory so you do not have to add the add the `/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor` argument.
```
sbatch fst_window_subset.sbatch
```
JobID: 10706374
2/24/25 @ 19:55

Check output.
```
less angsd_fst_window-10706374.out
```
**Window sizes are too large. 


</details>

<details><summary>9. Generate site frequency spectra for each site/era</summary>

### 9. Generate site frequency spectra for each site/era

Generate a folded site frequency spectrum (SFS) for each population because we did not have a known ancestral state genome. The `angsd_sfs.sbatch` script needs to be run for each population. It uses the `.saf.idx` input files generated in the last step to create an `.sfs` file for each population. These `.sfs` files will be used as an input in the next step to calculate per-site thetas using the `saf2theta` command and the `angsd_theta.sbatch` scripts.

** Albatross
Copy & rename the `angsd_sfs.sbatch` script to fit your Albatross data. 
```
cp /archive/carpenterlab/pire/pire_corythoichthys_haematopterus_lcwgs/ANGSD_Cha/angsd_sfs_apnd_notrans_subset.sbatch ./angsd_sfs_ACeb_notrans_subset.sbatch
```

Edit the `angsd_sfs_ACeb_notrans_subset.sbatch` script to fit the data. 
- Add the Albatross `.saf.idx` input file after the `realSFS` command: `ACeb_sites_notrans_subset.saf.idx`
```
crun.angsd realSFS ACeb_sites_notrans_subset.saf.idx -P 8 -fold 1 > ACeb_sites_notrans_subset.sfs
```

Run & specify outdir. 
```
sbatch angsd_sfs_ACeb_notrans_subset.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706375
2/24/25 @ 20:39

Check output.
```
less angsd_sfs-10706375.out

likelihood: -9537.559565
```

Output file for the next step: Calculate per-site thetas.
```
APnd_sites_notrans_subset.sfs
```

** Contemporary

Copy & rename the `angsd_sfs.sbatch` script to fit your Contemporary data. 
```
cp /archive/carpenterlab/pire/pire_corythoichthys_haematopterus_lcwgs/ANGSD_Cha/angsd_sfs_cpnd_notrans_subset.sbatch ./angsd_sfs_CPnd_notrans_subset.sbatch
```

Edit `angsd_sfs_Pnd_notrans_subset.sbatch` script to fit the data.
- Add the Contemporary `.saf.idx` input file after the `realSFS` command: `CPnd_sites_notrans_subset.saf.idx`
```
crun.angsd realSFS CPnd_sites_notrans_subset.saf.idx -P 8 -fold 1 > CPnd_sites_notrans_subset.sfs
```

Run & specify outdir. 
```
sbatch angsd_sfs_CPnd_notrans_subset.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706376
2/24/25 @ 20:47

Check output.
```
less angsd_sfs-10706376.out

likelihood: -72864.536712
```

Output file for the next step: Calculate per-site thetas.
```
CPnd_sites_notrans_subset.sfs
```

</details>


<details><summary>10. Calculate per-site thetas</summary>

### 10. Calculate per-site thetas

Calculate per-site thetas using the `saf2theta` command and the `angsd_theta.sbatch` scripts.

**Albatross
Input files.
```
APnd_sites_notrans_subset.saf.idx
APnd_sites_notrans_subset.sfs  
```

Copy and rename the `angsd_theta*.sbatch` script to fit your Albatross data.
```
cp /archive/carpenterlab/pire/pire_corythoichthys_haematopterus_lcwgs/ANGSD_Cha/angsd_theta_apnd_notrans_subset.sbatch ./angsd_theta_ACeb_notrans_subset.sbatch 
```

Edit the Albatross `angsd_theta_ACeb_notrans_subset.sbatch ` script. 
- Add the Albatross `.saf.idx` file after the `saf2theta` command: `APnd_sites_notrans_subset.saf.idx`
- Add the Albatross `sfs` file after the `-sfs` prompt: `APnd_sites_notrans_subset.sfs` 
- Edit the `-outname` to reflect your data: `APnd_sites_notrans_subset`
```
crun.angsd realSFS saf2theta ACeb_sites_notrans_subset.saf.idx -sfs ACeb_sites_notrans_subset.sfs -fold 1 -P 8 -outname ACeb_sites_notrans_subset
```

Run the Albatross `angsd_theta_ACeb_notrans_subset.sbatch ` script and specify the output directory.
```
sbatch angsd_theta_ACeb_notrans_subset.sbatch  /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706377 
2/24/25 @ 20:55

Check output.
```
less angsd_theta-10706377.out

Output filenames:
                ->"ACeb_sites_notrans_subset.thetas.gz"
                ->"ACeb_sites_notrans_subset.thetas.idx"
```

**Contemporary
Input files.
```
CPnd_sites_notrans_subset.saf.idx
CPnd_notrans_subset.sfs
```

Copy and rename the `angsd_theta*.sbatch` script to fit your Contemporary data. 
```
cp /archive/carpenterlab/pire/pire_corythoichthys_haematopterus_lcwgs/ANGSD_Cha/angsd_theta_cpnd_notrans_subset.sbatch ./angsd_theta_CPnd_notrans_subset.sbatch 
```

Edit the Contemporary `angsd_theta_CPnd_notrans_subset.sbatch ` script. 
- Add the Contemporary `.saf.idx` file after the `saf2theta` command: `CPnd_sites_notrans_subset.saf.idx`
- Add the Contemporary `sfs` file after the `-sfs` prompt: `CPnd_notrans_subset.sfs` 
- Edit the `-outname` to reflect your data: `CPnd_notrans_subset`
```
crun.angsd realSFS saf2theta CPnd_sites_notrans_subset.saf.idx -sfs CPnd_sites_notrans_subset.sfs -fold 1 -P 8 -outname CPnd_sites_notrans_subset
```

Run the Contemporary `angsd_theta_CPnd_notrans_subset.sbatch ` script and specify the output directory.
```
sbatch angsd_theta_CPnd_notrans_subset.sbatch  /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706378
2/24/25 @ 20:57

Check output.
```
less angsd_theta-10706378.out

Output filenames:
                ->"CPnd_sites_notrans_subset.thetas.gz"
                ->"CPnd_sites_notrans_subset.thetas.idx"
```

</details>


<details><summary>11. Calculate neutrality test statistics</summary>

### 11. Calculate neutrality test statistics

Calculate neutrality test statistics using the `do_stat` command with the `angsd_thetastat.sbatch` script. This script needs to be run for each population. It uses the `.thetas.idx` files generated in the last step. The output `.thetas.idx.pestPG` file is used for statistical analysis in the `geneticdiversity.R` script. Since we are using a folded SFS (unknown ancestral state), we are able to generate Watterson's theta (thetaW), nucleotide diversity (thetaD), and Tajima's D.

**Albatross
Input files.
```
APnd_notrans_subset.thetas.idx
```

Copy and rename the `angsd_thetastat*.sbatch` script. 
```
cp /archive/carpenterlab/pire/pire_corythoichthys_haematopterus_lcwgs/ANGSD_Cha/angsd_thetastat_apnd_notrans_subset.sbatch ./angsd_thetastat_ACeb_notrans_subset.sbatch 
```

Edit the Albatross `angsd_thetastat_ACeb_notrans_subset.sbatch` script. 
- Add the Albatross `.thetas.idx` file after the `do_stat` command: `ACeb_sites_notrans_subset.thetas.idx`
```
crun.angsd thetaStat do_stat ACeb_sites_notrans_subset.thetas.idx
```

Run the Albatross `angsd_thetastat_ACeb_notrans_subset.sbatch ` script and specify the output directory.
```
sbatch angsd_thetastat_ACeb_notrans_subset.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706379
2/24/25 @ 21:04

Check output.
```
less angsd_theta-10706379.out

Dumping file: "ACeb_sites_notrans_subset.thetas.idx.pestPG"
```

**Contemporary
Input files.
```
CPnd_notrans_subset.thetas.idx
```

Copy and rename the `angsd_thetastat*.sbatch` script. 
```
cp /archive/carpenterlab/pire/pire_corythoichthys_haematopterus_lcwgs/ANGSD_Cha/angsd_thetastat_cpnd_notrans_subset.sbatch ./angsd_thetastat_CPnd_notrans_subset.sbatch 
```

Edit the Contemporary `angsd_thetastat_CPnd_notrans_subset.sbatch ` script. 
- Add the Contemporary `.thetas.idx` file after the `do_stat` command: `CPnd_sites_notrans_subset.thetas.idx`
```
crun.angsd thetaStat do_stat CPnd_sites_notrans_subset.thetas.idx
```

Run the Contemporary `angsd_thetastat_CPnd_notrans_subset.sbatch ` script and specify the output directory.
```
sbatch angsd_thetastat_CPnd_notrans_subset.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/ANGSD_Sor
```
JobID: 10706380
2/24/25 @ 21:05

Check output.
```
less angsd_theta-10706380.out

Dumping file: "CPnd_sites_notrans_subset.thetas.idx.pestPG"
```

</details>



# Statistical Analysis in R


<details><summary>13. Calculate Effective Population Size</summary>

### 13. Calculate Effective Population Size

Estimating effective population size (Ne) using Ne_estimation.R and Ne_estimation_neutral.R. Using the .mafs.gz outputs from the "saf_beagle_maf.sbatch" ANGSD script. Code developed from Jorde & Ryman 2007 and the NeEstimator manual v.2.1. Ne_estimation.R is used to generate Ne estimates for the adapted CMH and adapted Chi-squared selection scan tests. Ne_estimation_neutral.R is used to generate Ne estimates from the 1.3 million neutral SNPs. These estimates are reported in our manuscript.

Copy script from Cha.
```
cp /archive/carpenterlab/pire/pire_hypoatherina_temminckii_lcwgs/ANGSD_Hte/Ne_estimation_subset.R ./
```

Create plots directory.
```
mkdir plots
```

Analysis.
```
# MAFS (Minor Allele Frequencies)
apnd_mafs <- fread("ACeb_sites_notrans_subset.mafs.gz", header=TRUE) # 40244 SNPs
cpnd_mafs <- fread("CPnd_sites_notrans_subset.mafs.gz", header=TRUE) # 44118 SNPs

# set minimum minor allele frequency filter. default is 0.001. 
minmaf <- 0.001

# filter by minmaf
all_mafs_001 <- subset(all_mafs, freq1 > minmaf & freq2 > minmaf)
# 7639 SNPs remaining after minmaf

# GenTime as estimated by FishLife is 2.509738 based on family-level estimate
GenTime = 2.509738
Years = 113
Generations = Years/GenTime
# 45.0246201

all_mafs_001[, jrNe2(freq1, freq2, nInd1, nInd2, Generations)] 

boot_pnd <- boot(data = all_mafs_001, statistic = jrNe2boot, R = 1000, gen = Generations) # GenTime = 2.509738 years

# Ne @ t0 = 58.309 at GenTime = 2.509738 years

# 95% Confidence Interval: 55.95, 61.05

# Bias: -0.07250937

# Standard Error: 1.3094
```


</details>

### 14. Change in Genetic Diversity


Analyzing changes in genetic diversity: Watterson's theta, nucleotide diversity (pi), and Tajima's D using the geneticdiversity.R and geneticdiversity_neutral.R scripts.
Using the .thetas.idx.pestPG outputs from ANGSD. Watterson's theta and nucleotide diversity were originally plotted against sequencing depth (mean depth per individual) to evaluate any depth based correlations that may be biasing results. This analysis identified that genetic diversity was sensitive to sequencing depth below 3x or above 6x (Figures S1-S2); we therefore restricted analyses on genetic diversity metrics to the 2,291 contigs with 3-6x depth. The following statistical analyses for all three metrics were run on this 3-6x depth range (452,496 SNPs).

Copy script.
```
cp /archive/carpenterlab/pire/pire_corythoichthys_haematopterus_lcwgs/ANGSD_Cha/geneticdiversity.R ./

apnd_thetas_notrans <- read_table("APnd_notrans_subset.thetas.idx.pestPG")
cpnd_thetas_notrans <- read_table("CPnd_notrans_subset.thetas.idx.pestPG")

angsd_depth_notrans <- read_table("combined_sites_notrans_subset.pos.gz")
```

</details>
