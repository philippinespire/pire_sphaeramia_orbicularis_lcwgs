#!/bin/bash -l

#SBATCH --job-name=ATLAS_recal_theta
#SBATCH -o ATLAS_recal_theta-%j.out 
#SBATCH -p main 
#SBATCH -n 1  
#SBATCH -N 1  
#SBATCH --cpus-per-task=40 

enable_lmod
module load container_env bwa
crun.bwa bwa
module load container_env samtools
crun.samtools samtools
module load container_env atlas/20240503
export SINGULARITY_BIND=/home/e1garcia

BAMDIR=$1
REFLOC=$2
OUTDIR=$3

BAMPATTERN=*merged.rmdup.merged.realn.bam

all_samples=$(ls $BAMDIR/$BAMPATTERN | sed -e 's/\.merged\.rmdup\.merged\.realn\.bam//' -e 's/.*\///g')
all_samples=($all_samples)

sample_name=${all_samples[${SLURM_ARRAY_TASK_ID}]}
echo ${sample_name}

cd ${OUTDIR}

cp ${BAMDIR}/${sample_name}.merged.rmdup.merged.realn.bam .

crun.samtools samtools index ${sample_name}.merged.rmdup.merged.realn.bam

crun.atlas atlas --task estimateErrors --bam ${sample_name}.merged.rmdup.merged.realn.bam --fasta ${REFLOC} --regions bed1_nosingle.bed,bed2_nosingle.bed --readUpToDepth 10
