<img src="http://www.fishbiosystem.ru/PERCIFORMES/Apogonidae/Foto/(Sphaeramia%20orbicularis)%2092f.jpg" alt="Sor" width="300"/>

# *Sphaeramia orbicularis* lcWGS Analysis 

## 3rd Sequencing Run

Analysis of low-coverage whole genome sequencing data for *Sphaeramia orbicularis* from Pandanon Island (CPnd). **Only contemporary individuals were re-sequenced for this run.**

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

---
</details>

<details><summary>7. Second trim (*)</summary>

## 7. Second trim (*)
 
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2.sbatch fq_fp1_clmp fq_fp1_clmp_fp2 33
Submitted batch job 4567046
```

### Review the FastQC output (fq_fp1_clmp_fp2/2nd_fastp_report.html):
* Sequence quality before and after filtering looks good
* GC content before and after filtering looks good; some variation between reads 0-10
* N Content looks good after filtering

```
‣ % duplication -
    • Contemp: 0.5 - 2.5%
‣ GC content -
    • Contemp: 38.2 - 40.6%
‣ passing filter -
    • Contemp: 99.5 - 99.7%
‣ % adapter -
    • Contemp: 0.1 - 0.6%
‣ number of reads -
    • Contemp: 0.5 - 33.6 mil
