<img src="http://www.fishbiosystem.ru/PERCIFORMES/Apogonidae/Foto/(Sphaeramia%20orbicularis)%2092f.jpg" alt="Sor" width="300"/>

# GenErode: *Sphaeramia orbicularis* lcWGS data from Pandanon Island.

Following the [GenErode pipeline](https://github.com/philippinespire/pire_lcwgs_data_processing/tree/main/scripts/GenErode_wahab) for *Sphaeramia orbicularis* lcWGS data from the 1st, 2nd, 3rd (CPnd), & 4th (ACeb) sequencing runs from Pandanon Island (ACeb & CPnd). 

The populations CBur, ABur, & ACan only have test lane sequences (forward and reverse reads) for 64, 16, & 55 individuals, respectively. CBur is a Contemporary duplicate of ABur & ACan, which can be combined. This site and dataset has been deprioritized, but could be used with more sequencing. There was no SSL genome for *Sphaeramia orbicularis* because an NCBI reference genome is available. The ancestral rates file was not generated because it is not needed for ANGSD. See notes below if this file is needed in the future.  

Working directory:
```
/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns
```

---

<details><summary>1. Set-Up</summary>

### 1. Set-up

Create the GenErode directory and subdirectory structure.
```
cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/

mkdir GenErode_Sor_20k_3seqruns

cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns

mkdir config historical modern reference gerp_outgroups mitochondria
```

Copy the contents of the template folder to your GenErode directory.
```
rsync -a /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/scripts/GenErode_wahab/GenErode_templatedir/ /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns &
```

Count and copy all \*.fq.gz files from the 1st, 2nd, 3rd, and 4th sequencing run fq_raw directories. The 3rd sequencing run was only the Contemporary population CPnd and the 4th sequencing run was only the Albatross population ACeb. Probes were designed from the NCBI genome, so there are no SSL sequences. Don't include any Undetermined\*.fq.gz files.

#### Historical
```
# 1st run ACeb w/ 1x paired fq raw files for 22 individuals
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/Sor-ACeb*.fq.gz | wc -l
44

rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/Sor-ACeb*.fq.gz /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/historical &

# 2nd run ACeb w/ 2x paired fq raw files for 22 individuals
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/Sor-ACeb*.fq.gz | wc -l
88

rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/Sor-ACeb*.fq.gz /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/historical &

# 4th run ACeb w/ 2x paired fq raw files for 22 individuals
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/4th_sequencing_run/fq_raw/Sor-ACeb*.fq.gz | wc -l
88

rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/4th_sequencing_run/fq_raw/Sor-ACeb*.fq.gz /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/historical &

# confirm all historical files were transferred
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/historical/Sor-ACeb*.fq.gz | wc -l
220
```

#### Modern
```
# 1st run CPnd w/ 1x paired fq raw files for 64 individuals
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/Sor-CPnd*.fq.gz | wc -l
128

rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/Sor-CPnd*.fq.gz /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/modern &

# 2nd run CPnd w/ 2x paired fq raw files for 48 individuals
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/Sor-CPnd*.fq.gz | wc -l
192

rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/Sor-CPnd*.fq.gz /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/modern &

# 3rd run CPnd w/ 1x paired fq raw files for 48 individuals
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/3rd_sequencing_run/fq_raw/Sor-CPnd*.fq.gz | wc -l
96

rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/3rd_sequencing_run/fq_raw/Sor-CPnd*.fq.gz /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/modern &

# confirm all modern files were transferred
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/modern/Sor-CPnd*.fq.gz | wc -l
416
```

#### Reference
Copy the NCBI reference genome from from the `GenErode_Sor_20k/reference` directory. The GenErode pipeline requires the 20k version (scaffolds > 20kbp) of the reference genome that was used for probe development and mkBAM. This was the GenBank [chromosome-level genome](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_902148855.1/). The script `removesmalls.pl` was used to remove sequences smaller than 20,000 base pairs to create the 20k NCBI reference genome. The script `mitofinder` was used to remove mitochondrial sequences, however it seems that this genome did not include mtDNA. 

Copy the NCBI reference genome. 
```
rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/reference &
```

#### GERP Outgroups
Copy the 30 `*.fa.gz` files of outgroup species genomes from the `GenErode_Sor_20k/gerp_outgroups` directory. 
```
rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups/*.fa.gz /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/gerp_outgroups &
```

</details>


<details><summary>2. Get Newick tree</summary>

### 2. Get Newick tree
Copy the dated phylogenetic tree files from the `GenErode_Sor_20k/gerp_outgroups` directory. These files were created from [TimeTree of Life](https://timetree.org/) with the 30 outgroup species and will be config files for the GenErode run. 
```
cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/gerp_outgroups

cp /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups/*.txt ./
cp /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups/*.nwk ./
cp /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups/*.jpg ./
```

<details><summary>gerp_tree.nwk</summary>
```
((((((Chelmon_rostratus:84.83588000,((Pagrus_major:46.50921000,Acanthopagrus_latus:46.50921000)'14':36.24452000,(Scatophagus_argus:81.72976000,Antennarius_maculatus:81.72976000)'13':1.02397000)'25':2.08215000)'37':1.10157000,Larimichthys_crocea:85.93745000)'36':10.77313000,(Cheilinus_undulatus:92.81956000,(Micropterus_dolomieu:9.13000000,Micropterus_salmoides:9.13000000)'35':83.68956000)'34':3.89102000)'43':6.86373000,(((Etheostoma_cragini:26.76663000,Etheostoma_spectabile:26.76663000)'33':5.73599000,Perca_flavescens:32.50262000)'51':44.47236000,(((Sebastes_schlegelii:75.22844000,(Anoplopoma_fimbria:47.36369000,(Cyclopterus_lumpus:45.92825000,Gasterosteus_aculeatus:45.92825000)'50':1.43544000)'49':27.86475000)'57':1.69136000,Cottoperca_gobio:76.91980000)'60':0.00362000,(Cromileptes_altivelis:50.51620000,Plectropomus_leopardus:50.51620000)'56':26.40722000)'48':0.05156000)'63':26.59933000)'47':8.65975000,(Channa_argus:103.76124000,(Oreochromis_niloticus:91.74830000,(Oryzias_latipes:84.82079000,Fundulus_heteroclitus:84.82079000)'68':6.92751000)'73':12.01294000)'72':8.47282000)'84':0.00000000,(((((Proterorhinus_semilunaris:52.85785000,(Knipowitschia_caucasica:51.52832000,(Mugilogobius_chulae:44.37451000,Rhinogobius_similis:44.37451000)'87':7.15381000)'83':1.32953000)'82':0.55820000,Periophthalmus_magnuspinnatus:53.41605000)'80':8.63806000,Bostrychus_sinensis:62.05411000)'79':0.00011000,Perccottus_glenii:62.05422000)'94':34.85638000,reference.genbank.Sor20k.fasta:96.91060000)'92':15.32346000);
```
</p>
</details>

</details>


<details><summary>3. Config Files</summary>

### 3. Config Files
1. Copy config scripts from the `GenErode_Sor_20k/config` directory. 
```
cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/config/

cp /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/config/*sh ./
cp /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/config/config.yaml ./
```

2. Edit the user-defined variables in the scripts `config_generode_old_new_lane.sh`, `config_historical_samples.sh`, `config_modern_samples.sh` to reflect your species. 
```
# User-defined variables for species and species code (Spp).
# For species use lowercase and an underscore so the directory path can be identified (e.g. lethrinus_variegatus)
species="sphaeramia_orbicularis"
# For Spp, this is the three letter species code. Capitalize the first letter.
Spp="Sor"
# Define the input files. Edit if necessary. Check SSL.
file1="${lcwgs_path}/1st_sequencing_run/fq_raw/old_new_filenames.log"
file2="${lcwgs_path}/2nd_sequencing_run/fq_raw/old_new_filenames.log"
file3="${lcwgs_path}/3rd_sequencing_run/fq_raw/old_new_filenames.log"
file4="${lcwgs_path}/4th_sequencing_run/fq_raw/old_new_filenames.log"
# Define the output path and file name
output_file="${lcwgs_path}/GenErode_${Spp}_20k_3seqruns/config/old_new_lane_GenErode_${Spp}_config.log
```

3. Identify all `old_new_config.log` files.

The `config_generode_old_new_lane.sh` script requires the `old_new_config.log` files from each fq_raw directory that will be used in GenErode.
```
# 1st run
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/old_new_filenames.log
grep 'Sor-ACeb' /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/old_new_filenames.log | wc -l
44
grep 'Sor-CPnd' /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/old_new_filenames.log | wc -l
128

# 2nd run 
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/old_new_filenames.log
grep 'Sor-ACeb' /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/old_new_filenames.log | wc -l
88
grep 'Sor-CPnd' /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/old_new_filenames.log | wc -l
192

# 3rd run 
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/3rd_sequencing_run/fq_raw/old_new_filenames.log
grep 'Sor-ACeb' /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/3rd_sequencing_run/fq_raw/old_new_filenames.log | wc -l
0
grep 'Sor-CPnd' /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/3rd_sequencing_run/fq_raw/old_new_filenames.log | wc -l
96

# 4th run 
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/4th_sequencing_run/fq_raw/old_new_filenames.log
grep 'Sor-ACeb' /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/4th_sequencing_run/fq_raw/old_new_filenames.log | wc -l
88
grep 'Sor-CPnd' /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/4th_sequencing_run/fq_raw/old_new_filenames.log | wc -l
0
```

4. Run `config_generode_old_new_lane.sh` 
```
bash config_generode_old_new_lane.sh
```

Output.
```
Including file: /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/old_new_filenames.log
Including file: /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/old_new_filenames.log
Including file: /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/3rd_sequencing_run/fq_raw/old_new_filenames.log
Including file: /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/4th_sequencing_run/fq_raw/old_new_filenames.log
Concatenation completed. Output saved to /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/config/old_new_lane_GenErode_Sor_config.log
```

Count the number of lines in the file `old_new_filenames.log` that begin with 'Sor-ACeb' and 'Sor-CPnd'. There should be 220 historical and 416 modern  files. 
```
# historical
cat old_new_lane_GenErode_Sor_config.log | grep 'Sor-ACeb' | wc -l
220

# modern
cat old_new_lane_GenErode_Sor_config.log | grep 'Sor-CPnd' | wc -l
416
```

5. Run `config_modern_samples.sh`.
```
bash config_modern_samples.sh
```

Output.
```
Modern samples processing completed. Output saved to modern_samples.txt
All 208 1.fq.gz and 208 2.fq.gz files were incorporated into modern_samples.txt
```
All 416 (2\*208) SorCPnd modern `*.fq.gz` files were incorporated into `modern_samples.txt`.

6. Run `config_historical_samples.sh`. 
```
bash config_historical_samples.sh
```

Output.
```
Historical samples processing completed. Output saved to historical_samples.txt
All 110 1.fq.gz and 110 2.fq.gz files were incorporated into historical_samples.txt
```
All 220 (2\*110) SorACeb historical `*.fq.gz` files were incorporated into `historical_samples.txt`.

7. Run `config_historical_rescaled_samplenames.sh` to get line 173: `historical_rescaled_samplenames:` for the `config.yaml` file. 
```
bash config_historical_rescaled_samplenames.sh
```

Contents of output file `historical_rescaled_samplenames.txt`.
```
cat historical_rescaled_samplenames.txt

"SorACeb001","SorACeb002","SorACeb003","SorACeb004","SorACeb005","SorACeb006","SorACeb007","SorACeb008","SorACeb009","SorACeb010","SorACeb011","SorACeb012","SorACeb013","SorACeb014","SorACeb015","SorACeb016","SorACeb017","SorACeb018","SorACeb019","SorACeb020","SorACeb021","SorACeb022"
```

7. Edit `config.yaml`.

<details><summary>config.yaml</summary>
```
line 23: ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/reference/reference.genbank.Sor20k.fasta"
line 31: historical_samples: "config/historical_samples.txt"
line 32: modern_samples: "config/modern_samples.txt"
Line 70: fastq_processing: True
line 89: map_historical_to_mitogenomes: False
line 165: historical_bam_mapDamage: True
line 173: historical_rescaled_samplenames: ["SorACeb001","SorACeb002","SorACeb003","SorACeb004","SorACeb005","SorACeb006","SorACeb007","SorACeb008","SorACeb009","SorACeb010","SorACeb011","SorACeb012","SorACeb013","SorACeb014","SorACeb015","SorACeb016","SorACeb017","SorACeb018","SorACeb019","SorACeb020","SorACeb021","SorACeb022"]
line 446: snpEff: False
line 455: gtf_path: ""
line 486: gerp: True
line 492: gerp_ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/gerp_outgroups"
line 501: tree: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/gerp_outgroups/gerp_tree.nwk"
```
</p>
</details>

</details>


<details><summary>4. Run GenErode</summary>

### 4. Run GenErode

Copy the `run_GenErode*.sbatch` files to the GenErode_Sor_20k_3seqruns directory.
```
cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns

cp /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/run_GenErode*.sbatch ./
```

Move to the GenErode_Sor_20k_3seqruns directory and run the script `run_GenErode.sbatch`.
```
sbatch run_GenErode.sbatch
```
JobID: 4843111

This job had the same issues with creating the ancestral rates file as previous runs did in the directory `GenErode_Sor_20k`. This is not needed for ANGSD, so the job was cancelled and the `config.yaml` file was edited (`line 486: gerp: False`) to set the GERP function to false, and the script was reran. If the ancestral rates file is needed in the future, create the gerp_outgroups directory from scratch. The species Cromileptes_altivelis was causing an error before, which occurred again on this run, so remove this species from the gerp_outgroups. Additionally, there were no Apogonids represented in the genomes of the GERP outgroup species, however there are several available on GenBank. This may have caused issues with generating the ancestral rates file. The GERP outgroup genomes were copied from the *Ostorhinchus chrysopomus* GenErode directory, but I'm not sure if this species had issues generating the ancestral rates file. 

Rerun the script `run_GenErode.sbatch`. 
```
# unlock
sbatch run_GenErode_unlock.sbatch

sbatch run_GenErode.sbatch
```
JobID: 4848217
10/24/25 @ 13:24

#### Modern
```
# modern expected
find /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/modern -maxdepth 1 -type f -name 'Sor-CPnd_*' -printf '%f\n' | cut -c 10-12 | sort | uniq | wc -l
64

# modern output *.merged.rmdup.merged.realn.bam
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/results/modern/mapping/reference.genbank.Sor20k/*.merged.rmdup.merged.realn.bam | wc -l
64

# modern output *.merged.rmdup.merged.realn.bai
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/results/modern/mapping/reference.genbank.Sor20k/*.merged.rmdup.merged.realn.bai | wc -l
64
```
GenErode successfully created all 64 modern `\*.merged.rmdup.merged.realn.bam` & `\*.merged.rmdup.merged.realn.bai` files. These were all generated with the 1st run (JobID: 4843111). 


#### Historical
```
# historical expected
find /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/historical -maxdepth 1 -type f -name 'Sor-ACeb_*' -printf '%f\n' | cut -c 10-12 | sort | uniq | wc -l
22

# historical output *.merged.rmdup.merged.realn.bam
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/results/historical/mapping/reference.genbank.Sor20k/*.merged.rmdup.merged.realn.bam | wc -l
22

# historical output *.merged.rmdup.merged.realn.bai
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/results/historical/mapping/reference.genbank.Sor20k/*.merged.rmdup.merged.realn.bai | wc -l
21
```
GenErode successfully created all 22 historical `.merged.rmdup.merged.realn.bam` & `.merged.rmdup.merged.realn.bai`files. All of these files were generated on the 2nd run (JobID: 4848217). Most files took ~2.5 days to generate. However, it took a total of 12 days to generate all files. There are 10 files per sample. 

#### Ancestral Rates
Did not generate these. It is not needed for ANGSD. If needed in the future. Just run the gerp not the samples. However, the gerp_outgroups should be started from scratch. See notes above. 
```
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_3seqruns/results/gerp/reference.genbank.Sor20k.ancestral.rates.gz
```

</details>


<details><summary>5. Clean up</summary>

### 5. Clean up

Move `\*.out` files to logs directory.  
```
mv *.out logs
```

Delete large, redundant `.fq.gz` input files from the `historical` and `modern` directories. These were initially copied into this directory from the fq_raw directories. 
```
rm -rf historical/*.fq.gz

rm -rf modern/*.fq.gz
```

</details>
