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
*

```
‣ % duplication - 
    • Alb: 
    • Contemp: 
    • Undertermined: 
‣ GC content - 
    • Alb: 
    • Contemp: 
    • Undetermined: 
‣ number of reads - 
    • Alb: 
    • Contemp: 
    • Undetermined: 
```
---
</details>