```

---
</details>

<details><summary>8. Decontaminate files (*)</summary>

## 8. Decontaminate files (*)

<details><summary>8a. Run fastq_screen</summary>
	
### 8a. Run fastq_screen

```
[hpc-0373@wahab-01 3rd_sequencing_run]$ bash
[hpc-0373@wahab-01 3rd_sequencing_run]$ fqScrnPATH=/home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash
[hpc-0373@wahab-01 3rd_sequencing_run]$ indir=fq_fp1_clmp_fp2
[hpc-0373@wahab-01 3rd_sequencing_run]$ outdir=/scratch/hpc-0373/fq_fp1_clmp_fp2_fqscrn
[hpc-0373@wahab-01 3rd_sequencing_run]$ nodes=20
[hpc-0373@wahab-01 3rd_sequencing_run]$ bash $fqScrnPATH $indir $outdir $nodes
```
JobID: 4567117

</details>

<details><summary>8b. Check for Errors</summary>
	
### 8b. Check for Errors

```
[hpc-0373@wahab-01 3rd_sequencing_run]$ bash
[hpc-0373@wahab-01 3rd_sequencing_run]$ outdir=/scratch/hpc-0373/fq_fp1_clmp_fp2_fqscrn
[hpc-0373@wahab-01 3rd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/validateFQ.sbatch $outdir "*filter.fastq.gz"
Submitted batch job 4584111
```

When complete check the $outdir/fqValidateReport.txt file
```
less -S $outdir/fqValidationReport.txt file
```

**Confirm files were succesfully completed:**

Check that all 5 files were created for each fqgz file:
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ outdir=/scratch/hpc-0373/fq_fp1_clmp_fp2_fqscrn
[hpc-0373@wahab-01 3rd_sequencing_run]$ ls $outdir/*r1.tagged.fastq.gz | wc -l
					ls $outdir/*r2.tagged.fastq.gz | wc -l
					ls $outdir/*r1.tagged_filter.fastq.gz | wc -l
					ls $outdir/*r2.tagged_filter.fastq.gz | wc -l 
					ls $outdir/*r1_screen.txt | wc -l
					ls $outdir/*r2_screen.txt | wc -l
					ls $outdir/*r1_screen.png | wc -l
					ls $outdir/*r2_screen.png | wc -l
					ls $outdir/*r1_screen.html | wc -l
					ls $outdir/*r2_screen.html | wc -l
48
48
48
48
48
48
48
48
48
48
```
For each, you should have the same number as the number of input files (number of fq.gz files):
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ indir=fq_fp1_clmp_fp2
[hpc-0373@wahab-01 3rd_sequencing_run]$ ls $indir/*r1.fq.gz | wc -l
                                        ls $indir/*r2.fq.gz | wc -l
48
48
```
Check the `*out` files: (no results)
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ grep 'error' slurm-fqscrn.*out
                                        grep 'No reads in' slurm-fqscrn.*out
                                        grep 'FATAL' slurm-fqscrn.*out
```
Check for any unzipped files with the word temp, which means that the job didn't finish and needs to be rerun: 
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ ls $outdir/*temp*
ls: cannot access '/scratch/hpc-0373/fq_fp1_clmp_fp2_fqscrn/*temp*': No such file or directory
```

No errors!

---
</details>

<details><summary>8c. Move output files</summary>

### 8c. Move output files

```
[hpc-0373@wahab-01 3rd_sequencing_run]$ mkdir fq_fp1_clmp_fp2_fqscrn
[hpc-0373@wahab-01 3rd_sequencing_run]$ mv /scratch/hpc-0373/fq_fp1_clmp_fp2_fqscrn/* /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/3rd_sequencing_run/fq_fp1_clmp_fp2_fqscrn
```
Check to see if `/scratch/hpc-0373/fq_fp1_clmp_fp2_fqscrn/` was cleared:
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ ls /scratch/hpc-0373/fq_fp1_clmp_fp2_fqscrn
#nothing printed
```
---
</details>

<details><summary>8d. Run MultiQC (*)</summary>

### 8d. Run MultiQC (*)

```
[hpc-0373@wahab-01 3rd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch fq_fp1_clmp_fp2_fqscrn fastq_screen_report
Submitted batch job 4584112
```
#### Review the MultiQC output (fq_fp1_clmp_fp2_fqscrn/fastq_screen_report.html): 
* No signs of contamination and all samples within expected ranges

```
‣ multiple genomes -
    • Contemp: 2.6 - 3.9%
‣ no hits -
    • Contemp: 94.9 - 96.3%
```
</details>

---

</details>

<details><summary>9. Repair FASTQ Files Messed Up by FASTQ_SCREEN (*)</summary>

## 9. Repair FASTQ Files Messed Up by FASTQ_SCREEN (*)

#### Execute `runREPAIR.sbatch`

Next we need to re-pair our reads. `runREPAIR.sbatch` matches up forward (r1) and reverse (r2) reads so that the `*1.fq.gz` and `*2.fq.gz` files have reads in the same order
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_rprd 5
Submitted batch job 4584138
```

#### Confirm that the paired end fq.gz files are complete and formatted correctly:

Start by running the script:
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ bash
[hpc-0373@wahab-01 3rd_sequencing_run]$ SCRIPT=/home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/validateFQPE.sbatch 
                                        DIR=fq_fp1_clmp_fp2_fqscrn_rprd
                                        fqPATTERN="*fq.gz"
[hpc-0373@wahab-01 3rd_sequencing_run]$ sbatch $SCRIPT $DIR $fqPATTERN
Submitted batch job 4584149
```

Check the SLURM `.out` file and `fqValidationReport.txt` to determine if all of the fqgz files are valid:
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ cat valiate_FQ_-4584149.out
PAIRED END FASTQ VALIDATION REPORT

Directory: fq_fp1_clmp_fp2_fqscrn_rprd
File Pattern: *fq.gz
File extensions found: .R1.fq.gz .R2.fq.gz

Number of paired end fq files evaluated: 48
Number of paired end fq files validated: 48

Errors Reported:
```
#### Run `Multi_FASTQC`
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "./fq_fp1_clmp_fp2_fqscrn_rprd" "fqc_rprd_report" "fq.gz"
Submitted batch job 4584163
```

#### Review MultiQC output (fq_fp1_clmp_fp2_fqscrn_rprd/fqc_rprd_report.html):
* Per Base Sequence Content: 56/96 still have warnings
* Per Sequence GC Content: 3/96 have warnings, but all individuals centered around the same peak ~38%
* All samples had less than 1% of reads made up of overrepresented sequences
* No samples found with any adapter contamination > 0.1%

```
‣ % duplication - 
    • Contemp: 0.5 - 4.9%
‣ GC content -
    • Contemp: 38 - 40%
‣ length -
    • Contemp: 99 - 143 bp
‣ number of reads -
    • Contemp: 0.2 - 15.8 mil
```

---
</details>

<details><summary>10. Clean Up</summary>

## 10. Clean Up

Move any .out files into the logs dir
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ mkdir logs
[hpc-0373@wahab-01 3rd_sequencing_run]$ mv *out logs/
```

---
</details>

<details><summary>11. Map Re-Paired fq.gz to Reference Genome</summary>
<p>

## 11. Map Re-Paired `fq.gz` to Reference Genome

The following steps 11-13 follow steps in the [pire_lcwgs_data_processing repo](https://github.com/philippinespire/pire_lcwgs_data_processing).

### Get your reference genome

Make a new directory `refGenome` and copy the genome from a previous directory:
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ mkdir refGenome
[hpc-0373@wahab-01 3rd_sequencing_run]$ cp ../2nd_sequencing_run/refGenome/GCF_902148855.1_fSphaOr1.1_genomic.fna.gz refGenome
```
### Map your reads to your reference genome

Create a `mkBAM_ddocent` directory and copy all `fq.gz` files from `fq_fp1_clmp_fp2_fqscrn_rprd` into this new directory
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ mkdir mkBAM_ddocent
[hpc-0373@wahab-01 3rd_sequencing_run]$ rsync fq_fp1_clmp_fp2_fqscrn_rprd/*fq.gz mkBAM_ddocent
```
Copy the reference genome to `mkBAM_ddocent`:
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ cp refGenome/GCF_902148855.1_fSphaOr1.1_genomic.fna.gz mkBAM_ddocent/reference.genbank.Sor.fasta
```

Then, copy the scripts we need to run. Typically, these are copied from the `dDocentHPC` directory, which you have to clone to your repo, but I already downloaded and edited them in the last run, so I'll just copy those instead:
```
[hpc-0373@wahab-01 3rd_sequencing_run]$ cp ../2nd_sequencing_run/mkBAM_ddocent/config.6.lcwgs mkBAM_ddocent/.
[hpc-0373@wahab-01 3rd_sequencing_run]$ cp ../2nd_sequencing_run/mkBAM_ddocent/dDocentHPC.sbatch mkBAM_ddocent/.
```
Now, I am able to map my reads.

Execute `dDocentHPC.sbatch mkBAM config.6.lcwgs` which aligns raw sequencing reads (in FASTQ format) to a reference genome and creates BAM files.
```
[hpc-0373@wahab-01 mkBAM_ddocent]$ sbatch dDocentHPC.sbatch mkBAM config.6.lcwgs
Submitted batch job 4584337
```
---

</details>

<details><summary>12. Filter BAM Files</summary>

## 12. Filter BAM Files

Filtering BAM files ensures data quality, reduces noise, improves analysis accuracy, and prepares data for downstream genomic analyses.
```
[hpc-0373@wahab-01 mkBAM_ddocent]$ sbatch dDocentHPC.sbatch fltrBAM config.6.lcwgs
Submitted batch job xxxx
```
---
</details>

<details><summary>13. Generate Number of Mapped Reads</summary>

## 13. Generate Number of Mapped Reads
```
[hpc-0373@wahab-01 3rd_sequencing_run]$  sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/mappedReadStats.sbatch mkBAM_ddocent mkBAM_ddocent/coverageMappedReads
Submitted batch job xxxxxx
```

#### Review Output (coverageMappedReads/out__ReadStats.tsv):
* 

```
‣ numreads:
    • Contemp: 

‣ meanreadlength:
    • Contemp: 

‣ meandepth_wcvg:
    • Contemp: 

‣ numpos:
    • 

‣ numpos_wcvg:
    • Contemp: 

‣ meandepth:
    • Contemp: 

‣ pctpos_wcvg:
     • Contemp: 
```
---

</details>
