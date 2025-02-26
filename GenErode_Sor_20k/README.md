<img src="http://www.fishbiosystem.ru/PERCIFORMES/Apogonidae/Foto/(Sphaeramia%20orbicularis)%2092f.jpg" alt="Sor" width="300"/>

# GenErode: *Sphaeramia orbicularis* lcWGS data from Pandanon Island.

Following the [GenErode pipeline](https://github.com/philippinespire/pire_lcwgs_data_processing/tree/main/scripts/GenErode_wahab) for *Sphaeramia orbicularis* lcWGS data from the 1st & 2nd sequencing runs from multiple sites, including Pandanon Island. 

```
/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k
```

---

<details><summary>1. Set-Up</summary>

### 1. Set-up

There were a lot of undetermined sequences that were put in the undetermined files. This may need to be resequenced. 

Create the GenErode directory and subdirectory structure.
```
cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/

mkdir GenErode_Sor_20k

cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k

mkdir config historical modern reference gerp_outgroups mitochondria
```

Copy the contents of the template folder to your GenErode directory.
```
rsync -a /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/scripts/GenErode_wahab/GenErode_templatedir/ /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k &
```

Count and copy all \*.fq.gz files from the 1st and 2nd sequencing run fq_raw directories. Probes were designed from the NCBI genome, so there are no SSL sequences. Don't include any Undetermined\*.fq.gz files.

#### Historical
```
# 1st run Ceb
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/Sor-ACeb*.fq.gz | wc -l
44

rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/Sor-ACeb*.fq.gz /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/historical &

# 2nd run Ceb
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/Sor-ACeb*.fq.gz | wc -l
88

rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/Sor-ACeb*.fq.gz /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/historical &

#confirm all historical files were transferred
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/historical/Sor-ACeb*.fq.gz | wc -l
132
```

#### Modern
```
# 1st run Pnd
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/Sor-CPnd*.fq.gz | wc -l
128

rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/Sor-CPnd*.fq.gz /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/modern &

# 2nd run Pnd
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/Sor-CPnd*.fq.gz | wc -l
192

rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/Sor-CPnd*.fq.gz /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/modern &

#confirm all modern files were transferred
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/modern/Sor-CPnd*.fq.gz | wc -l
320
```

#### Reference

Use the 20k version (scaffolds > 20kbp) of the reference genome that was used for probe development and mkBAM. This was the GenBank genome. A 20k reference genome needs to be created. 

If there is no 20k reference genome, create it. First copy the best reference genome (e.g. `scaffolds.fasta`) to the `GenErode_Spp_20k/reference` directory.
```
2nd seq run mkBAM mapping
/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/refGenome/GCF_902148855.1_fSphaOr1.1_genomic.fna.gz
https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_902148855.1/
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/902/148/855/GCF_902148855.1_fSphaOr1.1/GCF_902148855.1_fSphaOr1.1_genomic.fna.gz

SSL/Probe Design
/archive/carpenterlab/pire/pire_ssl_data_processing/sphaeramia_orbicularis/probe_design/GCA_902148855.1_fSphaOr1.1_genomic.fna.gz
wget https://ftp.ncbi.nlm.nih.gov/genomes/genbank/vertebrate_other/Sphaeramia_orbicularis/latest_assembly_versions/GCA_902148855.1_fSphaOr1.1/GCA_902148855.1_fSphaOr1.1_genomic.fna.gz
```

Get the [chromosome-level genome](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_902148855.1/) of *Sphaeramia orbicularis* from NCBI.
```
cd /archive/carpenterlab/pire/pire_genus_species_lcwgs/GenErode_Spp_20k/reference

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/902/148/855/GCF_902148855.1_fSphaOr1.1/GCF_902148855.1_fSphaOr1.1_genomic.fna.gz
```

Create 20k reference genome `reference.genbank.Sor20k.fasta` from the NCBI genome `GCF_902148855.1_fSphaOr1.1_genomic.fna.gz`.
```
perl /home/e1garcia/shotgun_PIRE/REUs/2022_REU/PSMC/scripts/removesmalls.pl 20000 GCF_902148855.1_fSphaOr1.1_genomic.fasta > reference.genbank.Sor20k.fasta
```

Use MitoFinder to create a mitochondrial reference genome from the NCBI reference genome.

Move to the reference directory. Unzip the NCBI reference genome.
```
cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference

gunzip GCF_902148855.1_fSphaOr1.1_genomic.fna.gz
```

Rename the unzipped NCBI reference genome to a .fasta file. 
```
mv GCF_902148855.1_fSphaOr1.1_genomic.fna GCF_902148855.1_fSphaOr1.1_genomic.fasta
```

Copy the Apogonidae.gb MitoFinder reference panel. 
```
cp /archive/carpenterlab/pire/pire_ssl_data_processing/scripts/mitofinder_refpanel/Apogonidae.gb ./
```

Copy and rename the MitoFinder script. 
```
cp /archive/carpenterlab/pire/pire_ssl_data_processing/scripts/run_mitofinder_ssl.sbatch ./run_mitofinder_ncbi_sor.sbatch
```

Edit the MitoFinder script. 
```
nano run_mitofinder_ncbi_sor.sbatch

#!/bin/bash -l

#SBATCH --job-name=mitofinder
#SBATCH -o mitofinder-%j.out
#SBATCH --time=00:00:00
#SBATCH -p main
#SBATCH --cpus-per-task=1

enable_lmod

module load container_env mitofinder/1.4.1
export SINGULARITY_BIND=/home/e1garcia

crun mitofinder -j Sor_genbank_Apogonidae -a GCF_902148855.1_fSphaOr1.1_genomic.fasta -r Apogonidae.gb -o 2
```

Run mitofinder:
```
sbatch run_mitofinder_ncbi_sor.sbatch
```

Check the output log files.
```
cat Sor_genbank_Apogonidae_MitoFinder.log

Formatting database for mitochondrial contigs identification...
Running mitochondrial contigs identification step...
MitoFinder dit not found any mitochondrial contig
```
It looks like the mitochondrial contigs for this genome were removed already. 

Copy and rename the NCBI reference genome to `reference.genbank.Sor20k.fasta`.
```
cp GCF_902148855.1_fSphaOr1.1_genomic.fasta reference.genbank.Sor20k.fasta
```

---

Remove mitochondrial scaffold from the NCBI genome `GCF_902148855.1_fSphaOr1.1_genomic.fna.gz`. Rename sequence identifiers to retain only scaffold names in reference genome file.
```
cp /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/salarias_fasciatus/1st_sequencing_run/refGenome/GCF_902148845.1_fSalaFa1.1_chr1-23-mtgen.fna.gz /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/salarias_fasciatus/1st_sequencing_run/GenErode_Sfa_full/reference

gunzip /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/salarias_fasciatus/1st_sequencing_run/GenErode_Sfa_full/reference/GCF_902148845.1_fSalaFa1.1_chr1-23-mtgen.fna.gz

cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/salarias_fasciatus/1st_sequencing_run/GenErode_Sfa_full/reference

awk '/mitochondrion/{stop=1} stop==0{print}' < GCF_902148845.1_fSalaFa1.1_chr1-23-mtgen.fna >> GCF_902148845.1_fSalaFa1.1_chr1-23.fna

sed 's/ .*//g' GCF_902148845.1_fSalaFa1.1_chr1-23.fna > GCF_902148845.1_fSalaFa1.1_chr1-23_rename.fna

rm GCF_902148845.1_fSalaFa1.1_chr1-23.fna

rm GCF_902148845.1_fSalaFa1.1_chr1-23-mtgen.fna
```

2. Getting only the Chromosomes and mtGenome from the Genome Download
```
# Download the genome 
wget https://ftp.ncbi.nih.gov/genomes/refseq/vertebrate_other/Salarias_fasciatus/all_assembly_versions/GCF_902148845.1_fSalaFa1.1/GCF_902148845.1_fSalaFa1.1_genomic.fna.gz

# get the line num for every chrom, contig, and scaffold in the genome download and save to file
zgrep -n '^>' GCF_902148845.1_fSalaFa1.1_genomic.fna.gz > GCF_902148845.1_fSalaFa1.1_genomic_linenums.txt

# get mitogenome, which starts on line 9968937, and save to file
zcat GCF_902148845.1_fSalaFa1.1_genomic.fna.gz | tail -n +9968937 > NC_004412.1_mtgenome.fasta

# get chromes 1-7 and save to file
zcat GCF_902148845.1_fSalaFa1.1_genomic.fna.gz | head -n 3077487 > NC_043745.1-NC_043751.1_chr1-7.fasta

# get chromes 8-23, theres no 21, and save to file
zcat GCF_902148845.1_fSalaFa1.1_genomic.fna.gz | tail -n +3431318 | head -n 5857623 > NC_043752.1-NC_043766.1_chr8-23.fasta

# concatenating and gzipping the chromosomes and mitogenome into one file
cat NC_043745.1-NC_043751.1_chr1-7.fasta NC_043752.1-NC_043766.1_chr8-23.fasta NC_004412.1_mtgenome.fasta | gzip > GCF_902148845.1_fSalaFa1.1_chr1-23-mtgen.fna.gz
```

Other MitoFinder scripts:
```
ls /archive/carpenterlab/pire/pire_ssl_data_processing/scripts/*MitoFinder*


/archive/carpenterlab/pire/pire_ssl_data_processing/scripts/runMitoFinderAnnotate.sbatch
/archive/carpenterlab/pire/pire_ssl_data_processing/scripts/runMitoFinder.bash
/archive/carpenterlab/pire/pire_ssl_data_processing/scripts/runMitoFinder_roy.bash
/archive/carpenterlab/pire/pire_ssl_data_processing/scripts/runMitoFinder_roy.sbatch
/archive/carpenterlab/pire/pire_ssl_data_processing/scripts/runMitoFinder.sbatch
```


#### GERP Outgroups

*Sphaeramia orbicularis* is an Apogonid, so are *Sphaeramia nematoptera* (27), *Taeniamia zosterophora* (31), and *Ostorhinchus chrysopomus* (32). Copy all 32 GERP outgroup genomes from the *Ostorhinchus chrysopomus* GenErode run to the gerp_outgroups directory.
```
rsync -a /archive/carpenterlab/pire/pire_ostorhinchus_chrysopomus_lcwgs/GenErode_Och/gerp_outgroups/*.fa.gz gerp_outgroups & 
```

cp /archive/carpenterlab/pire/pire_taeniamia_zosterophora_lcwgs/2nd_sequencing_run/GenErode_20k/gerp_outgroups/Micropterus_salmoides.fa.gz .


Remove the `Sphaeramia_orbicularis.fa.gz` genome. 
```
cd gerp_outgroups

rm Sphaeramia_orbicularis.fa.gz
```

Create the file `speciesnames.txt`.
```
ls | sed 's/\.fa\.gz$//' > speciesnames.txt
```

List of the species names of *Sphaeramia orbicularis* and its 31 closest relatives with chromosome-level genomes from Genbank.

<details><summary>speciesnames.txt</summary>

```
Sphaeramia_orbicularis
Acanthopagrus_latus
Anoplopoma_fimbria
Antennarius_maculatus
Bostrychus_sinensis
Channa_argus
Cheilinus_undulatus
Chelmon_rostratus
Cottoperca_gobio
Cromileptes_altivelis
Cyclopterus_lumpus
Epinephelus_lanceolatus
Etheostoma_cragini
Etheostoma_spectabile
Fundulus_heteroclitus
Gasterosteus_aculeatus
Knipowitschia_caucasica
Larimichthys_crocea
Lutjanus_erythropterus
Micropterus_dolomieu
Mugilogobius_chulae
Oreochromis_niloticus
Oryzias_latipes
Pagrus_major
Perca_flavescens
Perccottus_glenii
Periophthalmus_magnuspinnatus
Plectropomus_leopardus
Proterorhinus_semilunaris
Rhinogobius_similis
Scatophagus_argus
Sebastes_schlegelii
```

</p>
</details>

</details>

<details><summary>2. Get Newick tree</summary>

### 2. Get Newick tree

Create a dated phylogenetic tree. Upload `speciesnames.txt` to [TimeTree of Life](https://timetree.org/). Download the .nwk and .jpg files that TimeTree creates. Upload those to the `GenErode_Sor_20k/gerp_outgroup` directory. Rename the file from `speciesnames.nwk` to `gerp_tree.nwk`.
```
mv speciesnames.nwk gerp_tree.nwk
```

#### TimeTree Results

<img src="" alt="Sor tree" width="700"/>

\*Cottoperca gobio not found in NCBI Taxonomy so replaced with Cottoperca.

!!! Not done yet. Check which genome first. 
Replace your Genus_species in `gerp_tree.nwk` with the name of the reference genome, which should be `reference.genbank.Sor20k.fasta`: 
```
sed -i 's/Sphaeramia_orbicularis/reference.genbank.Sor20k.fasta/g' gerp_tree.nwk
```

<details><summary>gerp_tree.nwk</summary>

((((((Chelmon_rostratus:84.83588000,((Lutjanus_erythropterus:82.26366000,(Pagrus_major:46.50921000,Acanthopagrus_latus:46.50921000)'14':35.75445000)'13':0.49007000,(Scatophagus_argus:81.72976000,Antennarius_maculatus:81.72976000)'25':1.02397000)'37':2.08215000)'36':1.10157000,Larimichthys_crocea:85.93745000)'35':10.77313000,(Cheilinus_undulatus:92.81956000,Micropterus_dolomieu:92.81956000)'34':3.89102000)'43':6.86373000,(((Etheostoma_cragini:26.76663000,Etheostoma_spectabile:26.76663000)'33':5.73599000,Perca_flavescens:32.50262000)'51':44.47236000,(((Sebastes_schlegelii:75.22844000,(Anoplopoma_fimbria:47.36369000,(Cyclopterus_lumpus:45.92825000,Gasterosteus_aculeatus:45.92825000)'50':1.43544000)'49':27.86475000)'57':1.69136000,Cottoperca_gobio:76.91980000)'60':0.00362000,((Cromileptes_altivelis:14.67433000,Epinephelus_lanceolatus:14.67433000)'56':35.84187000,Plectropomus_leopardus:50.51620000)'48':26.40722000)'63':0.05156000)'47':26.59933000)'68':8.65975000,(Channa_argus:103.76124000,(Oreochromis_niloticus:91.74830000,(Oryzias_latipes:84.82079000,Fundulus_heteroclitus:84.82079000)'73':6.92751000)'72':12.01294000)'84':8.47282000)'87':0.00000000,(((((Proterorhinus_semilunaris:52.85785000,(Knipowitschia_caucasica:51.52832000,(Mugilogobius_chulae:44.37451000,Rhinogobius_similis:44.37451000)'83':7.15381000)'82':1.32953000)'80':0.55820000,Periophthalmus_magnuspinnatus:53.41605000)'79':8.63806000,Bostrychus_sinensis:62.05411000)'94':0.00011000,Perccottus_glenii:62.05422000)'92':34.85638000,reference.genbank.Sor20k.fasta:96.91060000)'78':15.32346000);

</p>
</details>

</details>


<details><summary>3. Config Files</summary>

### 3. Config Files

1. Copy config scripts to your species' config directory.
```
cp /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/scripts/GenErode_wahab/config/config* /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/config/
```

2. Edit the user-defined variables in the scripts `config_generode_old_new_lane.sh`, `config_historical_samples.sh`, `config_modern_samples.sh` to reflect your species. 
```
# User-defined variables for species and species code (Spp).
# For species use lowercase and an underscore so the directory path can be identified (e.g. lethrinus_variegatus)
species="sphaeramia_orbicularis"
# For Spp, this is the three letter species code. Capitalize the first letter.
Spp="Sor"
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
```

4. Run `config_generode_old_new_lane.sh` 
```
bash config_generode_old_new_lane.sh
```

Output.
```
Including file: /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/1st_sequencing_run/fq_raw/old_new_filenames.log
Including file: /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/2nd_sequencing_run/fq_raw/old_new_filenames.log
File not found: /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/3rd_sequencing_run/fq_raw/old_new_filenames.log
File not found: /home/e1garcia/shotgun_PIRE/pire_ssl_data_processing/sphaeramia_orbicularis/fq_raw_shotgun/old_new_filenames.log
Concatenation completed. Output saved to /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/config/old_new_lane_GenErode_Sor_config.log
```
Only expecting the `old_new_filenames.log` from the 1st and 2nd sequencing runs to be incorporated.

Count the number of lines in the file `old_new_filenames.log` that begin with 'Sor-ACeb' and 'Sor-CPnd'. There should be 132 historical and 320 modern  files. 
```
# historical
cat old_new_lane_GenErode_Sor_config.log | grep 'Sor-ACeb' | wc -l
132

# modern
cat old_new_lane_GenErode_Sor_config.log | grep 'Sor-CPnd' | wc -l
320
```

5. Run `config_modern_samples.sh`.
```
bash config_modern_samples.sh
```

Output.
```
Modern samples processing completed. Output saved to modern_samples.txt
All 160 1.fq.gz and 160 2.fq.gz files were incorporated into modern_samples.txt
```
All 320 SorCPnd modern \*.fq.gz files were incorporated into `modern_samples.txt`.

6. Run `config_historical_samples.sh`. 
```
bash config_historical_samples.sh
```

Output.
```
Historical samples processing completed. Output saved to historical_samples.txt
All 66 1.fq.gz and 66 2.fq.gz files were incorporated into historical_samples.txt
```
All 132 SorACeb historical \*.fq.gz files were incorporated into `historical_samples.txt`.

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
line 23: ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta"
line 31: historical_samples: "config/historical_samples.txt"
line 32: modern_samples: "config/modern_samples.txt"
Line 70: fastq_processing: True
line 89: map_historical_to_mitogenomes: False
line 165: historical_bam_mapDamage: True
line 173: historical_rescaled_samplenames: ["SorACeb001","SorACeb002","SorACeb003","SorACeb004","SorACeb005","SorACeb006","SorACeb007","SorACeb008","SorACeb009","SorACeb010","SorACeb011","SorACeb012","SorACeb013","SorACeb014","SorACeb015","SorACeb016","SorACeb017","SorACeb018","SorACeb019","SorACeb020","SorACeb021","SorACeb022"]
line 446: snpEff: False
line 455: gtf_path: ""
line 486: gerp: True
line 492: gerp_ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups"
line 501: tree: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups/gerp_tree.nwk"
```

</p>
</details>

</details>


<details><summary>4. Run GenErode</summary>

### 4. Run GenErode

Copy the `run_GenErode*.sbatch` files to the GenErode_Sor_20k directory.
```
cp /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/scripts/GenErode_wahab/run_GenErode*.sbatch /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k
```

Move to the GenErode_Sor_20k directory and run the script `run_GenErode.sbatch`.
```
sbatch run_GenErode.sbatch
```
JobID: 4239441
2/3/25 @ 16:09 PST

The slurm has not updated in ~19 hours. The script seems to be stuck when it encounters `Epinephelus_lanceolatus`, which has caused errors and fails. Remove `Epinephelus_lanceolatus` from the run and retry. 
1. Cancel job. `scancel 4239441`, `scancel 4239731`
2. Delete Epinephelus_lanceolatus genome. `rm gerp_outgroups/Epinephelus_lanceolatus.fa.gz`
3. Delete gerp tree. `rm gerp_outgroups/gerp_tree.nwk`
4. Delete prune tree. `rm gerp_outgroups/prunetree.jpg`
5. Remove Epinephelus_lanceolatus from `speciesnames.txt`. `sed -i '/Epinephelus_lanceolatus/d' speciesnames.txt`
6. Upload `speciesnames.txt` to TimeTree. Download nwk & jpg files. 
7. Upload nwk & jpg files using WinSCP.
8. Rename `speciesnames.nwk` to `gerp_tree.nwk`. `mv speciesnames.nwk gerp_tree.nwk`
9. Replace Sphaeramia_orbicularis in `gerp_tree.nwk` with `reference.genbank.Sor20k.fasta`: `sed -i 's/Sphaeramia_orbicularis/reference.genbank.Sor20k.fasta/g' gerp_tree.nwk`
10. Unlock. `sbatch run_GenErode_unlock.sbatch`
11. Rerun. `sbatch run_GenErode.sbatch`

JobID: 4256560
JobID: 8e7f8412
2/4/25 @ 14:20 PST

Similar error to the previous run, but this time it seems to be stuck on Lutjanus_erythropterus. If it worked through the genomes alphabetically, then it got through 4 more genomes before the errors and fails. The slurm has not updated in ~4.5 hours. It's been running for 7.5 hours. It did finish the modern files. It successfully processed 1 historical sample (SorCeb005). Perhaps just run through the historical files and set gerp to false. Then troubleshoot the gerp issue. 
1. `scancel 4256577 4256560`
2. `cp config.yaml config_v1.yaml`
3. Edit `config.yaml` line 32 & 486.

<details><summary>config.yaml</summary>

```
line 23: ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta"
line 31: historical_samples: "config/historical_samples.txt"
line 32: modern_samples: ""
Line 70: fastq_processing: True
line 89: map_historical_to_mitogenomes: False
line 165: historical_bam_mapDamage: True
line 173: historical_rescaled_samplenames: ["SorACeb001","SorACeb002","SorACeb003","SorACeb004","SorACeb005","SorACeb006","SorACeb007","SorACeb008","SorACeb009","SorACeb010","SorACeb011","SorACeb012","SorACeb013","SorACeb014","SorACeb015","SorACeb016","SorACeb017","SorACeb018","SorACeb019","SorACeb020","SorACeb021","SorACeb022"]
line 446: snpEff: False
line 455: gtf_path: ""
line 486: gerp: False
line 492: gerp_ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups"
line 501: tree: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups/gerp_tree.nwk"
```

</p>
</details>

4. `sbatch run_GenErode_unlock.sbatch`
5. `sbatch run_GenErode.sbatch`
JobID: 4257441
2/4/25 @ 21:58 PST (2/5/25 @ 00:58 EST)
Slurm has not updated since Feb 5 @ 02:54 EST. But no fails or errors. 
```
[Wed Feb  5 02:54:51 2025]
Finished job 1432.
1067 of 1338 steps (80%) done
```
Failed due to input: reference/reference.genbank.Sor20k.upper.fasta




----

Correct 20k reference genome after removal of smalls: `reference.genbank.Sor20k.fasta`

Cancel. Run removesmalls on the unzipped NCBI .fasta genome. This should work. It didn't last time because I ran it on the zipped .fna.gz file. All modern & historical files have been generated, so remove the config scripts from lines 31 & 32.

1. `scancel 4257454 4257441`
2. Remove mitoFinder files and directories and previous gerp results.
```
cd reference/
rm reference.genbank.Sor20k.*
rm mitofinder-4228305.out
rm Sor_genbank_Apogonidae_MitoFinder.log
rm -rf Sor_genbank_Apogonidae/
ls repeatmodeler/
rm -rf repeatmodeler/

cd results
rm reference.genbank.Sor20k.*
rm -rf gerp/
```
3. `perl /home/e1garcia/shotgun_PIRE/REUs/2022_REU/PSMC/scripts/removesmalls.pl 20000 GCF_902148855.1_fSphaOr1.1_genomic.fasta > reference.genbank.Sor20k.fasta`
Still same size:
```
du -sh reference.genbank.Sor20k.fasta
489M    reference.genbank.Sor20k.fasta
du -sh GCF_902148855.1_fSphaOr1.1_genomic.fasta
489M    GCF_902148855.1_fSphaOr1.1_genomic.fasta
```
4. `cp config.yaml config_v2.yaml`
5. Edit `config.yaml` line 31, 32, 70, 165, 173, & 486.

<details><summary>config.yaml</summary>

```
line 23: ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta"
line 31: historical_samples: ""
line 32: modern_samples: ""
Line 70: fastq_processing: False
line 89: map_historical_to_mitogenomes: False
line 165: historical_bam_mapDamage: False
line 173: historical_rescaled_samplenames: []
line 446: snpEff: False
line 455: gtf_path: ""
line 486: gerp: True
line 492: gerp_ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups"
line 501: tree: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups/gerp_tree.nwk"
```

</p>
</details>

6. `sbatch run_GenErode_unlock.sbatch`
7. `sbatch run_GenErode.sbatch`
JobID: 4258746
2/5/25 @ 13:49
slurm-4258746.out
Failed
WorkflowError in rule missingness_filtered_vcf_multiqc in file /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/workflow/rules/9_merge_vcfs.smk, line 435:
Function did not return str or list of str.

RERUN, but change config.yaml. It seems like in order to create the ancestral rates file, some information about the modern and historical files is necessary. The scripts are looking for multiqc_reports in the modern and historical directories, but can't find them. Try putting the historical and modern config files back in lines 31 & 32. 

1. Edit `config.yaml` line 31, 32. Include modern & historical sample file names. 

<details><summary>config.yaml</summary>

```
line 23: ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta"
line 31: historical_samples: "config/historical_samples.txt"
line 32: modern_samples: "config/modern_samples.txt"
Line 70: fastq_processing: False
line 89: map_historical_to_mitogenomes: False
line 165: historical_bam_mapDamage: False
line 173: historical_rescaled_samplenames: []
line 446: snpEff: False
line 455: gtf_path: ""
line 486: gerp: True
line 492: gerp_ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups"
line 501: tree: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups/gerp_tree.nwk"
```

</p>
</details>

2. `sbatch run_GenErode_unlock.sbatch`
3. `sbatch run_GenErode.sbatch`
JobID: 4258756
2/5/25 @ 14:04


2/6/25 @ 20:36 EST

The slurm file has not been updated since Feb 5 21:04 slurm-4258756.out, which is 23.5 hours ago. 

Last message in the Slurm

[Wed Feb  5 21:04:52 2025]
Finished job 4430.
3601 of 104858 steps (3%) done
Removing temporary output results/historical/vcf/reference.genbank.Sor20k/SorACeb007.merged.rmdup.merged.realn.Q30.bcf.


Failed when hitting input: 
input: results/gerp/alignment/reference.genbank.Sor20k/Lutjanus_erythropterus.bam


**Cancel & restart. Didn't change anything.

1. `scancel 4258792 4258756`
2. `sbatch run_GenErode_unlock.sbatch`
3. `sbatch run_GenErode.sbatch`

JobID: 4262576
2/6/25 @ 20:38 EST

Check output file.
```
less slurm-4262576.out

```

failed due to 
input: results/gerp/alignment/reference.genbank.Sor20k/Lutjanus_erythropterus.bam


----
```
mkdir GenErode_Sor_20k_gerp

cd /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_gerp

mkdir config reference gerp_outgroups

rsync -a /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/scripts/GenErode_wahab/GenErode_templatedir/ /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_gerp &

cp /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta reference/

rsync -a /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups/* gerp_outgroups/ & 

cp /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/config/config.yaml config/


```

<details><summary>config.yaml</summary>

```
line 23: ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_gerp/reference/reference.genbank.Sor20k.fasta"
line 31: historical_samples: ""
line 32: modern_samples: ""
Line 70: fastq_processing: False
line 89: map_historical_to_mitogenomes: False
line 165: historical_bam_mapDamage: False
line 173: historical_rescaled_samplenames: []
line 446: snpEff: False
line 455: gtf_path: ""
line 486: gerp: True
line 492: gerp_ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_gerp/gerp_outgroups"
line 501: tree: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k_gerp/gerp_outgroups/gerp_tree.nwk"
```

</p>
</details>

```
cp /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/*.sbatch ./

sbatch run_GenErode_unlock.sbatch

sbatch run_GenErode.sbatch
```
JobID: 4262626
2/6/25 @ 18:16 PST

```
less slurm-4262626.out

```

----

```
cd gerp_outgroups

cp /archive/carpenterlab/pire/pire_sphaeramia_nematoptera_lcwgs/3rd_sequencing_run/GenErode/gerp_outgroups/Micropterus_salmoides.fa.gz .

rm Lutjanus_erythropterus.fa.gz
rm prunetree.jpg
rm gerp_tree.nwk

nano speciesnames.txt
```

<details><summary>speciesnames.txt</summary>

```
Sphaeramia_orbicularis
Acanthopagrus_latus
Anoplopoma_fimbria
Antennarius_maculatus
Bostrychus_sinensis
Channa_argus
Cheilinus_undulatus
Chelmon_rostratus
Cottoperca_gobio
Cromileptes_altivelis
Cyclopterus_lumpus
Etheostoma_cragini
Etheostoma_spectabile
Fundulus_heteroclitus
Gasterosteus_aculeatus
Knipowitschia_caucasica
Larimichthys_crocea
Micropterus_dolomieu
Micropterus_salmoides
Mugilogobius_chulae
Oreochromis_niloticus
Oryzias_latipes
Pagrus_major
Perca_flavescens
Perccottus_glenii
Periophthalmus_magnuspinnatus
Plectropomus_leopardus
Proterorhinus_semilunaris
Rhinogobius_similis
Scatophagus_argus
Sebastes_schlegelii
```

Upload speciesnames.txt to TimeTree. Download nwk & jpg file and upload to species' gerp_outgroups directory. 
```
mv speciesnames.nwk gerp_tree.nwk

sed -i 's/Sphaeramia_orbicularis/reference.genbank.Sor20k.fasta/g' gerp_tree.nwk
```

gerp_tree.nwk
```
((((((Chelmon_rostratus:84.83588000,((Pagrus_major:46.50921000,Acanthopagrus_latus:46.50921000)'14':36.24452000,(Scatophagus_argus:81.72976000,Antennarius_maculatus:81.72976000)'13':1.02397000)'25':2.08215000)'37':1.10157000,Larimichthys_crocea:85.93745000)'36':10.77313000,(Cheilinus_undulatus:92.81956000,(Micropterus_dolomieu:9.13000000,Micropterus_salmoides:9.13000000)'35':83.68956000)'34':3.89102000)'43':6.86373000,(((Etheostoma_cragini:26.76663000,Etheostoma_spectabile:26.76663000)'33':5.73599000,Perca_flavescens:32.50262000)'51':44.47236000,(((Sebastes_schlegelii:75.22844000,(Anoplopoma_fimbria:47.36369000,(Cyclopterus_lumpus:45.92825000,Gasterosteus_aculeatus:45.92825000)'50':1.43544000)'49':27.86475000)'57':1.69136000,Cottoperca_gobio:76.91980000)'60':0.00362000,(Cromileptes_altivelis:50.51620000,Plectropomus_leopardus:50.51620000)'56':26.40722000)'48':0.05156000)'63':26.59933000)'47':8.65975000,(Channa_argus:103.76124000,(Oreochromis_niloticus:91.74830000,(Oryzias_latipes:84.82079000,Fundulus_heteroclitus:84.82079000)'68':6.92751000)'73':12.01294000)'72':8.47282000)'84':0.00000000,(((((Proterorhinus_semilunaris:52.85785000,(Knipowitschia_caucasica:51.52832000,(Mugilogobius_chulae:44.37451000,Rhinogobius_similis:44.37451000)'87':7.15381000)'83':1.32953000)'82':0.55820000,Periophthalmus_magnuspinnatus:53.41605000)'80':8.63806000,Bostrychus_sinensis:62.05411000)'79':0.00011000,Perccottus_glenii:62.05422000)'94':34.85638000,reference.genbank.Sor20k.fasta:96.91060000)'92':15.32346000);
```

Edit config.yaml

<details><summary>config.yaml</summary>

```
line 23: ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/reference/reference.genbank.Sor20k.fasta"
line 31: historical_samples: "config/historical_samples.txt"
line 32: modern_samples: "config/modern_samples.txt"
Line 70: fastq_processing: False
line 89: map_historical_to_mitogenomes: False
line 165: historical_bam_mapDamage: False
line 173: historical_rescaled_samplenames: []
line 446: snpEff: False
line 455: gtf_path: ""
line 486: gerp: True
line 492: gerp_ref_path: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups"
line 501: tree: "/archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/gerp_outgroups/gerp_tree.nwk"
```

</p>
</details>

```
sbatch run_GenErode_unlock.sbatch
```

```
sbatch run_GenErode.sbatch
```
JobID: 4263031
2/7/25 @ 12:21 PST

less slurm-4263031.out

Failed with Cromileptes_altivelis
Deleted /results/gerp
Deleted /results/logs/13_GERP

JobID: 4268520
2/9/25 @ 13:47 PST

```
less slurm-4268520.out

```







----

If it is locked then unlock it with:
```
sbatch run_GenErode_unlock.sbatch
```

 

</details>


<details><summary>5. Results</summary>

### 5. Results

Check input and output

#### GERP Scores

2/6/25 @ 15:00 PST

The slurm file has not been updated since Feb 5 21:04 slurm-4258756.out, which is 18 hours ago. 

Last message in the Slurm
less slurm-4258756.out
[Wed Feb  5 21:04:52 2025]
Finished job 4430.
3601 of 104858 steps (3%) done
Removing temporary output results/historical/vcf/reference.genbank.Sor20k/SorACeb007.merged.rmdup.merged.realn.Q30.bcf.









```
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/results/gerp/reference.genbank.Sor20k.ancestral.rates.gz | wc -l 

```
GenErode the ancestral rates file. 

#### Modern
```
# modern expected
find /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/modern -maxdepth 1 -type f -name 'Sor-CPnd_*' -printf '%f\n' | cut -c 10-12 | sort | uniq | wc -l
64

# modern output *.merged.rmdup.merged.realn.bam
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/results/modern/mapping/reference.genbank.Sor20k/*.merged.rmdup.merged.realn.bam | wc -l
64

# modern output *.merged.rmdup.merged.realn.bai
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/results/modern/mapping/reference.genbank.Sor20k/*.merged.rmdup.merged.realn.bai | wc -l
64
```
GenErode created all 64 modern `\*.merged.rmdup.merged.realn.bam` & `\*.merged.rmdup.merged.realn.bai` files.


#### Historical
```
# historical expected
find /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/historical -maxdepth 1 -type f -name 'Sor-ACeb_*' -printf '%f\n' | cut -c 10-12 | sort | uniq | wc -l
22

# historical output *.merged.rmdup.merged.realn.bam
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/results/historical/mapping/reference.genbank.Sor20k/*.merged.rmdup.merged.realn.bam | wc -l
22

# historical output *.merged.rmdup.merged.realn.bai
ls /archive/carpenterlab/pire/pire_sphaeramia_orbicularis_lcwgs/GenErode_Sor_20k/results/historical/mapping/reference.genbank.Sor20k/*.merged.rmdup.merged.realn.bai | wc -l
22
```
GenErode successfully created all 22 historical `\*.merged.rmdup.merged.realn.rescaled.bam` & `\*.merged.rmdup.merged.realn.rescaled.bam.bai` files. 

</details>


<details><summary>6. Clean up</summary>

### 6. Clean up

Move `\*.out` files to logs directory.  
```
mv *.out logs
```

</details>
