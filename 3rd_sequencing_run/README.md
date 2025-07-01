<img src="http://www.fishbiosystem.ru/PERCIFORMES/Apogonidae/Foto/(Sphaeramia%20orbicularis)%2092f.jpg" alt="Sor" width="300"/>

# *Sphaeramia orbicularis* lcWGS Analysis 

## 3rd Sequencing Run

Analysis of low-coverage whole genome sequencing data for *Sphaeramia orbicularis* from Pandanon Island (CPnd). Only contemporary individuals were re-sequenced for this run.

fq.gz processing done by Gianna Mazzei (June 2025).

---
	
## fq.gz Pre-processing

This portion follows the instructions on [this repo](https://github.com/philippinespire/pire_fq_gz_processing).

→ (*) _denotes steps with MultiQC Report Analyses_
<details><summary>0. Set-up</summary>

## 0. Set-up

Make 3rd sequencing run directory
```
[hpc-0373@wahab-01 pire_sphaeramia_orbicularis_lcwgs]$ mkdir 3rd_sequencing_run
```

---
</details>

<details><summary>1. Get raw data</summary>

## 1. Get raw data

```
[hpc-0373@wahab-01 pire_sphaeramia_orbicularis_lcwgs]$ cp -r /archive/carpenterlab/pire/downloads/sphaeramia_orbicularis/3rd_sequencing_run/fq_raw 3rd_sequencing_run
```
There was only a decode file in this directory. I found the sequencing data here:
```
[hpc-0373@wahab-01 pire_sphaeramia_orbicularis_lcwgs]$ cp -r /archive/carpenterlab/pire/downloads/20250507_PIRE-lcwgs/. 3rd_sequencing_run
```

---
</details>

<details><summary>2. Proofread the decode file</summary>

## 2. Proofread the decode file

```
[hpc-0373@wahab-01 fq_raw]$ cat Sor_lcwgs-CPndReseq_SequenceNameDecode.tsv
```
Checked that I have sequencing data for all individuals in the decode file
```
[hpc-0373@wahab-01 fq_raw]$ ls *1.fq.gz | wc -l
48
[hpc-0373@wahab-01 fq_raw]$ ls *2.fq.gz | wc -l
48
```
Number of lines (there's a line for col names):
```
[hpc-0373@wahab-01 fq_raw]$ wc -l Sor_lcwgs-CPndReseq_SequenceNameDecode.tsv
49 
```
Are there duplicates? No
```
[hpc-0373@wahab-01 fq_raw]$ cat Sor_lcwgs-CPndReseq_SequenceNameDecode.tsv | sort | uniq | wc -l
49
```
---
</details>

<details><summary>3. Rename raw files</summary>

## 3. Rename raw files

First, perform a renaming dry run.
```
[hpc-0373@wahab-01 fq_raw]$ salloc
[hpc-0373@e3-w6420b-01 fq_raw]$ bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Sor_lcwgs-CPndReseq_SequenceNameDecode.tsv
```
Looks good.

Now, rename for real.
```
[hpc-0373@e3-w6420b-01 fq_raw]$ bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Sor_lcwgs-CPndReseq_SequenceNameDecode.tsv rename
```
---
</details>


<details><summary>4. Check the quality of raw data (*)</summary>

## 4. Check the quality of raw data (*)

Execute `Multi_FASTQC.sh`:
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_raw" "fqc_raw_report"  "fq.gz"
Submitted batch job 4457961
```

### MultiQC output (fq_raw/fqc_raw_report.html):
* 81/96 failing Per Base Sequence Content
* Per Sequence GC Content- uniform peak around 41%
* High adapter content

```
‣ % duplication - 
    • Contemp: 5.2 - 17.7%
‣ GC content - 
    • Contemp: 40 - 48%
‣ number of reads - 
    • Contemp: 0.3 - 20.0 mil
```
---
</details>

<details><summary>5. First trim (*)</summary>

## 5. First trim (*)

Run `runFASTP_1st_trim.sbatch`:
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch fq_raw fq_fp1
Submitted batch job 4458905
```
### Review the FastQC output (fq_fp1/1st_fastp_report.html):
* Graph of average sequencing quality over each base of all reads evened out after filtering
* GC content graph good after filtering- some stochasticity between read positions 0-10; no outliers

```
‣ % duplication - 
    • Contemp: 4.7 - 17.3%
‣ GC content -
    • Contemp: 38.3 - 40.6%
‣ passing filter - 
    • Contemp: 90.0 - 98.6%
‣ % adapter - 
    • Contemp: 17.1 - 74.3%
‣ number of reads - 
    • Contemp: 0.5 - 39.2 mil
```
---
</details>

<details><summary>6. Remove duplicates with clumpify (*)</summary>

## 6. Remove duplicates with clumpify (*)

<details><summary>6a. Remove duplicates</summary>
	
### 6a. Remove duplicates

```
[hpc-0373@wahab-01 3rd_sequencing_run]$ bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/hpc-0373 20
Submitted batch job 4459984
```
</details>

<details><summary>6b. Check duplicate removal success</summary>
	
### 6b. Check duplicate removal success

Check if clumpify worked:
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ salloc
[hpc-0373@d1-w6420a-16 3rd_sequencing_run]$ enable_lmod
[hpc-0373@d1-w6420a-16 3rd_sequencing_run]$ module load container_env R/4.3 
[hpc-0373@d1-w6420a-16 3rd_sequencing_run]$ crun R < /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/checkClumpify_EG.R --no-save

Clumpify Successfully worked on all samples

[hpc-0373@d1-w6420a-16 3rd_sequencing_run]$ exit
```
</details> 

<details><summary>6c. Clean the scratch drive</summary>
	
### 6c. Clean the scratch drive
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/cleanSCRATCH.sbatch /scratch/hpc-0373 "*clumpify*temp*"
Submitted batch job 4464959
```

Check:
```
ls /scratch/hpc-0373/fq_fp1_clmp_fp2_fqscrn/
```
Nothing printed, so its cleared.

</details>

<details><summary>6d. Generate metadata on deduplicated FASTQ files (*)</summary>

### 6d. Generate metadata on deduplicated FASTQ files (*)
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_fp1_clmp" "fqc_clmp_report"  "fq.gz"
Submitted batch job 4464960
```

**Results** (fq_fp1_clmp/fqc_clmp_report.html): 
* Per Base Sequence Content: 67/96 have warnings
* Per Sequence GC Content: 1 sample has a warning (Sor-CPnd_016)
* No samples found with any adapter contamination > 0.1%

```
‣ % duplication - 
    • Contemp: 0.6 - 5.3%
‣ GC content - 
    • Contemp: 38 - 40%
‣ length - 
    • Contemp: 99 - 144 bp
‣ number of reads -
    • Contemp: 0.3 - 16.9 mil
```
</details>
