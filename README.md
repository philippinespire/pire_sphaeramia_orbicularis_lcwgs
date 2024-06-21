# _Sphaeramia orbicularis_ lcWGS

## 2nd sequencing run
---
Analysis of low-coverage whole genome sequencing data for Sor 2nd_sequencing_run.

fq_gz processing being done by Gianna Mazzei (began 6/20/24).

---

<details><summary>1. fq.gz Pre-processing</summary>
	
## 1. fq.gz Pre-processing
→ (*) _denotes steps with MultiQC Report Analyses_
<details><summary>0. Set-up</summary>
<p>

## 0. Set-up

Began by making a new repo on Github titled "pire_sphareamia_orbicularis_lcwgs" 

Then went to my terminal and cloned the repo
```
[hpc-0356@wahab-01 ~]$ cd /archive/carpenterlab/pire/
[hpc-0356@wahab-01 pire]$ git clone {https://github.com/philippinespire/pire_sphaeramia_orbicularis_lcwgs}
```
Get a .gitignore file from another PIRE species repo and copy it here, then push this file to github.
```
[hpc-0356@wahab-01 pire]$ cd pire_sphaeramia_orbicularis_lcwgs
[hpc-0356@wahab-01 pire_sphaeramia_orbicularis_lcwgs]$ cp ../pire_taeniamia_zosterophora_lcwgs/.gitignore .
[hpc-0356@wahab-01 pire_sphaeramia_orbicularis_lcwgs]$ git pull
[hpc-0356@wahab-01 pire_sphaeramia_orbicularis_lcwgs]$ git add .gitignore
[hpc-0356@wahab-01 pire_sphaeramia_orbicularis_lcwgs]$ git commit -m "add gitignore"
[hpc-0356@wahab-01 pire_sphaeramia_orbicularis_lcwgs]$ git push
```
Make second sequencing run directory
```
[hpc-0356@wahab-01 pire_sphaeramia_orbicularis_lcwgs]$ mkdir 2nd_sequencing_run
```
</p>

---
</details>


<details><summary>1. Get raw data</summary>
<p>

## 1. Get raw data

```

[hpc-0356@wahab-01 pire_sphaeramia_orbicularis_lcwgs]$ cd 2nd_sequencing_run
[hpc-0356@wahab-01 2nd_sequencing_run]$ rsync -r /archive/carpenterlab/pire/downloads/sphaeramia_orbicularis/2nd_sequencing_run_lcwgs/fq_raw 2nd_sequencing_run
```

</p>

---
</details>

<details><summary>2. Proofread the decode file</summary>
<p>

## 2. Proofread the decode file
```
[hpc-0356@wahab-01 fq_raw]$ cat Sor_lcwgs-SeqLane_SequenceNameDecode.tsv
```
Checked that I have sequencing data for all individuals in the decode file
```
[hpc-0356@wahab-01 fq_raw]$ ls *1.fq.gz | wc -l 
142
[hpc-0356@wahab-01 fq_raw]$ ls *2.fq.gz | wc -l
142
```
Number of lines:
```
[hpc-0356@wahab-01 fq_raw]$ wc -l Sor_lcwgs-SeqLane_SequenceNameDecode.tsv
71 Sor_lcwgs-SeqLane_SequenceNameDecode.tsv
```
Are there duplicates?
```
[hpc-0356@wahab-01 fq_raw]$ cat Sor_lcwgs-SeqLane_SequenceNameDecode.tsv| sort | uniq | wc -l
71
```
***Skip steps 3 and 4***

</p>

---
</details>

<details><summary>5. Perform a renaming dry run</summary>
<p>

## 5. Perform a renaming dry run

```
[hpc-0356@wahab-01 fq_raw]$ salloc
[hpc-0356@d1-w6420a-24 fq_raw]$ bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Sor_lcwgs-SeqLane_SequenceNameDecode.tsv
```

</p>

---
</details>

<details><summary>6. Rename the files</summary>

## 6. Rename the files
```
[hpc-0356@d1-w6420a-24 fq_raw]$ bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Sor_lcwgs-SeqLane_SequenceNameDecode.tsv rename
```
---
</details>

<details><summary>7. Check the quality of raw data (*)</summary>
<p>

## 7. Check the quality of raw data (*)

Executed `Multi_FASTQC.sh` 

```
[hpc-0356@d1-w6420a-24 2nd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_raw" "fqc_raw_report"  "fq.gz"
```

### MultiQC output (fq_raw/fastqc_report.html):
*
*

```  
‣ % duplication - 
	• Alb: 
 	• Contemp: 
‣ GC content - 
	• Alb: 
 	• Contemp: 
‣ number of reads - 
	• Alb: 
 	• Contemp: 
```
<details><summary>* Multi_FASTQC Report:</summary>
<p>
  
```
{results}
```
  
</p>
</details>

</p>

---
</details>

<details><summary>8. First trim (*)</summary>
<p>

## 8. First trim (*)
```
[hpc-0356@d1-w6420a-24 2nd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_1st_trim.sbatch fq_raw fq_fp1
```

### Review the FastQC output (fq_fp1/1st_fastp_report.html):
After 1st trim:
*  
*  

```  
‣ % duplication - 
    	• Alb: 
	• Contemp: 
‣ GC content -
    	• Alb: 
	• Contemp: 
‣ passing filter - 
    	• Alb: 
     	• Contemp: 
‣ % adapter - 
    	• Alb: 
     	• Contemp: 
‣ number of reads - 
    	• Alb: 
     	• Contemp: 
```
<details><summary>* 1st FASTP Report:</summary>
<p>
  
```
{results}
```

</p>
</details>

</p>

---
</details>

<details><summary>9. Remove duplicates with clumpify</summary>
<p>

## 9. Remove duplicates with clumpify
