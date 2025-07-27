<img src="http://www.fishbiosystem.ru/PERCIFORMES/Apogonidae/Foto/(Sphaeramia%20orbicularis)%2092f.jpg" alt="Sor" width="300"/>

# *Sphaeramia orbicularis* lcWGS Analysis 

## 4th Sequencing Run

Analysis of low-coverage whole genome sequencing data for *Sphaeramia orbicularis* from Cebu City Market (ACeb). **Only Albatross individuals were re-sequenced for this run.**

fq.gz processing done by Gianna Mazzei (July 2025).

---
	
## fq.gz Pre-processing

This portion follows the instructions on [this repo](https://github.com/philippinespire/pire_fq_gz_processing).

→ (*) _denotes steps with MultiQC Report Analyses_
<details><summary>0. Set-up</summary>

## 0. Set-up

Make 4th sequencing run directory
```
[hpc-0373@wahab-01 pire_sphaeramia_orbicularis_lcwgs]$ mkdir 4th_sequencing_run
```

---
</details>

<details><summary>1. Get raw data</summary>

## 1. Get raw data

```
[hpc-0373@wahab-01 pire_sphaeramia_orbicularis_lcwgs]$ cp -r /archive/carpenterlab/pire/downloads/sphaeramia_orbicularis/4th_sequencing_run/fq_raw 4th_sequencing_run
```

---
</details>

<details><summary>2. Proofread the decode file</summary>

## 2. Proofread the decode file

```
[hpc-0373@wahab-01 fq_raw]$ cat Sor-ACeb_lcwgs-reSeqLane_SequenceNameDecode.tsv
```
Checked that I have sequencing data for all individuals in the decode file
```
[hpc-0373@wahab-01 fq_raw]$ ls *1.fq.gz | wc -l
44
[hpc-0373@wahab-01 fq_raw]$ ls *2.fq.gz | wc -l
44
```
Number of lines (there's a line for header):
```
[hpc-0373@wahab-01 fq_raw]$ wc -l Sor-ACeb_lcwgs-reSeqLane_SequenceNameDecode.tsv
23 
```
There is an issue. Each individual was sequenced across two different lanes, and the decode file wants to rename both of these files with the same name, which would write over one of them. John Whalen ran into this issue in [step 3 of Sor 2nd sequencing run](https://github.com/philippinespire/pire_sphaeramia_orbicularis_lcwgs/tree/main/2nd_sequencing_run), and I did as well with Pli 3rd_sequencing_run. I'll be following what John did to resolve this.

Make a file called `origFileNames_ALL.txt` with all of the original file names.
```
[hpc-0373@wahab-01 fq_raw]$ ls *.fq.gz > origFileNames_ALL.txt
```
Add a header line to `origFileNames_ALL.txt` with the column names Sequence_Name & Extraction_ID.
```
[hpc-0373@wahab-01 fq_raw]$ sed -i '1i Sequence_Name\tExtraction_ID' origFileNames_ALL.txt
```
John created a script `process_decode_FileNames_all.sh` to use the SequenceNameDecode.tsv & `origFileNames_ALL.txt` to create a new decode file that includes the lane ID.

I need to edit it to suit this species:
```
[hpc-0373@wahab-01 fq_raw]$ cp ../../2nd_sequencing_run/fq_raw/process_decode_FileNames_all.sh .

[hpc-0373@wahab-01 fq_raw]$ nano process_decode_FileNames_all.sh
## CHANGED THIS SECTION:
# Define input and output files
TSV_FILE="Sor-ACeb_lcwgs-reSeqLane_SequenceNameDecode.tsv"
TXT_FILE="origFileNames_ALL.txt"
OUTPUT_FILE="Sor-ACeb_lcwgs-reSeqLane_SequenceNameDecode_ALL.tsv"
```
Now run:
```
[hpc-0373@wahab-01 fq_raw]$ bash process_decode_FileNames_all.sh
```
<details><summary>Contents of the created Sor-ACeb_lcwgs-reSeqLane_SequenceNameDecode_ALL.tsv file:</summary>

```
[hpc-0373@wahab-01 fq_raw]$ cat Sor-ACeb_lcwgs-reSeqLane_SequenceNameDecode_ALL.tsv
Sequence_Name	Extraction_ID
SoA0100108E_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_001-Ex1-8E-lcwgs-1-3
SoA0100108E_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_001-Ex1-8E-lcwgs-1-3
SoA0100209E_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_002-Ex1-9E-lcwgs-1-3
SoA0100209E_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_002-Ex1-9E-lcwgs-1-3
SoA0100310E_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_003-Ex1-10E-lcwgs-1-3
SoA0100310E_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_003-Ex1-10E-lcwgs-1-3
SoA0100411E_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_004-Ex1-11E-lcwgs-1-3
SoA0100411E_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_004-Ex1-11E-lcwgs-1-3
SoA0100512E_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_005-Ex1-12E-lcwgs-1-3
SoA0100512E_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_005-Ex1-12E-lcwgs-1-3
SoA0100601F_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_006-Ex1-1F-lcwgs-1-3
SoA0100601F_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_006-Ex1-1F-lcwgs-1-3
SoA0100702F_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_007-Ex1-2F-lcwgs-1-3
SoA0100702F_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_007-Ex1-2F-lcwgs-1-3
SoA0100803F_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_008-Ex1-3F-lcwgs-1-3
SoA0100803F_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_008-Ex1-3F-lcwgs-1-3
SoA0100904F_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_009-Ex1-4F-lcwgs-1-3
SoA0100904F_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_009-Ex1-4F-lcwgs-1-3
SoA0101005F_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_010-Ex1-5F-lcwgs-1-3
SoA0101005F_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_010-Ex1-5F-lcwgs-1-3
SoA0101106F_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_011-Ex1-6F-lcwgs-1-3
SoA0101106F_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_011-Ex1-6F-lcwgs-1-3
SoA0101207F_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_012-Ex1-7F-lcwgs-1-3
SoA0101207F_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_012-Ex1-7F-lcwgs-1-3
SoA0101308F_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_013-Ex1-8F-lcwgs-1-3
SoA0101308F_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_013-Ex1-8F-lcwgs-1-3
SoA0101409F_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_014-Ex1-9F-lcwgs-1-3
SoA0101409F_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_014-Ex1-9F-lcwgs-1-3
SoA0101510F_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_015-Ex1-10F-lcwgs-1-3
SoA0101510F_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_015-Ex1-10F-lcwgs-1-3
SoA0101611F_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_016-Ex1-11F-lcwgs-1-3
SoA0101611F_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_016-Ex1-11F-lcwgs-1-3
SoA0101712F_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_017-Ex1-12F-lcwgs-1-3
SoA0101712F_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_017-Ex1-12F-lcwgs-1-3
SoA0101801G_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_018-Ex1-1G-lcwgs-1-3
SoA0101801G_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_018-Ex1-1G-lcwgs-1-3
SoA0101903G_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_019-Ex1-3G-lcwgs-1-3
SoA0101903G_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_019-Ex1-3G-lcwgs-1-3
SoA0102002G_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_020-Ex1-2G-lcwgs-1-3
SoA0102002G_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_020-Ex1-2G-lcwgs-1-3
SoA0102104G_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_021-Ex1-4G-lcwgs-1-3
SoA0102104G_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_021-Ex1-4G-lcwgs-1-3
SoA0102205G_CKDL250018843-1A_22V722LT4_L3	Sor-ACeb_022-Ex1-5G-lcwgs-1-3
SoA0102205G_CKDL250018844-1A_233HTHLT3_L2	Sor-ACeb_022-Ex1-5G-lcwgs-1-3
```
</details>

Now check the number of lines:
```
[hpc-0373@wahab-01 fq_raw]$ wc -l Sor-ACeb_lcwgs-reSeqLane_SequenceNameDecode_ALL.tsv
45
```
All good.

---
</details>

<details><summary>3. Rename raw files</summary>

## 3. Rename raw files

First, perform a renaming dry run with the new decode file.

Instead of `renameFQGZ.bash`, I will use the script `renameFQGZ_keeplane2.bash` to rename the files because the lane ID needs to be maintained between the original file name and the new file name. 
```
[hpc-0373@wahab-01 fq_raw]$ salloc
[hpc-0373@e3-w6420b-01 fq_raw]$ bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ_keeplane2.bash Sor-ACeb_lcwgs-reSeqLane_SequenceNameDecode_ALL.tsv
```
Looks good.

Now, rename for real.
```
[hpc-0373@e3-w6420b-01 fq_raw]$ bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ_keeplane2.bash Sor-ACeb_lcwgs-reSeqLane_SequenceNameDecode_ALL.tsv rename
```
Make sure we have the right # of files:
```
ls *.fq.gz | wc -l
88
```
It worked!

---
</details>

<details><summary>4. Check the quality of raw data (*)</summary>

## 4. Check the quality of raw data (*)

Execute `Multi_FASTQC.sh`:
```
[hpc-0373@wahab-01 4th_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_raw" "fqc_raw_report"  "fq.gz"
Submitted batch job 4627401
```
### MultiQC output (fq_raw/fqc_raw_report.html):
* 

```
‣ % duplication - 
    • Alb: 
‣ GC content - 
    • Alb: 
‣ number of reads - 
    • Alb: 
```

---
</details>
