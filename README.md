# _Sphaeramia orbicularis_ lcWGS

## 2nd sequencing run
---
Analysis of low-coverage whole genome sequencing data for Sor 2nd_sequencing_run.

fq_gz processing being done by Gianna Mazzei (started 6/20/24).

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

### MultiQC output (fq_raw/fqc_raw_report.html):
* "Undetermined" read count is 317.9 mil
	* All other reads are between 0-4.6 mil
	* Potential problem with demultiplexing -> (TBD) reached out to Sharon 
* GC content is higher on average for albatross samples
* Smaller secondary peak around 62% for Per Sequence GC Content
* High adapter content


```  
‣ % duplication - 
	• Alb: 6.2 - 24.5%
 	• Contemp: 10.3 - 33.2%
	• Undertermined: 28.1 - 30.5%
‣ GC content - 
	• Alb: 45 - 54%
 	• Contemp: 39 - 46%
	• Undetermined: 41 - 42%
‣ number of reads - 
	• Alb: 0 - 0.9 mil
 	• Contemp: 0.4 - 4.6 mil
	• Undetermined: 317.9 mil
```
<details><summary>* Multi_FASTQC Report:</summary>
<p>
  
```
Sample Name				% Dups	% GC	M Seqs
Sor-ACeb_001-Ex1-8E-lcwgs-1-2.1		13.1%	42%	0.9
Sor-ACeb_001-Ex1-8E-lcwgs-1-2.2		14.0%	43%	0.9
Sor-ACeb_002-Ex1-9E-lcwgs-1-2.1		21.0%	48%	0.1
Sor-ACeb_002-Ex1-9E-lcwgs-1-2.2		22.0%	50%	0.1
Sor-ACeb_003-Ex1-10E-lcwgs-1-2.1	8.8%	45%	0.3
Sor-ACeb_003-Ex1-10E-lcwgs-1-2.2	9.8%	47%	0.3
Sor-ACeb_004-Ex1-11E-lcwgs-1-2.1	19.5%	50%	0.3
Sor-ACeb_004-Ex1-11E-lcwgs-1-2.2	20.0%	52%	0.3
Sor-ACeb_005-Ex1-12E-lcwgs-1-2.1	18.5%	48%	0.1
Sor-ACeb_005-Ex1-12E-lcwgs-1-2.2	19.8%	51%	0.1
Sor-ACeb_006-Ex1-1F-lcwgs-1-2.1		11.8%	47%	0.0
Sor-ACeb_006-Ex1-1F-lcwgs-1-2.2		13.1%	48%	0.0
Sor-ACeb_007-Ex1-2F-lcwgs-1-2.1		11.4%	47%	0.0
Sor-ACeb_007-Ex1-2F-lcwgs-1-2.2		12.7%	48%	0.0
Sor-ACeb_008-Ex1-3F-lcwgs-1-2.1		10.2%	46%	0.0
Sor-ACeb_008-Ex1-3F-lcwgs-1-2.2		11.4%	47%	0.0
Sor-ACeb_009-Ex1-4F-lcwgs-1-2.1		9.1%	47%	0.0
Sor-ACeb_009-Ex1-4F-lcwgs-1-2.2		10.6%	48%	0.0
Sor-ACeb_010-Ex1-5F-lcwgs-1-2.1		13.7%	46%	0.1
Sor-ACeb_010-Ex1-5F-lcwgs-1-2.2		14.7%	48%	0.1
Sor-ACeb_011-Ex1-6F-lcwgs-1-2.1		17.9%	47%	0.0
Sor-ACeb_011-Ex1-6F-lcwgs-1-2.2		19.7%	49%	0.0
Sor-ACeb_012-Ex1-7F-lcwgs-1-2.1		15.5%	45%	0.1
Sor-ACeb_012-Ex1-7F-lcwgs-1-2.2		16.2%	46%	0.1
Sor-ACeb_013-Ex1-8F-lcwgs-1-2.1		19.5%	49%	0.1
Sor-ACeb_013-Ex1-8F-lcwgs-1-2.2		21.1%	50%	0.1
Sor-ACeb_014-Ex1-9F-lcwgs-1-2.1		14.8%	47%	0.0
Sor-ACeb_014-Ex1-9F-lcwgs-1-2.2		15.8%	48%	0.0
Sor-ACeb_015-Ex1-10F-lcwgs-1-2.1	14.7%	45%	0.1
Sor-ACeb_015-Ex1-10F-lcwgs-1-2.2	15.9%	47%	0.1
Sor-ACeb_016-Ex1-11F-lcwgs-1-2.1	19.4%	51%	0.4
Sor-ACeb_016-Ex1-11F-lcwgs-1-2.2	19.7%	54%	0.4
Sor-ACeb_017-Ex1-12F-lcwgs-1-2.1	24.1%	49%	0.3
Sor-ACeb_017-Ex1-12F-lcwgs-1-2.2	24.5%	54%	0.3
Sor-ACeb_018-Ex1-1G-lcwgs-1-2.1		11.4%	44%	0.1
Sor-ACeb_018-Ex1-1G-lcwgs-1-2.2		12.9%	45%	0.1
Sor-ACeb_019-Ex1-3G-lcwgs-1-2.1		7.7%	43%	0.0
Sor-ACeb_019-Ex1-3G-lcwgs-1-2.2		9.4%	44%	0.0
Sor-ACeb_020-Ex1-2G-lcwgs-1-2.1		8.3%	44%	0.0
Sor-ACeb_020-Ex1-2G-lcwgs-1-2.2		10.2%	45%	0.0
Sor-ACeb_021-Ex1-4G-lcwgs-1-2.1		6.2%	45%	0.0
Sor-ACeb_021-Ex1-4G-lcwgs-1-2.2		9.1%	46%	0.0
Sor-ACeb_022-Ex1-5G-lcwgs-1-2.1		14.1%	47%	0.0
Sor-ACeb_022-Ex1-5G-lcwgs-1-2.2		15.6%	49%	0.0
Sor-CPnd_001-Ex1-3E-lcwgs-1-2.1		14.9%	42%	1.5
Sor-CPnd_001-Ex1-3E-lcwgs-1-2.2		16.4%	42%	1.5
Sor-CPnd_002-Ex1-5E-lcwgs-1-2.1		11.1%	43%	0.9
Sor-CPnd_002-Ex1-5E-lcwgs-1-2.2		12.4%	44%	0.9
Sor-CPnd_003-Ex1-2B-lcwgs-1-2.1		12.2%	42%	0.7
Sor-CPnd_003-Ex1-2B-lcwgs-1-2.2		13.8%	43%	0.7
Sor-CPnd_004-Ex1-1G-lcwgs-1-2.1		14.9%	42%	2.1
Sor-CPnd_004-Ex1-1G-lcwgs-1-2.2		16.3%	42%	2.1
Sor-CPnd_005-Ex1-3D-lcwgs-1-2.1		19.6%	40%	1.5
Sor-CPnd_005-Ex1-3D-lcwgs-1-2.2		21.6%	41%	1.5
Sor-CPnd_006-Ex1-2D-lcwgs-1-2.1		12.6%	43%	1.4
Sor-CPnd_006-Ex1-2D-lcwgs-1-2.2		14.1%	43%	1.4
Sor-CPnd_007-Ex1-1C-lcwgs-1-2.1		13.9%	43%	0.8
Sor-CPnd_007-Ex1-1C-lcwgs-1-2.2		15.9%	43%	0.8
Sor-CPnd_008-Ex1-1A-lcwgs-1-2.1		28.7%	39%	3.7
Sor-CPnd_008-Ex1-1A-lcwgs-1-2.2		33.2%	40%	3.7
Sor-CPnd_009-Ex1-6A-lcwgs-1-2.1		22.0%	41%	3.3
Sor-CPnd_009-Ex1-6A-lcwgs-1-2.2		24.2%	42%	3.3
Sor-CPnd_010-Ex1-1H-lcwgs-1-2.1		10.3%	42%	0.5
Sor-CPnd_010-Ex1-1H-lcwgs-1-2.2		12.0%	42%	0.5
Sor-CPnd_012-Ex1-5B-lcwgs-1-2.1		14.2%	42%	0.5
Sor-CPnd_012-Ex1-5B-lcwgs-1-2.2		15.7%	44%	0.5
Sor-CPnd_013-Ex1-7F-lcwgs-1-2.1		10.8%	43%	0.8
Sor-CPnd_013-Ex1-7F-lcwgs-1-2.2		12.7%	43%	0.8
Sor-CPnd_014-Ex1-1F-lcwgs-1-2.1		15.9%	42%	4.6
Sor-CPnd_014-Ex1-1F-lcwgs-1-2.2		17.3%	42%	4.6
Sor-CPnd_015-Ex1-5F-lcwgs-1-2.1		10.9%	44%	0.5
Sor-CPnd_015-Ex1-5F-lcwgs-1-2.2		12.4%	45%	0.5
Sor-CPnd_016-Ex1-1B-lcwgs-1-2.1		23.2%	40%	1.5
Sor-CPnd_016-Ex1-1B-lcwgs-1-2.2		26.0%	41%	1.5
Sor-CPnd_017-Ex1-3G-lcwgs-1-2.1		11.1%	42%	0.6
Sor-CPnd_017-Ex1-3G-lcwgs-1-2.2		12.6%	42%	0.6
Sor-CPnd_018-Ex1-1E-lcwgs-1-2.1		14.0%	43%	2.2
Sor-CPnd_018-Ex1-1E-lcwgs-1-2.2		15.6%	43%	2.2
Sor-CPnd_019-Ex1-6G-lcwgs-1-2.1		18.6%	42%	1.4
Sor-CPnd_019-Ex1-6G-lcwgs-1-2.2		20.3%	43%	1.4
Sor-CPnd_020-Ex1-2E-lcwgs-1-2.1		14.3%	41%	1.6
Sor-CPnd_020-Ex1-2E-lcwgs-1-2.2		15.8%	42%	1.6
Sor-CPnd_022-Ex1-7C-lcwgs-1-2.1		19.9%	42%	1.6
Sor-CPnd_022-Ex1-7C-lcwgs-1-2.2		22.0%	43%	1.6
Sor-CPnd_024-Ex1-5G-lcwgs-1-2.1		11.0%	43%	0.4
Sor-CPnd_024-Ex1-5G-lcwgs-1-2.2		12.3%	44%	0.4
Sor-CPnd_026-Ex1-3H-lcwgs-1-2.1		14.8%	41%	0.7
Sor-CPnd_026-Ex1-3H-lcwgs-1-2.2		16.7%	41%	0.7
Sor-CPnd_027-Ex1-3C-lcwgs-1-2.1		19.9%	40%	1.3
Sor-CPnd_027-Ex1-3C-lcwgs-1-2.2		22.1%	41%	1.3
Sor-CPnd_028-Ex1-3A-lcwgs-1-2.1		20.5%	41%	1.7
Sor-CPnd_028-Ex1-3A-lcwgs-1-2.2		22.7%	41%	1.7
Sor-CPnd_029-Ex1-8E-lcwgs-1-2.1		18.6%	42%	2.4
Sor-CPnd_029-Ex1-8E-lcwgs-1-2.2		20.6%	42%	2.4
Sor-CPnd_030-Ex1-2H-lcwgs-1-2.1		11.8%	42%	0.8
Sor-CPnd_030-Ex1-2H-lcwgs-1-2.2		13.2%	43%	0.8
Sor-CPnd_031-Ex1-5D-lcwgs-1-2.1		15.5%	41%	1.1
Sor-CPnd_031-Ex1-5D-lcwgs-1-2.2		17.5%	42%	1.1
Sor-CPnd_033-Ex1-2F-lcwgs-1-2.1		11.2%	42%	0.7
Sor-CPnd_033-Ex1-2F-lcwgs-1-2.2		12.7%	42%	0.7
Sor-CPnd_034-Ex1-4G-lcwgs-1-2.1		11.9%	44%	0.4
Sor-CPnd_034-Ex1-4G-lcwgs-1-2.2		13.0%	45%	0.4
Sor-CPnd_036-Ex1-5C-lcwgs-1-2.1		16.0%	42%	1.1
Sor-CPnd_036-Ex1-5C-lcwgs-1-2.2		17.7%	44%	1.1
Sor-CPnd_037-Ex1-6C-lcwgs-1-2.1		25.8%	42%	1.5
Sor-CPnd_037-Ex1-6C-lcwgs-1-2.2		27.8%	45%	1.5
Sor-CPnd_038-Ex1-2A-lcwgs-1-2.1		17.7%	41%	1.1
Sor-CPnd_038-Ex1-2A-lcwgs-1-2.2		20.0%	41%	1.1
Sor-CPnd_041-Ex1-7A-lcwgs-1-2.1		15.5%	43%	1.8
Sor-CPnd_041-Ex1-7A-lcwgs-1-2.2		17.2%	43%	1.8
Sor-CPnd_043-Ex1-1D-lcwgs-1-2.1		18.3%	41%	2.2
Sor-CPnd_043-Ex1-1D-lcwgs-1-2.2		20.3%	41%	2.2
Sor-CPnd_044-Ex1-8G-lcwgs-1-2.1		15.2%	43%	1.3
Sor-CPnd_044-Ex1-8G-lcwgs-1-2.2		16.6%	43%	1.3
Sor-CPnd_045-Ex1-7B-lcwgs-1-2.1		20.9%	41%	1.8
Sor-CPnd_045-Ex1-7B-lcwgs-1-2.2		23.1%	42%	1.8
Sor-CPnd_046-Ex1-5A-lcwgs-1-2.1		15.4%	44%	0.5
Sor-CPnd_046-Ex1-5A-lcwgs-1-2.2		17.1%	46%	0.5
Sor-CPnd_049-Ex1-3B-lcwgs-1-2.1		13.2%	41%	0.5
Sor-CPnd_049-Ex1-3B-lcwgs-1-2.2		15.0%	42%	0.5
Sor-CPnd_050-Ex1-3F-lcwgs-1-2.1		16.8%	42%	2.0
Sor-CPnd_050-Ex1-3F-lcwgs-1-2.2		18.6%	42%	2.0
Sor-CPnd_052-Ex1-6D-lcwgs-1-2.1		13.8%	42%	1.0
Sor-CPnd_052-Ex1-6D-lcwgs-1-2.2		15.5%	43%	1.0
Sor-CPnd_053-Ex1-2C-lcwgs-1-2.1		15.9%	41%	1.0
Sor-CPnd_053-Ex1-2C-lcwgs-1-2.2		18.0%	42%	1.0
Sor-CPnd_054-Ex1-8F-lcwgs-1-2.1		10.7%	45%	0.5
Sor-CPnd_054-Ex1-8F-lcwgs-1-2.2		12.2%	46%	0.5
Sor-CPnd_055-Ex1-7G-lcwgs-1-2.1		14.9%	43%	1.3
Sor-CPnd_055-Ex1-7G-lcwgs-1-2.2		16.4%	43%	1.3
Sor-CPnd_058-Ex1-2G-lcwgs-1-2.1		10.5%	42%	0.7
Sor-CPnd_058-Ex1-2G-lcwgs-1-2.2		11.8%	42%	0.7
Sor-CPnd_063-Ex1-7D-lcwgs-1-2.1		14.2%	43%	1.3
Sor-CPnd_063-Ex1-7D-lcwgs-1-2.2		15.8%	43%	1.3
Sor-CPnd_066-Ex1-8B-lcwgs-1-2.1		17.2%	42%	0.9
Sor-CPnd_066-Ex1-8B-lcwgs-1-2.2		19.1%	43%	0.9
Sor-CPnd_069-Ex1-6B-lcwgs-1-2.1		22.3%	41%	1.2
Sor-CPnd_069-Ex1-6B-lcwgs-1-2.2		24.5%	43%	1.2
Sor-CPnd_072-Ex1-8C-lcwgs-1-2.1		25.0%	41%	2.7
Sor-CPnd_072-Ex1-8C-lcwgs-1-2.2		27.9%	42%	2.7

Undetermined.1				28.1%	41%	317.9
Undetermined.2				30.5%	42%	317.9
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
*  High % adapter levels for Albatross samples, more variable for Contemporary
*  Low number of reads, besides the undertermined sample

```  
‣ % duplication - 
    	• Alb: 5-15.9%
	• Contemp: 9.2-32.9%
	• Undetermined: 19.5%	
