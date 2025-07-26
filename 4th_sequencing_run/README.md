<img src="http://www.fishbiosystem.ru/PERCIFORMES/Apogonidae/Foto/(Sphaeramia%20orbicularis)%2092f.jpg" alt="Sor" width="300"/>

# *Sphaeramia orbicularis* lcWGS Analysis 

## 4th Sequencing Run

Analysis of low-coverage whole genome sequencing data for *Sphaeramia orbicularis* from Cebu City Market (ACeb). **Only Albatross individuals were re-sequenced for this run.**

fq.gz processing done by Gianna Mazzei (June 2025).

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


---
</details>
