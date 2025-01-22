# Sphaeramia orbicularis lcWGS 
### Kevin Labrador
#


## 1. Pre-processing


This follows the instructions from [pire_fq_gz_processing](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/README.md).

<details>
	<summary>Housekeeping</summary>

1. Setup Computer 
	- Computer set-up following C.Bird's [instructions](https://github.com/kllabrador/TAMUCC_GCL_Bioinformatics/blob/main/ComputerSetUp.md)
  
2. Go to [pire_fq_gz_processing](https://github.com/philippinespire/pire_fq_gz_processing/blob/main/README.md). Follow instructions.

3. Identify HPC being used: Wahab
  
4. Log-in to Wahab

```bash
ssh hpc-0289@wahab.hpc.odu.edu
# Refer to private notes for password
```
</details>


<details>
	<summary>0. Set up directory</summary>
	
- Go to E.Garcia's directory 
- All directories have already been prepared beforehand, so there is no need to create a personal subdirectory.

```bash
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis
```

- Go to the assigned working directories and create the following subdirs:
  
```bash
mkdir fq_fp1 fq_fp1_clmp fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_rprd
```
</details>


<details>
	<summary>1. Download data from TAMUCC grid</summary>

> This was already done by E.Garcia.

</details>


<details>
	<summary>2. Proofread the decode file(s)</summary>

- Review the decode file

```bash
cd ./fq_raw
less *SequenceNameDecode.txt
```

>The naming convention for the decode file's Extraction_ID was not followed. Details are as follows:
>> whitespace within name (e.g., `Sor-Acan_049-Ex1-1E -lcwgs-1-T`)

> Is the dataset complete?

>> No, there is an excess of samples. It should be 221, not 223\
>> There were sequences from an old sequencing run that were transferred that should not have been (S.Magnuson)\

> Delete the following sequences from the fq_raw directory:
>> SoC0301809F\
>> SoC0301809G\
>> SoC0301809H\

```
#!bin/bash

sequence_dir="/home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_raw"
#seqID=("SoC0301809F" "SoC0301809G" "SoC0301809H") # This only records G and H, not F, which is weird.
seqID=("SoC0301809")
outfile="delete_seq.out"

for file in $(find $sequence_dir -name "*.fq.gz"); do
        for seqID in "${seqID[@]}"; do
                if [[ $file =~ $seqID ]]; then
                        echo "Deleting file: $file" >> $outfile
                        rm -i $file
                        break
                fi
        done
done

```

> Download "SoC0604808A" data from TAMUCC grid

```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_raw

wget https://gridftp.tamucc.edu/genomics/20230123_PIRE-Sor-lcwgs-testlane/SoC0604808A_CKDL220033557-1A_HJFC3CCX2_L4_1.fq.gz
wget https://gridftp.tamucc.edu/genomics/20230123_PIRE-Sor-lcwgs-testlane/SoC0604808A_CKDL220033557-1A_HJFC3CCX2_L4_2.fq.gz
```

> Recheck dataset. There should be 221 samples.
>> Yes. There are 221 samples.

> Are there duplicate of libraries?
>> No	

</details>


<details>
	<summary>3. Edit the decode file</summary>

> Decode file was renamed (*original_deprecated.txt), and copy was then created (*fixed.txt) and edited as per naming convention.
>> Second underscore was changed into a dash
    
```
mv Sor_lcwgsTestLane_SequenceNameDecode.txt Sor_lcwgsTestLane_SequenceNameDecode_original_deprecated.txt
cp *deprecated.txt Sor_lcwgsTestLane_SequenceNameDecode_fixed.txt

sed "s/ \-/\-/" *fixed.txt

# Check if the naming error is fixed. If so,
sed -i "s/ \-\/\-/" *fixed.txt
```
</details>


<details>
	<summary>4. Make a copy for the fq_raw files prior to renaming.</summary>

```
mkdir /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis
mkdir /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_raw

cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_raw
screen cp ./* /RC/group/rc_carpenterlab_ngs/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_raw

# `ctrl+A` and then `d` to detach from `screen` terminal

```

</details>


<details>
	<summary>5. Perform a renaming dry run</summary>

- Use the fixed decode file to rename the raw `fq.gz` files. Use the pre-written bash script for renaming.
  
```bash
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_raw
bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash Sor_lcwgsTestLane_SequenceNameDecode_fixed.txt
```

</details>


<details>
	<summary>6. Rename the files for real</summary>

```bash

bash /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/renameFQGZ.bash  Sor_lcwgsTestLane_SequenceNameDecode_fixed.txt rename
			
#you will need to say y 2X
```

</details>


<details>
	<summary>7. Check the quality of the data. Run `fastqc`</summary>

```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis>
sbatch --mail-user=klabrador@islander.tamucc.edu --mail-type=END /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_raw" "fqc_raw_report" "fq.gz"
```
> Job submitted on 2023-01-28
>> jobID: 1224222
>> job finished; runtime not recorded 

### MultiQC output

```
Potential Issues:
	* % duplication 
		* Alb: 2.40 - 24.10%
		* Con: 5.10 - 13.30%
	* GC Content 
		* Alb: 37 - 58% 
		* Con: 39 - 44%
	* number of reads 
		* Alb: 0 - 6 M
		* Con: 0.4 - 7.1 M 
```
> Ask Chris how to detect "potential issues".

</details>


<details>
	<summary>8. First trim</summary>

- Execute `runFASTP_1st_trim.sbatch`

```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis

sbatch --mail-user=klabrador@islander.tamucc.edu --mail-type=END ../../pire_fq_gz_processing/runFASTP_1st_trim.sbatch fq_raw fq_fp1
```
> Job submitted on 2023-01-29
>> jobID: 1224228
>> job finished; runtime: 00:14:33

Potential issues:

	* % duplication -
		* Alb: 0.40 - 14.20%, Contemp: 5.40 - 9.50%
	* GC content -
		* Alb: 34.00 - 59.40%, Contemp: 37.60 - 41.80%
	* passing filter -
		* Alb: 86.70 - 97.80%, Contemp: 91.40 - 97.70%
	* % adapter -
		* Alb: 16.30 - 96.90%, Contemp: 8.60 - 85.80%
	* number of reads -
		* Alb: 0.081 - 11.7 M, Contemp: 0.74 - 13.8 M

</details>


<details>
        <summary>9a. Remove duplicates</summary>


```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis

# Check the number of idle nodes on main partition
sinfo -p main | grep "idle" | wc -l

# There wereno available idle nodes. Set to 20.
bash ../../pire_fq_gz_processing/runCLUMPIFY_r1r2_array.bash fq_fp1 fq_fp1_clmp /scratch/hpc-0289 20

```

> Job submitted on 2023-01-29
>> jobID: 1224723\
>> job finished; runtime: not recorded


> Ask Chris how to check the number of available nodes.

</details>


<details>
        <summary>9b. Check duplicate removal success</summary>

```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis

salloc #because R is interactive and takes a decent amount of memory, we want to grab an interactive node to run this
enable_lmod
module load container_env mapdamage2

# Install tidyverse
crun R
install.packages ("tidyverse") # typed "yes" on all prompts.

exit #to relinquish the interactive node

#when the install is complete, exit R with the following keystroke combo: ctrl-d (typing q() also works)
#type "n" when asked about saving the environment

#you are now in the shell environment and you should be able to run the checkClumpify script
crun R < /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/checkClumpify_EG.R --no-save

exit # to relinquish the interactive mode.
```

> Clumpify Successfully worked on all samples

</details>


<details>
        <summary>9c. Generate metadata on deduplicated FASTQ files</summary>

```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis

sbatch --mail-user=klabrador@islander.tamucc.edu --mail-type=END /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_fp1_clmp" "fqc_clmp_report"  "fq.gz"sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "fq_fp1_clmp" "fqc_clmp_report"  "fq.gz"

```
> job submitted on 2023-01-29
>> jobID: 1225344\
>> job finished; runtime: not recorded

</details>


<details>
        <summary>10. Second trim. Execute `runFASTP_2.sbatch`</summary>

```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis

sbatch --mail-user=klabrador@islander.tamucc.edu --mail-type=END ../../pire_fq_gz_processing/runFASTP_2_cssl.sbatch fq_fp1_clmp fq_fp1_clmp_fp2
```

> job submitted on 2023-01-30
>> jobID: 1225355\
>> job finished; runtime: 00:13:41


### MultiQC Report

Potential issues:

	* % duplication -
		* Alb: 0.10 - 5.60%, Contemp: 0.90 - 3.00%
	* GC content -
		* Alb: 33.90 - 59.20%, Contemp: 37.50 - 41.80%
	* passing filter -
		* Alb: 97.70 - 99.60%, Contemp: 97.60 - 99.40%
	* % adapter -
		* Alb: 0.30 - 2.00%, Contemp: 0.20 - 1.60%
	* number of reads 
		* Alb: 0.079 - 9.76 M, Contemp: 0.675 - 12.31 M

</details>


<details>
        <summary>11. Decontaminate</summary>

```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis 
bash ../../pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2 fq_fp1_clmp_fp2_fqscrn 20

# check to be sure the job is running
watch squeue -u hpc-0289

```
> Job submitted on 2023-01-30
>> jobID: 1225384

> Job cancelled on 2023-02-01
>> The remaining jobs are stuck. There was no writing in the destination dir since yesterday. - C.Bird
```
scancel 1225383
```

> Additional Instructions
>> While there are no active jobs, make a dir called "logs" and then move the *.out files into it.


```
mkdir logs
mv *.out logs
```

> To rerun just those 4 libraries that got stuck, I would make a new dir: fq_fp1_clmp_fp2_stragglers. Then, use mv to move the 4 libraries that didn't complete into that new dir. Then, run fqscrn again with the new stragglers dir and the same fq_fp1_clmp_fqscrn destination dir


```
mkdir fq_fp1_clmp_fp2_stragglers
```

> How to identify the stuck libraries?
>> Go to fq_fp1_clmp_fp2, then ls -lh.\
>> Count from the top down to the 19th lib.\
>> Then, take a look in fq_fp1_clmp_fp2_fqscrn.\
>> Confirm that the files for the lib are either missing or really small in size compared to the previous libs.

> Created a bash script to move selected files into the *stragglers directory.

```
#!bin/bash

# Used in: Step 11. Decontaminate
## The jobs were stuck and there was no writing in the destination directory for some time now.
## Stragglers were identified by looking at both the indir ("../fq_fp1_clmp_fp2") and outdir ("../fq_fp1_clmp_fp2_fqscrn").
## These are the missing files:

### Sor-ABur_007-Ex1-12G-lcwgs-1-T.clmp.fp2_r2
### Sor-ABur_010-Ex1-3H-lcwgs-1-T.clmp.fp2_r2
### Sor-ABur_011-Ex1-4H-lcwgs-1-T.clmp.fp2_r1
### Sor-ABur_011-Ex1-4H-lcwgs-1-T.clmp.fp2_r2
### Sor-ABur_012-Ex1-5H-lcwgs-1-T.clmp.fp2_r2

indir="/home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_fp1_clmp_fp2"
outdir="/home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_fp1_clmp_fp2_stragglers"
id=("ABur_007" "ABur_010" "ABur_011" "ABur_012")

for id in "${id[@]}"; do
        files=$(find $indir -name "*$id*clmp.fp2_r*.fq.gz")

        for file in "${files[@]}"; do
                mv $file $outdir
        done

        echo "${files[@]}" >> $indir/list_of_stragglers.txt
done
```

Rerun FQSCRN.

```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis
bash ../../pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2_stragglers fq_fp1_clmp_fp2_fqscrn 20

# check to be sure the job is running
watch squeue -u hpc-0289

```
> Job submitted on 2023-02-02
>> jobID: 1233935/36 \
>> All finished except for Sor-ABur_010-Ex1-3H-lcwgs-1-T.clmp.fp2_r1\
>> Cancel job and redo run for the remaining straggler.\
>> Job cancelled on 2023-02-03

Redo subdir creation and rerun FQSCRN on second set of stragglers.

```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis
bash ../../pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2_stragglers2 fq_fp1_clmp_fp2_fqscrn 20
```
> Job submitted on 2023-02-03
>> jobID: 1237853/54 \
>> job finished on 2023-02-03 @ 23:24

I found another straggler: Sor-ACan_022-Ex1-10B-lcwgs-1-T.clmp.fp2_r1
Process the straggler.

> To organize the stragglers, I decided to create subdirectories within the *straggler directory.


```
# Organize stragglers subirectory.
mkdir /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_fp1_clmp_fp2_stragglers/batch02
mv /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_fp1_clmp_fp2_stragglers2/* /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_fp1_clmp_fp2_stragglers/batch02

# Move Sor-ACan_022-Ex1-10B stragglers to batch03 directory
mkdir /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_fp1_clmp_fp2_stragglers/batch03
mv /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_fp1_clmp_fp2/Sor-ACan_022-Ex1-10B-lcwgs-1-T.clmp.fp2_r*.fq.gz /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis/fq_fp1_clmp_fp2_stragglers/batch03

# Rerun FQSCRN on batch03 stragglers.
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis
bash ../../pire_fq_gz_processing/runFQSCRN_6.bash fq_fp1_clmp_fp2_stragglers/batch03 fq_fp1_clmp_fp2_fqscrn 20
```

> Job submitted on 2023-02-04 @ 20:12
>> jobID: 1238185/86
>> job finished on 2023-02-04 @ 21:52

Check if all files were successfully completed.

```
ls fq_fp1_clmp_fp2_fqscrn/*tagged.fastq.gz | wc -l
# 442

ls fq_fp1_clmp_fp2_fqscrn/*tagged_filter.fastq.gz | wc -l 
# 442

ls fq_fp1_clmp_fp2_fqscrn/*screen.txt | wc -l
# 442

ls fq_fp1_clmp_fp2_fqscrn/*screen.png | wc -l
# 442

ls fq_fp1_clmp_fp2_fqscrn/*screen.html | wc -l
# 442

```

Check out files for errors

```
grep 'error' slurm-fqscrn.*out
# Enumerates all the cancelled job: 1225383, 1233935

grep 'No reads in' slurm-fqscrn.*out
# None returned

```

Run MULTIQC for the *fqscrn output.

```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis

sbatch ../../pire_fq_gz_processing/runMULTIQC.sbatch fq_fp1_clmp_fp2_fqscrn fastq_screen_report
```

> Job submitted on 2023-02-04 @ 23:52
>> jobID: not recorded 
>> jobFinished on 2023-02-05 @ ~ 00:10

### MultiQC Report

Potential issues:

        * one hit, one genome, no ID -
                * Alb: , Contemp: 
        * no one hit, one genome to any potential contaminators (bacteria, virus, human, etc) -
                * Alb: , Contemp: 


</details>


<details>
        <summary>12. Repair FASTQ Files messed up by FASTQ_SCREEN</summary>

```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis

sbatch ../../pire_fq_gz_processing/runREPAIR.sbatch fq_fp1_clmp_fp2_fqscrn fq_fp1_clmp_fp2_fqscrn_rprd 40

```

> Job submitted on 2023-02-04 @ 23:57
>> jobID: 1238233 \
>> jobFinished on 2023-02-05 @ 00:08

Run Multi_FASTQ.sh on output files.

```
cd /home/e1garcia/shotgun_PIRE/pire_lcwgs_data_processing/sphaeramia_orbicularis

sbatch /home/e1garcia/shotgun_PIRE/pire_fq_gz_processing/Multi_FASTQC.sh "./fq_fp1_clmp_fp2_fqscrn_rprd" "fqc_rprd_report" "fq.gz"
```

> Job submitted on 2023-02-05 @ 00:10
>> jobID: 1238236 \
>> jobFinished on 2023-02-05 @ 00:22


### MultiQC Report

Potential issues:

	* % duplication -
		* Alb: 0.10 - 5.00%, Contemp: 0.80 - 3.30%
	* GC content -
		* Alb: 34 - 54%, Contemp: 37 - 41%
	* number of reads -
		* Alb: 0 - 4.4 M, Contemp: 0.3 - 5.5 M

</details>


<details>
        <summary>13. Calculate the percent of reads lost in each step</summary>

This is now accomplished in another way using the process_sequencing_metadata repo. Move onto the next step.

</details>


<details>
        <summary>14. Clean Up</summary>

Move `*.out` files into `logs` directory

```
cd 
mv *out logs/
```