‣ GC content -
    	• Alb: 32.7-45%
	• Contemp: 37-39%
	• Undetermined: 37.9%	
‣ passing filter - 
    	• Alb: 83.8-96%
     	• Contemp: 91.9-97.4%
	• Undetermined: 95.7%	
‣ % adapter - 
    	• Alb: 61.8-96.3%
     	• Contemp: 17.2-71.8%
	• Undetermined: 54.4%
‣ number of reads - 
    	• Alb: 0-1.6 mil
     	• Contemp: 0.8-9 mil
	• Undetermined: 635.8 mil
```
<details><summary>* 1st FASTP Report:</summary>
<p>
  
```
Sample Name	      % Duplication  GC content  % PF	% Adapter
Sor-ACeb_001-Ex1-8E-lcwgs-1-2	8.3%	32.7%	94.8%	90.2%
Sor-ACeb_002-Ex1-9E-lcwgs-1-2	9.7%	38.7%	89.3%	83.1%
Sor-ACeb_003-Ex1-10E-lcwgs-1-2	7.7%	35.7%	96.0%	96.3%
Sor-ACeb_004-Ex1-11E-lcwgs-1-2	6.6%	36.7%	86.8%	92.2%
Sor-ACeb_005-Ex1-12E-lcwgs-1-2	11.4%	42.4%	89.9%	75.6%
Sor-ACeb_006-Ex1-1F-lcwgs-1-2	7.0%	39.1%	92.6%	83.3%
Sor-ACeb_007-Ex1-2F-lcwgs-1-2	6.5%	38.2%	91.1%	81.9%
Sor-ACeb_008-Ex1-3F-lcwgs-1-2	7.3%	36.1%	93.7%	89.4%
Sor-ACeb_009-Ex1-4F-lcwgs-1-2	6.9%	36.2%	93.6%	94.3%
Sor-ACeb_010-Ex1-5F-lcwgs-1-2	8.4%	38.4%	92.5%	89.3%
Sor-ACeb_011-Ex1-6F-lcwgs-1-2	14.8%	43.9%	93.6%	62.2%
Sor-ACeb_012-Ex1-7F-lcwgs-1-2	7.9%	36.1%	93.5%	90.7%
Sor-ACeb_013-Ex1-8F-lcwgs-1-2	15.9%	45.1%	93.6%	61.8%
Sor-ACeb_014-Ex1-9F-lcwgs-1-2	10.9%	39.7%	93.4%	82.6%
Sor-ACeb_015-Ex1-10F-lcwgs-1-2	9.3%	37.6%	92.3%	88.5%
Sor-ACeb_016-Ex1-11F-lcwgs-1-2	6.5%	39.5%	85.9%	91.3%
Sor-ACeb_017-Ex1-12F-lcwgs-1-2	9.3%	38.9%	83.8%	86.6%
Sor-ACeb_018-Ex1-1G-lcwgs-1-2	8.2%	37.5%	94.7%	82.0%
Sor-ACeb_019-Ex1-3G-lcwgs-1-2	5.7%	36.5%	94.6%	77.1%
Sor-ACeb_020-Ex1-2G-lcwgs-1-2	6.0%	36.9%	93.2%	78.9%
Sor-ACeb_021-Ex1-4G-lcwgs-1-2	5.0%	36.4%	93.5%	86.8%
Sor-ACeb_022-Ex1-5G-lcwgs-1-2	11.5%	43.5%	93.3%	70.9%
Sor-CPnd_001-Ex1-3E-lcwgs-1-2	13.0%	37.7%	96.7%	65.6%
Sor-CPnd_002-Ex1-5E-lcwgs-1-2	11.5%	38.4%	95.9%	71.8%
Sor-CPnd_003-Ex1-2B-lcwgs-1-2	14.5%	38.6%	96.6%	57.9%
Sor-CPnd_004-Ex1-1G-lcwgs-1-2	11.5%	38.0%	97.1%	64.6%
Sor-CPnd_005-Ex1-3D-lcwgs-1-2	18.0%	38.0%	96.9%	43.3%
Sor-CPnd_006-Ex1-2D-lcwgs-1-2	14.1%	38.2%	96.4%	62.2%
Sor-CPnd_007-Ex1-1C-lcwgs-1-2	13.4%	39.3%	96.2%	55.2%
Sor-CPnd_008-Ex1-1A-lcwgs-1-2	32.9%	38.5%	96.4%	17.2%
Sor-CPnd_009-Ex1-6A-lcwgs-1-2	22.8%	38.8%	96.6%	47.6%
Sor-CPnd_010-Ex1-1H-lcwgs-1-2	10.9%	38.1%	96.9%	60.8%
Sor-CPnd_012-Ex1-5B-lcwgs-1-2	15.0%	38.5%	95.1%	56.9%
Sor-CPnd_013-Ex1-7F-lcwgs-1-2	12.1%	37.8%	96.0%	61.6%
Sor-CPnd_014-Ex1-1F-lcwgs-1-2	14.8%	38.3%	97.4%	58.1%
Sor-CPnd_015-Ex1-5F-lcwgs-1-2	10.8%	38.7%	94.6%	69.1%
Sor-CPnd_016-Ex1-1B-lcwgs-1-2	21.3%	38.5%	96.4%	29.3%
Sor-CPnd_017-Ex1-3G-lcwgs-1-2	10.8%	37.5%	96.6%	67.0%
Sor-CPnd_018-Ex1-1E-lcwgs-1-2	13.2%	38.3%	97.1%	63.8%
Sor-CPnd_019-Ex1-6G-lcwgs-1-2	16.5%	38.3%	96.2%	58.4%
Sor-CPnd_020-Ex1-2E-lcwgs-1-2	15.7%	37.7%	96.5%	57.8%
Sor-CPnd_022-Ex1-7C-lcwgs-1-2	17.6%	37.9%	95.7%	51.2%
Sor-CPnd_024-Ex1-5G-lcwgs-1-2	11.2%	38.1%	95.5%	67.8%
Sor-CPnd_026-Ex1-3H-lcwgs-1-2	16.0%	37.9%	97.0%	52.2%
Sor-CPnd_027-Ex1-3C-lcwgs-1-2	20.1%	38.1%	96.9%	41.1%
Sor-CPnd_028-Ex1-3A-lcwgs-1-2	19.8%	38.2%	96.5%	45.0%
Sor-CPnd_029-Ex1-8E-lcwgs-1-2	15.7%	37.4%	96.0%	57.8%
Sor-CPnd_030-Ex1-2H-lcwgs-1-2	13.5%	38.1%	96.6%	63.5%
Sor-CPnd_031-Ex1-5D-lcwgs-1-2	17.5%	38.2%	96.6%	51.2%
Sor-CPnd_033-Ex1-2F-lcwgs-1-2	12.5%	37.6%	96.2%	61.5%
Sor-CPnd_034-Ex1-4G-lcwgs-1-2	11.8%	38.5%	95.5%	71.0%
Sor-CPnd_036-Ex1-5C-lcwgs-1-2	16.2%	37.9%	94.9%	59.3%
Sor-CPnd_037-Ex1-6C-lcwgs-1-2	20.3%	38.1%	92.0%	51.3%
Sor-CPnd_038-Ex1-2A-lcwgs-1-2	21.4%	38.1%	96.4%	41.4%
Sor-CPnd_041-Ex1-7A-lcwgs-1-2	13.2%	39.0%	95.9%	63.8%
Sor-CPnd_043-Ex1-1D-lcwgs-1-2	15.7%	38.1%	96.9%	49.3%
Sor-CPnd_044-Ex1-8G-lcwgs-1-2	13.1%	37.7%	95.4%	61.7%
Sor-CPnd_045-Ex1-7B-lcwgs-1-2	18.5%	38.2%	96.1%	43.8%
Sor-CPnd_046-Ex1-5A-lcwgs-1-2	12.3%	38.4%	91.9%	65.9%
Sor-CPnd_049-Ex1-3B-lcwgs-1-2	14.2%	38.1%	96.9%	55.8%
Sor-CPnd_050-Ex1-3F-lcwgs-1-2	14.5%	38.1%	96.8%	58.7%
Sor-CPnd_052-Ex1-6D-lcwgs-1-2	12.7%	37.5%	95.7%	68.8%
Sor-CPnd_053-Ex1-2C-lcwgs-1-2	18.8%	38.2%	96.2%	48.7%
Sor-CPnd_054-Ex1-8F-lcwgs-1-2	9.2%	38.2%	94.1%	71.4%
Sor-CPnd_055-Ex1-7G-lcwgs-1-2	11.1%	37.3%	95.3%	67.0%
Sor-CPnd_058-Ex1-2G-lcwgs-1-2	11.4%	37.2%	96.3%	67.1%
Sor-CPnd_063-Ex1-7D-lcwgs-1-2	12.2%	37.8%	96.1%	64.0%
Sor-CPnd_066-Ex1-8B-lcwgs-1-2	16.8%	38.2%	95.0%	48.9%
Sor-CPnd_069-Ex1-6B-lcwgs-1-2	21.6%	38.5%	95.0%	44.7%
Sor-CPnd_072-Ex1-8C-lcwgs-1-2	23.4%	38.2%	95.6%	37.1%

