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
