<img src="http://www.fishbiosystem.ru/PERCIFORMES/Apogonidae/Foto/(Sphaeramia%20orbicularis)%2092f.jpg" alt="Sor" width="300"/>

# *Sphaeramia orbicularis* lcWGS Analysis 

## 2nd Sequencing Run

Analysis of low-coverage whole genome sequencing data for *Sphaeramia orbicularis* from Cebu City Market (ACeb) and Pandanon Island (CPnd). 

_Many reads were undetermined. Pre-processing is being done regardless._

---

## fq.gz Pre-processing

This portion follows the instructions in the [pire_fq_gz_processing](https://github.com/philippinespire/pire_fq_gz_processing) repository. 

→ (*) _denotes steps with MultiQC Report Analyses_

<details><summary>1. Set-up</summary>

### 1. Set-up

Make 2nd sequencing run directory and a README.
```
cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs

mkdir 2nd_sequencing_run

cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run

nano README.md
```
---
</details>


<details><summary>2. Get raw data</summary>

### 2. Get raw data

Copy raw \*.fq.gz files from the downloads directory.
```
rsync -r /archive/carpenterlab/pire/downloads/sphaeramia_orbicularis/2nd_sequencing_run/fq_raw /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/ &
```

It seems that half of the \*.fq.gz files were lost in the renaming process for the original 2nd sequencing run directory. The samples were sequenced twice in different lanes and the original file names were all the same except for the lane ID (L2 & L3). I think `renameFQGZ.bash` takes into account the lane ID, but the `Sor_lcwgs-SeqLane_SequenceNameDecode.tsv` file does not have lane IDs and only has half of the lines that it should, so the files were overwritten. After a cursory glance at a couple of \*.fq.gz files, it looks like L2 files were overwritten by L3 files. That original 2nd sequencing run directory progressed through pire_fq_gz_processing & pire_lcwgs_data_processing. It was renamed to `2nd_sequencing_run_deprecated` and this new directory was started on 1/22/2025. 
```
# number of raw *.fq.gz files in the downloads directory
ls /archive/carpenterlab/pire/downloads/sphaeramia_orbicularis/2nd_sequencing_run/fq_raw/*.fq.gz | wc -l
284

# number of raw *.fq.gz files in the now deprecated directory after they were renamed
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run_deprecated/fq_raw/*.fq.gz | wc -l 
142

# number of lines with the columns Sequence_Name & Extraction_ID in the rename decode.tsv file
wc -l /archive/carpenterlab/pire/downloads/sphaeramia_orbicularis/2nd_sequencing_run/fq_raw/Sor_lcwgs-SeqLane_SequenceNameDecode.tsv
71
```

Confirm all 284 raw \*.fq.gz files have been copied to the working directory.
```
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/*.fq.gz | wc -l
284
```

Count the number of *Undetermined* files.
```
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/Undetermined*.fq.gz | wc -l
4 
```
The *Undetermined* files are not included in the decode file. Undetermined files just become `Undetermined-L#-1.fq.gz` & `Undetermined-L#-2.fq.gz`.

Count the number of *determined* files.
```
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/So*.fq.gz | wc -l
280
```
The `Sor_lcwgs-SeqLane_SequenceNameDecode.tsv` file should have 141 total lines not 71. There are 280 So\*.fq.gz and each forward and reverse read get their own line, so it should be 140 file names and 1 header column with Sequence_Name & Extraction_ID.

---
</details>


<details><summary>3. Proofread the decode file</summary>

### 3. Proofread the decode file

Investigate the issue with the decode file `Sor_lcwgs-SeqLane_SequenceNameDecode.tsv`.
```
cd fq_raw

cat Sor_lcwgs-SeqLane_SequenceNameDecode.tsv
```

<details><summary>Sor_lcwgs-SeqLane_SequenceNameDecode.tsv</summary>

```
Sequence_Name   Extraction_ID
SoA0100108E     Sor-ACeb_001-Ex1-8E-lcwgs-1-2
SoA0100209E     Sor-ACeb_002-Ex1-9E-lcwgs-1-2
SoA0100310E     Sor-ACeb_003-Ex1-10E-lcwgs-1-2
SoA0100411E     Sor-ACeb_004-Ex1-11E-lcwgs-1-2
SoA0100512E     Sor-ACeb_005-Ex1-12E-lcwgs-1-2
SoA0100601F     Sor-ACeb_006-Ex1-1F-lcwgs-1-2
SoA0100702F     Sor-ACeb_007-Ex1-2F-lcwgs-1-2
SoA0100803F     Sor-ACeb_008-Ex1-3F-lcwgs-1-2
SoA0100904F     Sor-ACeb_009-Ex1-4F-lcwgs-1-2
SoA0101005F     Sor-ACeb_010-Ex1-5F-lcwgs-1-2
SoA0101106F     Sor-ACeb_011-Ex1-6F-lcwgs-1-2
SoA0101207F     Sor-ACeb_012-Ex1-7F-lcwgs-1-2
SoA0101308F     Sor-ACeb_013-Ex1-8F-lcwgs-1-2
SoA0101409F     Sor-ACeb_014-Ex1-9F-lcwgs-1-2
SoA0101510F     Sor-ACeb_015-Ex1-10F-lcwgs-1-2
SoA0101611F     Sor-ACeb_016-Ex1-11F-lcwgs-1-2
SoA0101712F     Sor-ACeb_017-Ex1-12F-lcwgs-1-2
SoA0101801G     Sor-ACeb_018-Ex1-1G-lcwgs-1-2
SoA0101903G     Sor-ACeb_019-Ex1-3G-lcwgs-1-2
SoA0102002G     Sor-ACeb_020-Ex1-2G-lcwgs-1-2
SoA0102104G     Sor-ACeb_021-Ex1-4G-lcwgs-1-2
SoA0102205G     Sor-ACeb_022-Ex1-5G-lcwgs-1-2
SoC0600103E     Sor-CPnd_001-Ex1-3E-lcwgs-1-2
SoC0600205E     Sor-CPnd_002-Ex1-5E-lcwgs-1-2
SoC0600302B     Sor-CPnd_003-Ex1-2B-lcwgs-1-2
SoC0600401G     Sor-CPnd_004-Ex1-1G-lcwgs-1-2
SoC0600503D     Sor-CPnd_005-Ex1-3D-lcwgs-1-2
SoC0600602D     Sor-CPnd_006-Ex1-2D-lcwgs-1-2
SoC0600701C     Sor-CPnd_007-Ex1-1C-lcwgs-1-2
SoC0600801A     Sor-CPnd_008-Ex1-1A-lcwgs-1-2
SoC0600906A     Sor-CPnd_009-Ex1-6A-lcwgs-1-2
SoC0601001H     Sor-CPnd_010-Ex1-1H-lcwgs-1-2
SoC0601205B     Sor-CPnd_012-Ex1-5B-lcwgs-1-2
SoC0601307F     Sor-CPnd_013-Ex1-7F-lcwgs-1-2
SoC0601401F     Sor-CPnd_014-Ex1-1F-lcwgs-1-2
SoC0601505F     Sor-CPnd_015-Ex1-5F-lcwgs-1-2
SoC0601601B     Sor-CPnd_016-Ex1-1B-lcwgs-1-2
SoC0601703G     Sor-CPnd_017-Ex1-3G-lcwgs-1-2
SoC0601801E     Sor-CPnd_018-Ex1-1E-lcwgs-1-2
SoC0601906G     Sor-CPnd_019-Ex1-6G-lcwgs-1-2
SoC0602002E     Sor-CPnd_020-Ex1-2E-lcwgs-1-2
SoC0602207C     Sor-CPnd_022-Ex1-7C-lcwgs-1-2
SoC0602405G     Sor-CPnd_024-Ex1-5G-lcwgs-1-2
SoC0602603H     Sor-CPnd_026-Ex1-3H-lcwgs-1-2
SoC0602703C     Sor-CPnd_027-Ex1-3C-lcwgs-1-2
SoC0602803A     Sor-CPnd_028-Ex1-3A-lcwgs-1-2
SoC0602908E     Sor-CPnd_029-Ex1-8E-lcwgs-1-2
SoC0603002H     Sor-CPnd_030-Ex1-2H-lcwgs-1-2
SoC0603105D     Sor-CPnd_031-Ex1-5D-lcwgs-1-2
SoC0603302F     Sor-CPnd_033-Ex1-2F-lcwgs-1-2
SoC0603404G     Sor-CPnd_034-Ex1-4G-lcwgs-1-2
SoC0603605C     Sor-CPnd_036-Ex1-5C-lcwgs-1-2
SoC0603706C     Sor-CPnd_037-Ex1-6C-lcwgs-1-2
SoC0603802A     Sor-CPnd_038-Ex1-2A-lcwgs-1-2
SoC0604107A     Sor-CPnd_041-Ex1-7A-lcwgs-1-2
SoC0604301D     Sor-CPnd_043-Ex1-1D-lcwgs-1-2
SoC0604408G     Sor-CPnd_044-Ex1-8G-lcwgs-1-2
SoC0604507B     Sor-CPnd_045-Ex1-7B-lcwgs-1-2
SoC0604605A     Sor-CPnd_046-Ex1-5A-lcwgs-1-2
SoC0604903B     Sor-CPnd_049-Ex1-3B-lcwgs-1-2
SoC0605003F     Sor-CPnd_050-Ex1-3F-lcwgs-1-2
SoC0605206D     Sor-CPnd_052-Ex1-6D-lcwgs-1-2
SoC0605302C     Sor-CPnd_053-Ex1-2C-lcwgs-1-2
SoC0605408F     Sor-CPnd_054-Ex1-8F-lcwgs-1-2
SoC0605507G     Sor-CPnd_055-Ex1-7G-lcwgs-1-2
SoC0605802G     Sor-CPnd_058-Ex1-2G-lcwgs-1-2
SoC0606307D     Sor-CPnd_063-Ex1-7D-lcwgs-1-2
SoC0606608B     Sor-CPnd_066-Ex1-8B-lcwgs-1-2
SoC0606906B     Sor-CPnd_069-Ex1-6B-lcwgs-1-2
SoC0607208C     Sor-CPnd_072-Ex1-8C-lcwgs-1-2
```

</p>
</details>

Compare the decode file to the actual raw \*.fq.gz files. 

Make the file `origFileNames_ALL.txt` with all of the original file names. 
```
ls So*.fq.gz > origFileNames_ALL.txt
```

Add a header line to `origFileNames_ALL.txt` with the column names `Sequence_Name` & `Extraction_ID'.
```
sed -i '1i Sequence_Name\tExtraction_ID' origFileNames_ALL.txt
```

<details><summary>origFileNames_ALL.txt</summary>

```
Sequence_Name   Extraction_ID
SoA0100108E_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0100108E_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0100108E_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0100108E_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0100209E_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0100209E_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0100209E_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0100209E_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0100310E_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0100310E_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0100310E_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0100310E_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0100411E_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0100411E_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0100411E_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0100411E_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0100512E_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0100512E_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0100512E_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0100512E_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0100601F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0100601F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0100601F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0100601F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0100702F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0100702F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0100702F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0100702F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0100803F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0100803F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0100803F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0100803F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0100904F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0100904F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0100904F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0100904F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0101005F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0101005F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0101005F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0101005F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0101106F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0101106F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0101106F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0101106F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0101207F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0101207F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0101207F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0101207F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0101308F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0101308F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0101308F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0101308F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0101409F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0101409F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0101409F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0101409F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0101510F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0101510F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0101510F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0101510F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0101611F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0101611F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0101611F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0101611F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0101712F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0101712F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0101712F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0101712F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0101801G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0101801G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0101801G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0101801G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0101903G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0101903G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0101903G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0101903G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0102002G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0102002G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0102002G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0102002G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0102104G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0102104G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0102104G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0102104G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoA0102205G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoA0102205G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoA0102205G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoA0102205G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0600103E_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0600103E_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0600103E_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0600103E_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0600205E_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0600205E_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0600205E_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0600205E_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0600302B_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0600302B_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0600302B_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0600302B_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0600401G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0600401G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0600401G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0600401G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0600503D_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0600503D_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0600503D_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0600503D_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0600602D_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0600602D_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0600602D_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0600602D_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0600701C_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0600701C_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0600701C_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0600701C_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0600801A_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0600801A_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0600801A_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0600801A_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0600906A_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0600906A_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0600906A_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0600906A_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0601001H_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0601001H_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0601001H_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0601001H_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0601205B_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0601205B_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0601205B_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0601205B_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0601307F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0601307F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0601307F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0601307F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0601401F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0601401F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0601401F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0601401F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0601505F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0601505F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0601505F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0601505F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0601601B_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0601601B_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0601601B_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0601601B_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0601703G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0601703G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0601703G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0601703G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0601801E_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0601801E_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0601801E_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0601801E_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0601906G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0601906G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0601906G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0601906G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0602002E_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0602002E_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0602002E_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0602002E_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0602207C_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0602207C_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0602207C_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0602207C_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0602405G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0602405G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0602405G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0602405G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0602603H_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0602603H_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0602603H_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0602603H_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0602703C_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0602703C_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0602703C_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0602703C_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0602803A_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0602803A_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0602803A_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0602803A_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0602908E_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0602908E_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0602908E_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0602908E_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0603002H_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0603002H_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0603002H_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0603002H_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0603105D_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0603105D_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0603105D_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0603105D_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0603302F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0603302F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0603302F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0603302F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0603404G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0603404G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0603404G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0603404G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0603605C_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0603605C_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0603605C_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0603605C_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0603706C_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0603706C_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0603706C_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0603706C_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0603802A_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0603802A_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0603802A_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0603802A_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0604107A_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0604107A_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0604107A_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0604107A_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0604301D_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0604301D_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0604301D_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0604301D_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0604408G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0604408G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0604408G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0604408G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0604507B_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0604507B_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0604507B_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0604507B_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0604605A_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0604605A_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0604605A_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0604605A_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0604903B_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0604903B_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0604903B_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0604903B_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0605003F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0605003F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0605003F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0605003F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0605206D_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0605206D_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0605206D_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0605206D_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0605302C_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0605302C_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0605302C_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0605302C_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0605408F_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0605408F_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0605408F_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0605408F_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0605507G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0605507G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0605507G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0605507G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0605802G_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0605802G_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0605802G_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0605802G_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0606307D_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0606307D_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0606307D_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0606307D_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0606608B_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0606608B_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0606608B_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0606608B_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0606906B_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0606906B_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0606906B_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0606906B_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
SoC0607208C_CKDL230038844-1A_22FF32LT3_L2_1.fq.gz
SoC0607208C_CKDL230038844-1A_22FF32LT3_L2_2.fq.gz
SoC0607208C_CKDL230038844-1A_22FF32LT3_L3_1.fq.gz
SoC0607208C_CKDL230038844-1A_22FF32LT3_L3_2.fq.gz
```

</p>
</details>

Create a script `process_decode_FileNames_all.sh` to use the input files `Sor_lcwgs-SeqLane_SequenceNameDecode.tsv` & `origFileNames_ALL.txt` to create the decode file `Sor_lcwgs-SeqLane_SequenceNameDecode_ALL.tsv` with all of the file names including the lane ID. This output file .tsv should have 141 lines, including a header with 140 file names. 

Create the script `process_decode_FileNames_all.sh`. 

<details><summary>process_decode_FileNames_all.sh</summary>

```
#!/bin/bash

# Define input and output files
TSV_FILE="Sor_lcwgs-SeqLane_SequenceNameDecode.tsv"
TXT_FILE="origFileNames_ALL.txt"
OUTPUT_FILE="Sor_lcwgs-SeqLane_SequenceNameDecode_ALL.tsv"

# Ensure input files exist
if [[ ! -f "$TSV_FILE" || ! -f "$TXT_FILE" ]]; then
  echo "Error: One or both input files are missing!"
  exit 1
fi

# Create a temporary file for mapping Sequence_Name to Extraction_ID
awk -F'\t' 'NR>1 {print $1, $2}' "$TSV_FILE" > seq_map.tmp

# Prepare a temporary file for unique values
TEMP_OUTPUT="temp_output.tsv"
echo -e "Sequence_Name\tExtraction_ID" > "$TEMP_OUTPUT"

# Process each line in the input TXT file (excluding header)
tail -n +2 "$TXT_FILE" | while read -r line; do
  # Remove the last 8 characters from Sequence_Name
  sequence_name_trimmed="${line:0:-8}"

  # Extract the prefix (characters before the first underscore)
  prefix=$(echo "$line" | cut -d'_' -f1)

  # Find corresponding Extraction_ID from seq_map.tmp
  extraction_id=$(awk -v pfx="$prefix" '$1 == pfx {print $2}' seq_map.tmp)

  # If no match is found, assign "UNKNOWN"
  [[ -z "$extraction_id" ]] && extraction_id="UNKNOWN"

  # Write to temporary output file
  echo -e "$sequence_name_trimmed\t$extraction_id" >> "$TEMP_OUTPUT"
done

# Sort and remove duplicate lines, then save as final output file
sort -u "$TEMP_OUTPUT" > "$OUTPUT_FILE"

# Cleanup temporary files
rm seq_map.tmp "$TEMP_OUTPUT"

echo "Processing complete. Output saved to $OUTPUT_FILE"
```

</p>
</details>

Run the script `process_decode_FileNames_all.sh`.
```
bash process_decode_FileNames_all.sh
```

Output:
```
Processing complete. Output saved to Sor_lcwgs-SeqLane_SequenceNameDecode_ALL.tsv
```

Check output file `Sor_lcwgs-SeqLane_SequenceNameDecode_ALL.tsv`. 
```
cat Sor_lcwgs-SeqLane_SequenceNameDecode_ALL.tsv | wc -l
141
```
This is the correct number of lines for the decode file. 

---
</details>


<details><summary>4. Perform a renaming dry run</summary>

### 4. Perform a renaming dry run

Use the script `renameFQGZ_keeplane2.bash` to rename the files instead of `renameFQGZ.bash`, because the lane ID needs to be maintained between the original file name and the new file name. 

Perform a renaming dry run.
```
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ_keeplane2.bash Sor_lcwgs-SeqLane_SequenceNameDecode_ALL.tsv
```
The decode dry run looks good!

---
</details>


<details><summary>5. Rename the files</summary>

### 5. Rename the files

Rename the files for real with `renameFQGZ_keeplane2.bash`.
```
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ_keeplane2.bash Sor_lcwgs-SeqLane_SequenceNameDecode_ALL.tsv rename
```

Check the total number of \*.fq.gz files.
```
ls *.fq.gz | wc -l
284
```

All files were correctly renamed and all files were maintained! New file names include the lane ID. 

---
</details>


<details><summary>6. Check PHRED quality scores of Undetermined\*.fq.gz files</summary>

### 6. Check PHRED quality scores of Undetermined\*.fq.gz files

1. Create a new directory to analyze raw .fq.gz file phred quality scores.
```
cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run

mkdir fq_raw_phred
```

2. Create a List of .fq.gz File Names.

Run the following command to generate a .txt file containing the list of all .fq.gz files in the directory:
```
ls fq_raw/*.fq.gz > fq_file_list.txt
```

3. Create a Bash Script to Extract the First 100 Reads.

Create a script called `extract_reads.sh`:
```
#!/bin/bash

# Define the number of lines to extract (100 reads = 400 lines)
NUM_LINES=400

# Ensure the output directory exists
mkdir -p fq_raw_phred

# Read file names from fq_file_list.txt and process each file
while read -r fq_file; do
    # Extract only the filename (basename) without the full path
    filename=$(basename "$fq_file")

    # Generate output file name within fq_raw_phred/
    output_file="fq_raw_phred/${filename%.fq.gz}_subset.fastq"

    # Extract the first 100 reads (400 lines) and save to the output file
    zcat "$fq_file" | head -n $NUM_LINES > "$output_file"

    # Print status message
    echo "Extracted first 100 reads from $fq_file into $output_file"
done < fq_file_list.txt
```

4. Run the script `extract_reads.sh`.
```
bash extract_reads.sh
```

5. Create a List of Subset FASTQ Files.
```
ls fq_raw_phred/*.fastq > fq_phred_file_list.txt
```

6. Create a Script to Extract Quality Scores.

Create a script named `extract_phred_scores.sh` in 2nd_sequencing_run/:
```
#!/bin/bash

# Ensure output directory exists
mkdir -p fq_raw_phred_scores

# Read each subset FASTQ file from the list
while read -r fastq_file; do
    # Extract only the filename (without path)
    filename=$(basename "$fastq_file")

    # Define the output file name inside fq_raw_phred_scores
    output_file="fq_raw_phred_scores/${filename%.fastq}_quality.txt"

    # Extract only the Phred quality score lines (every 4th line in the FASTQ file)
    awk 'NR%4==0' "$fastq_file" > "$output_file"

    echo "Extracted quality scores from $fastq_file to $output_file"
done < fq_phred_file_list.txt
```

7. Run the script. 
```
bash extract_phred_scores.sh
```

8. Convert ASCII-Encoded Quality Scores to Numeric Phred Scores.

Create a Python script to convert ASCII scores to numeric Phred scores. Save this as convert_phred.py inside 2nd_sequencing_run/:
```
import numpy as np
import os

# Function to convert ASCII-encoded Phred quality scores to numeric values
def phred_to_qscore(quality_str):
    return [ord(q) - 33 for q in quality_str.strip()]

# Define input/output directories
input_dir = "fq_raw_phred_scores"
output_dir = "fq_raw_phred_scores_numeric"
os.makedirs(output_dir, exist_ok=True)

# Process each quality score file
for quality_file in os.listdir(input_dir):
    if quality_file.endswith("_quality.txt"):
        input_path = os.path.join(input_dir, quality_file)
        output_path = os.path.join(output_dir, quality_file.replace("_quality.txt", "_phred_scores.csv"))

        # Read quality scores and convert to Phred scores
        with open(input_path, 'r') as infile:
            all_scores = [phred_to_qscore(line) for line in infile]

        # Convert to NumPy array for easy calculations
        scores_array = np.array(all_scores)

        # Save as CSV for further analysis
        np.savetxt(output_path, scores_array, delimiter=",", fmt="%d")

        print(f"Converted {quality_file} to numeric Phred scores -> {output_path}")
```

9. Run the script `convert_phred.py`.
```
module load container_env python3

crun.python3 python convert_phred.py
```

10. Verify the Output

Now, the numeric Phred scores should be stored in fq_raw_phred_scores_numeric/ as CSV files. Each file (e.g., Undetermined_1_subset_phred_scores.csv) will contain Phred scores as numerical values.

Check the directory:
```
ls fq_raw_phred_scores_numeric/
```

11. Compare Phred Scores Between Undetermined and Sample Reads.

Once the CSV files are generated, we can analyze the scores. Plot Quality Score Distributions. Create plot_phred.py inside 2nd_sequencing_run/:
```
import numpy as np
import matplotlib.pyplot as plt
import os
import scipy.stats as stats

# Define input directory
input_dir = "fq_raw_phred_scores_numeric"

# Lists to store Phred quality scores
undetermined_scores = []
sample_scores = []

# Read all numeric Phred score CSV files
for file in os.listdir(input_dir):
    if file.endswith("_phred_scores.csv"):
        filepath = os.path.join(input_dir, file)
        data = np.loadtxt(filepath, delimiter=",")

        # Compute mean Phred score per read
        mean_scores = np.mean(data, axis=1)

        # Categorize the scores based on filename
        if "Undetermined" in file:
            undetermined_scores.extend(mean_scores)
        else:
            sample_scores.extend(mean_scores)

# Convert to NumPy arrays for statistical analysis
undetermined_scores = np.array(undetermined_scores)
sample_scores = np.array(sample_scores)

# Create a histogram
plt.figure(figsize=(10, 6))
plt.hist(undetermined_scores, bins=20, alpha=0.5, label="Undetermined Reads", color="red", edgecolor='black')
plt.hist(sample_scores, bins=20, alpha=0.5, label="Sample Reads", color="blue", edgecolor='black')
plt.xlabel("Mean Phred Quality Score")
plt.ylabel("Read Count")
plt.legend()
plt.title("Quality Score Distribution: Undetermined vs. Sample Reads")

# Save histogram to file
histogram_path = "quality_score_comparison.png"
plt.savefig(histogram_path, dpi=300)
print(f"Histogram saved to {histogram_path}")

# Perform t-test
t_stat, p_value = stats.ttest_ind(undetermined_scores, sample_scores, equal_var=False)

# Print results
print("\nStatistical Analysis (T-Test Results)")
print(f"T-Statistic: {t_stat:.4f}")
print(f"P-Value: {p_value:.4e}")

# Save results to a text file
with open("quality_score_analysis.txt", "w") as f:
    f.write("Statistical Analysis (T-Test Results)\n")
    f.write(f"T-Statistic: {t_stat:.4f}\n")
    f.write(f"P-Value: {p_value:.4e}\n")

print("Statistical analysis saved to quality_score_analysis.txt")
```

12. Run the Plotting Script
```
crun.python3 python plot_phred.py
```

Output:
```
Histogram saved to quality_score_comparison.png

Statistical Analysis (T-Test Results)
T-Statistic: 0.0779
P-Value: 9.3792e-01
Statistical analysis saved to quality_score_analysis.txt
```

13. Python Script to Calculate Average & Standard Deviation of Phred Quality Scores.

This `compute_phred_stats.py` script:
- Computes the mean and standard deviation of Phred quality scores.
- Separates results for Undetermined and Sample files.
- Saves the results in phred_quality_stats.txt.
```
import numpy as np
import os

# Define input directory
input_dir = "fq_raw_phred_scores_numeric"

# Lists to store Phred quality scores
undetermined_scores = []
sample_scores = []

# Read all numeric Phred score CSV files
for file in os.listdir(input_dir):
    if file.endswith("_phred_scores.csv"):
        filepath = os.path.join(input_dir, file)
        data = np.loadtxt(filepath, delimiter=",")

        # Compute mean Phred score per read
        mean_scores = np.mean(data, axis=1)

        # Categorize the scores based on filename
        if "Undetermined" in file:
            undetermined_scores.extend(mean_scores)
        else:
            sample_scores.extend(mean_scores)

# Convert lists to NumPy arrays
undetermined_scores = np.array(undetermined_scores)
sample_scores = np.array(sample_scores)

# Compute statistics
undetermined_mean = np.mean(undetermined_scores)
undetermined_std = np.std(undetermined_scores)

sample_mean = np.mean(sample_scores)
sample_std = np.std(sample_scores)

# Print results to console
print("\nPhred Quality Score Statistics")
print(f"Undetermined Reads - Mean: {undetermined_mean:.2f}, Std Dev: {undetermined_std:.2f}")
print(f"Sample Reads - Mean: {sample_mean:.2f}, Std Dev: {sample_std:.2f}")

# Save results to a text file
with open("phred_quality_stats.txt", "w") as f:
    f.write("Phred Quality Score Statistics\n")
    f.write(f"Undetermined Reads - Mean: {undetermined_mean:.2f}, Std Dev: {undetermined_std:.2f}\n")
    f.write(f"Sample Reads - Mean: {sample_mean:.2f}, Std Dev: {sample_std:.2f}\n")

print("\nStatistics saved to phred_quality_stats.txt")
```

14. Run the `compute_phred_stats.py` script:
```
crun.python3 python compute_phred_stats.py
```

Output:
```
Phred Quality Score Statistics
Undetermined Reads - Mean: 37.95, Std Dev: 2.82
Sample Reads - Mean: 37.94, Std Dev: 3.15
```

There is not a significant difference between the phred quality score of the first 100 reads of the Undetermined\*.fq.gz files compared to the Sor\*.fq.gz files for the 2nd sequencing run. 

---
</details>

<details><summary>7. Check the quality of raw data (*)</summary>

## 7. Check the quality of raw data (*)

Execute `Multi_FASTQC.sh`:
```
[hpc-0373@wahab-01 2nd_sequencing_run]$ sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_raw" "fqc_raw_report"  "fq.gz"
Submitted batch job 4188441
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