Undetermined			19.5%	37.9%	95.7%	54.4%
```

</p>
</details>

</p>

---
</details>

<details><summary>9. Remove duplicates with clumpify (*)</summary>
<p>

## 9. Remove duplicates with clumpify (*)

### 9a. Remove duplicates
```
[hpc-0356@wahab-01 2nd_sequencing_run]$ bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/hpc-0356 20
```

### 9c. Check duplicate removal success

Clumpify Successfully worked on all samples

```
[hpc-0356@wahab-01 2nd_sequencing_run]$ salloc
[hpc-0356@d1-w6420a-13 2nd_sequencing_run]$ enable_lmod
[hpc-0356@d1-w6420a-13 2nd_sequencing_run]$ module load container_env R/4.3 
[hpc-0356@d1-w6420a-13 2nd_sequencing_run]$ crun R < /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/checkClumpify_EG.R --no-save
[hpc-0356@d1-w6420a-13 2nd_sequencing_run]$ exit
```

### 9d. Clean the scratch drive

```
[hpc-0356@wahab-01 2nd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/cleanSCRATCH.sbatch /scratch/hpc-0356 "*clumpify*temp*"
```

### 9e. Generate metadata on deduplicated FASTQ files (*)

```
[hpc-0356@wahab-01 2nd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_fp1_clmp" "fqc_clmp_report"  "fq.gz"
```

**Results** (fq_fp1_clmp/fqc_clmp_report.html): 
* no samples found with any adapter content
* GC content remained the same
* total sequences went down
* 35/44 Albatross samples flagged or failed for Per Sequence GC Content
	* 1 Contemporary flagged: `Sor-CPnd_038-Ex1-2A-lcwgs-1-2.clmp.r1`

```
‣ % duplication - 
    • Alb: 0.3-1.9%
    • Contemp: 0.9-5.9%
    • Undetermined: 6.2 - 8.0%
‣ length - 
    • Alb: 70-105 bp
    • Contemp: 99-139 bp
    • Undetermined: 122 bp
‣ number of reads -
    • Alb: 0.0-0.7 mil
    • Contemp: 0.3-3.7 mil
    • Undetermined: 199.7 mil
```

<details><summary>* 1st FASTP Report:</summary>
<p>
	
```
Sample Name				% Dups	% GC	Length	M Seqs
Sor-ACeb_001-Ex1-8E-lcwgs-1-2.clmp.r1	1.0%	32%	90 bp	0.7
Sor-ACeb_001-Ex1-8E-lcwgs-1-2.clmp.r2	1.2%	32%	90 bp	0.7
Sor-ACeb_002-Ex1-9E-lcwgs-1-2.clmp.r1	1.4%	38%	88 bp	0.1
Sor-ACeb_002-Ex1-9E-lcwgs-1-2.clmp.r2	1.4%	38%	88 bp	0.1
Sor-ACeb_003-Ex1-10E-lcwgs-1-2.clmp.r1	0.3%	35%	76 bp	0.3
Sor-ACeb_003-Ex1-10E-lcwgs-1-2.clmp.r2	0.4%	35%	76 bp	0.3
Sor-ACeb_004-Ex1-11E-lcwgs-1-2.clmp.r1	0.7%	36%	70 bp	0.2
Sor-ACeb_004-Ex1-11E-lcwgs-1-2.clmp.r2	0.6%	36%	70 bp	0.2
Sor-ACeb_005-Ex1-12E-lcwgs-1-2.clmp.r1	1.3%	41%	95 bp	0.0
Sor-ACeb_005-Ex1-12E-lcwgs-1-2.clmp.r2	1.3%	41%	95 bp	0.0
Sor-ACeb_006-Ex1-1F-lcwgs-1-2.clmp.r1	0.7%	39%	91 bp	0.0
Sor-ACeb_006-Ex1-1F-lcwgs-1-2.clmp.r2	0.8%	39%	91 bp	0.0
Sor-ACeb_007-Ex1-2F-lcwgs-1-2.clmp.r1	0.7%	38%	90 bp	0.0
Sor-ACeb_007-Ex1-2F-lcwgs-1-2.clmp.r2	0.7%	38%	90 bp	0.0
Sor-ACeb_008-Ex1-3F-lcwgs-1-2.clmp.r1	0.4%	36%	82 bp	0.0
Sor-ACeb_008-Ex1-3F-lcwgs-1-2.clmp.r2	0.5%	36%	82 bp	0.0
Sor-ACeb_009-Ex1-4F-lcwgs-1-2.clmp.r1	0.3%	36%	75 bp	0.0
Sor-ACeb_009-Ex1-4F-lcwgs-1-2.clmp.r2	0.5%	36%	76 bp	0.0
Sor-ACeb_010-Ex1-5F-lcwgs-1-2.clmp.r1	0.9%	38%	84 bp	0.1
Sor-ACeb_010-Ex1-5F-lcwgs-1-2.clmp.r2	0.9%	38%	84 bp	0.1
Sor-ACeb_011-Ex1-6F-lcwgs-1-2.clmp.r1	1.5%	43%	105 bp	0.0
Sor-ACeb_011-Ex1-6F-lcwgs-1-2.clmp.r2	1.7%	43%	105 bp	0.0
Sor-ACeb_012-Ex1-7F-lcwgs-1-2.clmp.r1	1.2%	36%	88 bp	0.1
Sor-ACeb_012-Ex1-7F-lcwgs-1-2.clmp.r2	1.1%	36%	88 bp	0.1
Sor-ACeb_013-Ex1-8F-lcwgs-1-2.clmp.r1	1.8%	44%	105 bp	0.0
Sor-ACeb_013-Ex1-8F-lcwgs-1-2.clmp.r2	1.9%	44%	105 bp	0.0
Sor-ACeb_014-Ex1-9F-lcwgs-1-2.clmp.r1	1.2%	39%	88 bp	0.0
Sor-ACeb_014-Ex1-9F-lcwgs-1-2.clmp.r2	1.2%	39%	88 bp	0.0
Sor-ACeb_015-Ex1-10F-lcwgs-1-2.clmp.r1	1.0%	37%	88 bp	0.0
Sor-ACeb_015-Ex1-10F-lcwgs-1-2.clmp.r2	0.9%	37%	88 bp	0.0
Sor-ACeb_016-Ex1-11F-lcwgs-1-2.clmp.r1	0.7%	39%	71 bp	0.3
Sor-ACeb_016-Ex1-11F-lcwgs-1-2.clmp.r2	0.7%	39%	71 bp	0.3
Sor-ACeb_017-Ex1-12F-lcwgs-1-2.clmp.r1	1.0%	38%	80 bp	0.2
Sor-ACeb_017-Ex1-12F-lcwgs-1-2.clmp.r2	0.9%	38%	80 bp	0.2
Sor-ACeb_018-Ex1-1G-lcwgs-1-2.clmp.r1	0.9%	37%	99 bp	0.0
Sor-ACeb_018-Ex1-1G-lcwgs-1-2.clmp.r2	1.1%	37%	99 bp	0.0
Sor-ACeb_019-Ex1-3G-lcwgs-1-2.clmp.r1	0.5%	36%	99 bp	0.0
Sor-ACeb_019-Ex1-3G-lcwgs-1-2.clmp.r2	0.8%	36%	99 bp	0.0
Sor-ACeb_020-Ex1-2G-lcwgs-1-2.clmp.r1	0.7%	36%	96 bp	0.0
Sor-ACeb_020-Ex1-2G-lcwgs-1-2.clmp.r2	1.0%	36%	96 bp	0.0
Sor-ACeb_021-Ex1-4G-lcwgs-1-2.clmp.r1	0.8%	36%	87 bp	0.0
Sor-ACeb_021-Ex1-4G-lcwgs-1-2.clmp.r2	1.2%	36%	87 bp	0.0
Sor-ACeb_022-Ex1-5G-lcwgs-1-2.clmp.r1	1.3%	42%	98 bp	0.0
Sor-ACeb_022-Ex1-5G-lcwgs-1-2.clmp.r2	1.4%	42%	98 bp	0.0
Sor-CPnd_001-Ex1-3E-lcwgs-1-2.clmp.r1	1.5%	37%	110 bp	1.3
Sor-CPnd_001-Ex1-3E-lcwgs-1-2.clmp.r2	1.8%	37%	110 bp	1.3
Sor-CPnd_002-Ex1-5E-lcwgs-1-2.clmp.r1	1.2%	38%	99 bp	0.7
Sor-CPnd_002-Ex1-5E-lcwgs-1-2.clmp.r2	1.4%	38%	99 bp	0.7
Sor-CPnd_003-Ex1-2B-lcwgs-1-2.clmp.r1	1.5%	38%	113 bp	0.6
Sor-CPnd_003-Ex1-2B-lcwgs-1-2.clmp.r2	1.8%	38%	113 bp	0.6
Sor-CPnd_004-Ex1-1G-lcwgs-1-2.clmp.r1	1.4%	38%	112 bp	1.7
Sor-CPnd_004-Ex1-1G-lcwgs-1-2.clmp.r2	1.7%	38%	112 bp	1.7
Sor-CPnd_005-Ex1-3D-lcwgs-1-2.clmp.r1	2.3%	38%	126 bp	1.2
Sor-CPnd_005-Ex1-3D-lcwgs-1-2.clmp.r2	2.8%	38%	126 bp	1.2
Sor-CPnd_006-Ex1-2D-lcwgs-1-2.clmp.r1	1.6%	38%	109 bp	1.1
Sor-CPnd_006-Ex1-2D-lcwgs-1-2.clmp.r2	1.9%	38%	109 bp	1.1
Sor-CPnd_007-Ex1-1C-lcwgs-1-2.clmp.r1	1.4%	39%	117 bp	0.6
Sor-CPnd_007-Ex1-1C-lcwgs-1-2.clmp.r2	1.7%	39%	117 bp	0.6
Sor-CPnd_008-Ex1-1A-lcwgs-1-2.clmp.r1	4.2%	38%	139 bp	2.4
Sor-CPnd_008-Ex1-1A-lcwgs-1-2.clmp.r2	5.9%	38%	139 bp	2.4
Sor-CPnd_009-Ex1-6A-lcwgs-1-2.clmp.r1	2.4%	38%	121 bp	2.4
Sor-CPnd_009-Ex1-6A-lcwgs-1-2.clmp.r2	3.3%	38%	121 bp	2.4
Sor-CPnd_010-Ex1-1H-lcwgs-1-2.clmp.r1	1.1%	38%	114 bp	0.4
Sor-CPnd_010-Ex1-1H-lcwgs-1-2.clmp.r2	1.5%	38%	114 bp	0.4
Sor-CPnd_012-Ex1-5B-lcwgs-1-2.clmp.r1	1.5%	38%	111 bp	0.4
Sor-CPnd_012-Ex1-5B-lcwgs-1-2.clmp.r2	1.9%	38%	111 bp	0.4
Sor-CPnd_013-Ex1-7F-lcwgs-1-2.clmp.r1	1.3%	37%	112 bp	0.7
Sor-CPnd_013-Ex1-7F-lcwgs-1-2.clmp.r2	1.7%	37%	112 bp	0.7
Sor-CPnd_014-Ex1-1F-lcwgs-1-2.clmp.r1	2.0%	38%	117 bp	3.7
Sor-CPnd_014-Ex1-1F-lcwgs-1-2.clmp.r2	2.6%	38%	117 bp	3.7
Sor-CPnd_015-Ex1-5F-lcwgs-1-2.clmp.r1	1.1%	38%	100 bp	0.4
Sor-CPnd_015-Ex1-5F-lcwgs-1-2.clmp.r2	1.3%	38%	100 bp	0.4
Sor-CPnd_016-Ex1-1B-lcwgs-1-2.clmp.r1	2.4%	38%	133 bp	1.1
Sor-CPnd_016-Ex1-1B-lcwgs-1-2.clmp.r2	3.1%	38%	133 bp	1.1
Sor-CPnd_017-Ex1-3G-lcwgs-1-2.clmp.r1	1.1%	37%	108 bp	0.5
Sor-CPnd_017-Ex1-3G-lcwgs-1-2.clmp.r2	1.4%	37%	108 bp	0.5
Sor-CPnd_018-Ex1-1E-lcwgs-1-2.clmp.r1	1.4%	38%	111 bp	1.8
Sor-CPnd_018-Ex1-1E-lcwgs-1-2.clmp.r2	1.9%	38%	111 bp	1.8
Sor-CPnd_019-Ex1-6G-lcwgs-1-2.clmp.r1	1.7%	38%	111 bp	1.1
Sor-CPnd_019-Ex1-6G-lcwgs-1-2.clmp.r2	2.2%	38%	111 bp	1.1
Sor-CPnd_020-Ex1-2E-lcwgs-1-2.clmp.r1	1.8%	37%	114 bp	1.3
Sor-CPnd_020-Ex1-2E-lcwgs-1-2.clmp.r2	2.3%	37%	115 bp	1.3
Sor-CPnd_022-Ex1-7C-lcwgs-1-2.clmp.r1	1.9%	38%	116 bp	1.3
Sor-CPnd_022-Ex1-7C-lcwgs-1-2.clmp.r2	2.5%	38%	116 bp	1.3
Sor-CPnd_024-Ex1-5G-lcwgs-1-2.clmp.r1	1.2%	38%	103 bp	0.4
Sor-CPnd_024-Ex1-5G-lcwgs-1-2.clmp.r2	1.4%	38%	103 bp	0.4
Sor-CPnd_026-Ex1-3H-lcwgs-1-2.clmp.r1	1.7%	38%	119 bp	0.5
Sor-CPnd_026-Ex1-3H-lcwgs-1-2.clmp.r2	2.1%	38%	119 bp	0.5
Sor-CPnd_027-Ex1-3C-lcwgs-1-2.clmp.r1	2.2%	38%	127 bp	1.0
Sor-CPnd_027-Ex1-3C-lcwgs-1-2.clmp.r2	2.8%	38%	127 bp	1.0
Sor-CPnd_028-Ex1-3A-lcwgs-1-2.clmp.r1	2.3%	38%	122 bp	1.3
Sor-CPnd_028-Ex1-3A-lcwgs-1-2.clmp.r2	2.9%	38%	122 bp	1.3
Sor-CPnd_029-Ex1-8E-lcwgs-1-2.clmp.r1	2.0%	37%	111 bp	1.9
Sor-CPnd_029-Ex1-8E-lcwgs-1-2.clmp.r2	2.4%	37%	111 bp	1.9
Sor-CPnd_030-Ex1-2H-lcwgs-1-2.clmp.r1	1.5%	38%	109 bp	0.6
Sor-CPnd_030-Ex1-2H-lcwgs-1-2.clmp.r2	1.8%	38%	109 bp	0.6
Sor-CPnd_031-Ex1-5D-lcwgs-1-2.clmp.r1	2.0%	38%	116 bp	0.9
Sor-CPnd_031-Ex1-5D-lcwgs-1-2.clmp.r2	2.4%	38%	116 bp	0.9
Sor-CPnd_033-Ex1-2F-lcwgs-1-2.clmp.r1	1.5%	37%	113 bp	0.6
Sor-CPnd_033-Ex1-2F-lcwgs-1-2.clmp.r2	1.8%	37%	113 bp	0.6
Sor-CPnd_034-Ex1-4G-lcwgs-1-2.clmp.r1	1.2%	38%	101 bp	0.3
Sor-CPnd_034-Ex1-4G-lcwgs-1-2.clmp.r2	1.4%	38%	101 bp	0.3
Sor-CPnd_036-Ex1-5C-lcwgs-1-2.clmp.r1	1.8%	38%	109 bp	0.9
Sor-CPnd_036-Ex1-5C-lcwgs-1-2.clmp.r2	2.1%	38%	109 bp	0.9
Sor-CPnd_037-Ex1-6C-lcwgs-1-2.clmp.r1	2.2%	38%	115 bp	1.1
Sor-CPnd_037-Ex1-6C-lcwgs-1-2.clmp.r2	2.8%	38%	115 bp	1.1
Sor-CPnd_038-Ex1-2A-lcwgs-1-2.clmp.r1	2.4%	38%	124 bp	0.8
Sor-CPnd_038-Ex1-2A-lcwgs-1-2.clmp.r2	3.0%	38%	124 bp	0.8
Sor-CPnd_041-Ex1-7A-lcwgs-1-2.clmp.r1	1.2%	38%	115 bp	1.5
Sor-CPnd_041-Ex1-7A-lcwgs-1-2.clmp.r2	1.7%	38%	115 bp	1.5
Sor-CPnd_043-Ex1-1D-lcwgs-1-2.clmp.r1	1.9%	38%	121 bp	1.8
Sor-CPnd_043-Ex1-1D-lcwgs-1-2.clmp.r2	2.4%	38%	121 bp	1.8
Sor-CPnd_044-Ex1-8G-lcwgs-1-2.clmp.r1	1.4%	37%	108 bp	1.1
Sor-CPnd_044-Ex1-8G-lcwgs-1-2.clmp.r2	1.8%	37%	108 bp	1.1
Sor-CPnd_045-Ex1-7B-lcwgs-1-2.clmp.r1	2.1%	38%	122 bp	1.4
Sor-CPnd_045-Ex1-7B-lcwgs-1-2.clmp.r2	2.6%	38%	122 bp	1.4
Sor-CPnd_046-Ex1-5A-lcwgs-1-2.clmp.r1	1.2%	38%	104 bp	0.4
Sor-CPnd_046-Ex1-5A-lcwgs-1-2.clmp.r2	1.5%	38%	104 bp	0.4
Sor-CPnd_049-Ex1-3B-lcwgs-1-2.clmp.r1	1.4%	38%	115 bp	0.4
Sor-CPnd_049-Ex1-3B-lcwgs-1-2.clmp.r2	1.8%	38%	115 bp	0.4
Sor-CPnd_050-Ex1-3F-lcwgs-1-2.clmp.r1	1.6%	38%	112 bp	1.6
Sor-CPnd_050-Ex1-3F-lcwgs-1-2.clmp.r2	2.1%	38%	112 bp	1.6
Sor-CPnd_052-Ex1-6D-lcwgs-1-2.clmp.r1	1.3%	37%	105 bp	0.8
Sor-CPnd_052-Ex1-6D-lcwgs-1-2.clmp.r2	1.6%	37%	105 bp	0.8
Sor-CPnd_053-Ex1-2C-lcwgs-1-2.clmp.r1	2.1%	38%	118 bp	0.8
Sor-CPnd_053-Ex1-2C-lcwgs-1-2.clmp.r2	2.6%	38%	118 bp	0.8
Sor-CPnd_054-Ex1-8F-lcwgs-1-2.clmp.r1	0.9%	38%	99 bp	0.4
Sor-CPnd_054-Ex1-8F-lcwgs-1-2.clmp.r2	1.1%	38%	99 bp	0.4
Sor-CPnd_055-Ex1-7G-lcwgs-1-2.clmp.r1	1.3%	37%	106 bp	1.1
Sor-CPnd_055-Ex1-7G-lcwgs-1-2.clmp.r2	1.5%	37%	106 bp	1.1
Sor-CPnd_058-Ex1-2G-lcwgs-1-2.clmp.r1	1.3%	37%	108 bp	0.6
Sor-CPnd_058-Ex1-2G-lcwgs-1-2.clmp.r2	1.6%	37%	108 bp	0.6
Sor-CPnd_063-Ex1-7D-lcwgs-1-2.clmp.r1	1.3%	37%	109 bp	1.1
Sor-CPnd_063-Ex1-7D-lcwgs-1-2.clmp.r2	1.7%	37%	109 bp	1.1
Sor-CPnd_066-Ex1-8B-lcwgs-1-2.clmp.r1	1.7%	38%	117 bp	0.7
Sor-CPnd_066-Ex1-8B-lcwgs-1-2.clmp.r2	2.2%	38%	117 bp	0.7
Sor-CPnd_069-Ex1-6B-lcwgs-1-2.clmp.r1	2.3%	38%	120 bp	0.9
Sor-CPnd_069-Ex1-6B-lcwgs-1-2.clmp.r2	2.9%	38%	120 bp	0.9
Sor-CPnd_072-Ex1-8C-lcwgs-1-2.clmp.r1	2.8%	38%	124 bp	2.0
Sor-CPnd_072-Ex1-8C-lcwgs-1-2.clmp.r2	3.6%	38%	124 bp	2.0

Undetermined.clmp.r1			6.2%	37%	122 bp	199.7
Undetermined.clmp.r2			8.0%	37%	122 bp	199.7
```

</p>
</details>

</p>

---
</details>

<details><summary>10. Second trim (*)</summary>
<p>

## 10. Second trim (*)
 
```
[hpc-0356@wahab-01 2nd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFASTP_2.sbatch fq_fp1_clmp fq_fp1_clmp_fp2 33
```

### Review the FastQC output (fq_fp1_clmp_fp2/2nd_fastp_report.html):
After 2nd trim:
* adapter at or below 1%
* high variability for `Sor-ACeb_021-Ex1-4G` on the fastp: insert size distribution graph

```
‣ % duplication -
	• Alb: 0.4 - 1.4%
	• Contemp: 0.9 - 5.1%
	• Undetermined: 2.7%
‣ GC content -
	• Alb: 32.5 - 44.4%
	• Contemp: 37.2 - 39.3%
	• Undetermined: 37.8%
‣ passing filter -
	• Alb: 98.7 - 99.6%
	• Contemp: 98.3 - 99.3%
	• Undetermined: 98.7%
‣ % adapter -
	• Alb: 0.5 - 0.9%
	• Contemp: 0.2 - 0.6%
	• Undetermined: 0.5%
‣ number of reads -
	• Alb: 0 - 1.4 mil
	• Contemp: 0.6 - 7.3 mil
	• Undetermined: 399 mil
```

<details><summary>* 1st FASTP Report:</summary>
<p>
	
```
Sample Name					% Dups	% GC 	% PF	% Adapter
Sor-ACeb_001-Ex1-8E-lcwgs-1-2.clmp.r1r2_fastp	0.8%	32.5%	99.4%	0.6%
Sor-ACeb_002-Ex1-9E-lcwgs-1-2.clmp.r1r2_fastp	0.8%	38.6%	99.4%	0.6%
Sor-ACeb_003-Ex1-10E-lcwgs-1-2.clmp.r1r2_fastp	0.4%	35.7%	99.6%	0.7%
Sor-ACeb_004-Ex1-11E-lcwgs-1-2.clmp.r1r2_fastp	0.4%	36.9%	99.4%	0.8%
Sor-ACeb_005-Ex1-12E-lcwgs-1-2.clmp.r1r2_fastp	0.9%	41.9%	99.3%	0.7%
Sor-ACeb_006-Ex1-1F-lcwgs-1-2.clmp.r1r2_fastp	0.5%	39.0%	99.1%	0.9%
Sor-ACeb_007-Ex1-2F-lcwgs-1-2.clmp.r1r2_fastp	0.6%	38.2%	99.0%	0.7%
Sor-ACeb_008-Ex1-3F-lcwgs-1-2.clmp.r1r2_fastp	0.4%	36.1%	99.4%	0.6%
Sor-ACeb_009-Ex1-4F-lcwgs-1-2.clmp.r1r2_fastp	0.5%	36.2%	99.5%	0.5%
Sor-ACeb_010-Ex1-5F-lcwgs-1-2.clmp.r1r2_fastp	0.5%	38.3%	99.5%	0.6%
Sor-ACeb_011-Ex1-6F-lcwgs-1-2.clmp.r1r2_fastp	1.4%	43.1%	99.0%	0.6%
Sor-ACeb_012-Ex1-7F-lcwgs-1-2.clmp.r1r2_fastp	0.5%	36.2%	99.5%	0.6%
Sor-ACeb_013-Ex1-8F-lcwgs-1-2.clmp.r1r2_fastp	1.4%	44.4%	99.0%	0.5%
Sor-ACeb_014-Ex1-9F-lcwgs-1-2.clmp.r1r2_fastp	0.9%	39.3%	99.3%	0.7%
Sor-ACeb_015-Ex1-10F-lcwgs-1-2.clmp.r1r2_fastp	0.6%	37.6%	99.5%	0.6%
Sor-ACeb_016-Ex1-11F-lcwgs-1-2.clmp.r1r2_fastp	0.4%	39.7%	99.5%	0.6%
Sor-ACeb_017-Ex1-12F-lcwgs-1-2.clmp.r1r2_fastp	0.6%	38.9%	99.4%	0.8%
Sor-ACeb_018-Ex1-1G-lcwgs-1-2.clmp.r1r2_fastp	0.6%	37.5%	99.3%	0.7%
Sor-ACeb_019-Ex1-3G-lcwgs-1-2.clmp.r1r2_fastp	0.6%	36.5%	99.2%	0.8%
Sor-ACeb_020-Ex1-2G-lcwgs-1-2.clmp.r1r2_fastp	0.7%	36.8%	99.1%	0.8%
Sor-ACeb_021-Ex1-4G-lcwgs-1-2.clmp.r1r2_fastp	1.1%	36.4%	98.7%	0.7%
Sor-ACeb_022-Ex1-5G-lcwgs-1-2.clmp.r1r2_fastp	1.1%	42.8%	99.2%	0.6%
Sor-CPnd_001-Ex1-3E-lcwgs-1-2.clmp.r1r2_fastp	1.5%	37.7%	99.1%	0.5%
Sor-CPnd_002-Ex1-5E-lcwgs-1-2.clmp.r1r2_fastp	1.3%	38.4%	99.1%	0.6%
Sor-CPnd_003-Ex1-2B-lcwgs-1-2.clmp.r1r2_fastp	1.7%	38.6%	99.1%	0.5%
Sor-CPnd_004-Ex1-1G-lcwgs-1-2.clmp.r1r2_fastp	1.3%	37.9%	99.2%	0.4%
Sor-CPnd_005-Ex1-3D-lcwgs-1-2.clmp.r1r2_fastp	2.4%	38.0%	98.9%	0.4%
Sor-CPnd_006-Ex1-2D-lcwgs-1-2.clmp.r1r2_fastp	1.7%	38.2%	99.0%	0.5%
Sor-CPnd_007-Ex1-1C-lcwgs-1-2.clmp.r1r2_fastp	1.4%	39.3%	99.1%	0.5%
Sor-CPnd_008-Ex1-1A-lcwgs-1-2.clmp.r1r2_fastp	5.1%	38.7%	98.3%	0.2%
Sor-CPnd_009-Ex1-6A-lcwgs-1-2.clmp.r1r2_fastp	2.5%	38.8%	99.1%	0.4%
Sor-CPnd_010-Ex1-1H-lcwgs-1-2.clmp.r1r2_fastp	1.2%	38.2%	99.1%	0.5%
Sor-CPnd_012-Ex1-5B-lcwgs-1-2.clmp.r1r2_fastp	1.8%	38.5%	99.1%	0.5%
Sor-CPnd_013-Ex1-7F-lcwgs-1-2.clmp.r1r2_fastp	1.3%	37.8%	99.1%	0.6%
Sor-CPnd_014-Ex1-1F-lcwgs-1-2.clmp.r1r2_fastp	1.7%	38.3%	99.2%	0.5%
Sor-CPnd_015-Ex1-5F-lcwgs-1-2.clmp.r1r2_fastp	1.2%	38.7%	99.1%	0.5%
Sor-CPnd_016-Ex1-1B-lcwgs-1-2.clmp.r1r2_fastp	2.7%	38.6%	98.9%	0.3%
Sor-CPnd_017-Ex1-3G-lcwgs-1-2.clmp.r1r2_fastp	1.2%	37.5%	99.2%	0.5%
Sor-CPnd_018-Ex1-1E-lcwgs-1-2.clmp.r1r2_fastp	1.4%	38.3%	99.1%	0.5%
Sor-CPnd_019-Ex1-6G-lcwgs-1-2.clmp.r1r2_fastp	2.0%	38.3%	99.2%	0.5%
Sor-CPnd_020-Ex1-2E-lcwgs-1-2.clmp.r1r2_fastp	2.0%	37.7%	99.0%	0.5%
Sor-CPnd_022-Ex1-7C-lcwgs-1-2.clmp.r1r2_fastp	2.1%	38.0%	99.1%	0.4%
Sor-CPnd_024-Ex1-5G-lcwgs-1-2.clmp.r1r2_fastp	1.3%	38.1%	99.1%	0.5%
Sor-CPnd_026-Ex1-3H-lcwgs-1-2.clmp.r1r2_fastp	2.0%	38.0%	99.1%	0.4%
Sor-CPnd_027-Ex1-3C-lcwgs-1-2.clmp.r1r2_fastp	2.6%	38.2%	98.9%	0.4%
Sor-CPnd_028-Ex1-3A-lcwgs-1-2.clmp.r1r2_fastp	2.7%	38.3%	98.9%	0.4%
Sor-CPnd_029-Ex1-8E-lcwgs-1-2.clmp.r1r2_fastp	2.1%	37.5%	99.0%	0.5%
Sor-CPnd_030-Ex1-2H-lcwgs-1-2.clmp.r1r2_fastp	1.6%	38.1%	99.1%	0.5%
Sor-CPnd_031-Ex1-5D-lcwgs-1-2.clmp.r1r2_fastp	2.2%	38.3%	99.0%	0.4%
Sor-CPnd_033-Ex1-2F-lcwgs-1-2.clmp.r1r2_fastp	1.6%	37.6%	99.0%	0.5%
Sor-CPnd_034-Ex1-4G-lcwgs-1-2.clmp.r1r2_fastp	1.3%	38.5%	99.3%	0.5%
Sor-CPnd_036-Ex1-5C-lcwgs-1-2.clmp.r1r2_fastp	2.0%	38.0%	99.1%	0.5%
Sor-CPnd_037-Ex1-6C-lcwgs-1-2.clmp.r1r2_fastp	2.5%	38.2%	99.1%	0.4%
Sor-CPnd_038-Ex1-2A-lcwgs-1-2.clmp.r1r2_fastp	2.9%	38.2%	98.8%	0.4%
Sor-CPnd_041-Ex1-7A-lcwgs-1-2.clmp.r1r2_fastp	1.1%	38.9%	99.3%	0.5%
Sor-CPnd_043-Ex1-1D-lcwgs-1-2.clmp.r1r2_fastp	1.9%	38.2%	99.0%	0.4%
Sor-CPnd_044-Ex1-8G-lcwgs-1-2.clmp.r1r2_fastp	1.6%	37.7%	99.1%	0.5%
Sor-CPnd_045-Ex1-7B-lcwgs-1-2.clmp.r1r2_fastp	2.3%	38.2%	99.0%	0.4%
Sor-CPnd_046-Ex1-5A-lcwgs-1-2.clmp.r1r2_fastp	1.3%	38.5%	99.1%	0.5%
Sor-CPnd_049-Ex1-3B-lcwgs-1-2.clmp.r1r2_fastp	1.6%	38.1%	99.1%	0.4%
Sor-CPnd_050-Ex1-3F-lcwgs-1-2.clmp.r1r2_fastp	1.7%	38.1%	99.1%	0.5%
Sor-CPnd_052-Ex1-6D-lcwgs-1-2.clmp.r1r2_fastp	1.4%	37.5%	99.2%	0.5%
Sor-CPnd_053-Ex1-2C-lcwgs-1-2.clmp.r1r2_fastp	2.5%	38.3%	98.9%	0.4%
Sor-CPnd_054-Ex1-8F-lcwgs-1-2.clmp.r1r2_fastp	0.9%	38.2%	99.1%	0.6%
Sor-CPnd_055-Ex1-7G-lcwgs-1-2.clmp.r1r2_fastp	1.2%	37.3%	99.2%	0.5%
Sor-CPnd_058-Ex1-2G-lcwgs-1-2.clmp.r1r2_fastp	1.4%	37.2%	99.1%	0.5%
Sor-CPnd_063-Ex1-7D-lcwgs-1-2.clmp.r1r2_fastp	1.4%	37.8%	99.2%	0.5%
Sor-CPnd_066-Ex1-8B-lcwgs-1-2.clmp.r1r2_fastp	2.1%	38.2%	99.0%	0.4%
Sor-CPnd_069-Ex1-6B-lcwgs-1-2.clmp.r1r2_fastp	2.7%	38.6%	99.1%	0.4%
Sor-CPnd_072-Ex1-8C-lcwgs-1-2.clmp.r1r2_fastp	3.2%	38.3%	98.8%	0.3%

Undetermined.clmp.r1r2_fastp			2.7%	37.8%	98.7%	0.5%
```
</p>
</details>

</p>

---
</details>

<details><summary>11. Decontaminate files (*)</summary>
<p>
	
## 11. Decontaminate files (*)

<details><summary>11a. Run fastq_screen</summary>
	
### 11a. Run `fastq_screen`

```
[hpc-0356@wahab-01 2nd_sequencing_run]$ bash
[hpc-0356@wahab-01 2nd_sequencing_run]$ fqScrnPATH=/home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runFQSCRN_6.bash
indir=fq_fp1_clmp_fp2
[hpc-0356@wahab-01 2nd_sequencing_run]$ outdir=/scratch/hpc-0356/fq_fp1_clmp_fp2_fqscrn
nodes=20
[hpc-0356@wahab-01 2nd_sequencing_run]$ bash $fqScrnPATH $indir $outdir $nodes
```
---

</details>

<details><summary>11b. Check for Errors</summary>
	
### 11b. Check for Errors

```
[hpc-0356@wahab-01 2nd_sequencing_run]$ outdir=/scratch/hpc-0356/fq_fp1_clmp_fp2_fqscrn
[hpc-0356@wahab-01 2nd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/validateFQ.sbatch $outdir "*filter.fastq.gz"
Submitted batch job 3297653
```

Check the `.out` file
```
[hpc-0356@wahab-01 2nd_sequencing_run]$ cat valiate_FQ_-3297653.out

FASTQ VALIDATION REPORT -Paired Ends Not Tested

Directory: /scratch/hpc-0356/fq_fp1_clmp_fp2_fqscrn
File Pattern: *filter.fastq.gz

Number of fq files evaluated: 142
Number of fq files validated: 142

Errors Reported:
```

Check the $outdir/fqValidateReport.txt file
```
[hpc-0356@wahab-01 2nd_sequencing_run]$ less -S $outdir/fqValidationReport.txt file
```

**Confirm files were successfully completed:** (no errors)
```
[hpc-0356@wahab-01 2nd_sequencing_run]$ bash
[hpc-0356@wahab-01 2nd_sequencing_run]$ indir=fq_fp1_clmp_fp2
[hpc-0356@wahab-01 2nd_sequencing_run]$ outdir=/scratch/hpc-0356/fq_fp1_clmp_fp2_fqscrn
```

Check that all 5 files were created for each fqgz file:
```
[hpc-0356@wahab-01 2nd_sequencing_run]$ ls $outdir/*r1.tagged.fastq.gz | wc -l
					ls $outdir/*r2.tagged.fastq.gz | wc -l
					ls $outdir/*r1.tagged_filter.fastq.gz | wc -l
					ls $outdir/*r2.tagged_filter.fastq.gz | wc -l 
					ls $outdir/*r1_screen.txt | wc -l
					ls $outdir/*r2_screen.txt | wc -l
					ls $outdir/*r1_screen.png | wc -l
					ls $outdir/*r2_screen.png | wc -l
					ls $outdir/*r1_screen.html | wc -l
					ls $outdir/*r2_screen.html | wc -l
71
71
71
71
71
71
71
71
71
71
```
For each, you should have the same number as the number of input files (number of fq.gz files):
```
[hpc-0356@wahab-01 2nd_sequencing_run]$ ls $indir/*r1.fq.gz | wc -l
                                        ls $indir/*r2.fq.gz | wc -l
71
71
```

Check for any errors in the `*out` files:
```
[hpc-0356@wahab-01 2nd_sequencing_run]$ grep 'error' slurm-fqscrn.*out
                                        grep 'No reads in' slurm-fqscrn.*out
                                        grep 'FATAL' slurm-fqscrn.*out
```

---

</details>

<details><summary>11e. Move output files</summary>
	
### 11e. Move output files

I had no issues with running `FastQ Screen`, so I moved the files back to my species dir

```
[hpc-0356@wahab-01 2nd_sequencing_run]$ outdir=/scratch/hpc-0356/fq_fp1_clmp_fp2_fqscrn
					fqscrndir=fq_fp1_clmp_fp2_fqscrn
					mkdir $fqscrndir
					screen mv $outdir $fqscrndir
```
---

</details>


<details><summary>11f. Run MultiQC (*)</summary>
	
### 11f. Run MultiQC (*)

```
[hpc-0356@wahab-01 2nd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/runMULTIQC.sbatch fq_fp1_clmp_fp2_fqscrn fastq_screen_report
Submitted batch job 3297805
```

#### Review the MultiQC output (fq_fp1_clmp_fp2_fqscrn/fastq_screen_report.html):
* 

```
‣ no hits -
	• Alb: 
	• Contemp: 
```

</details>

---


</details>

