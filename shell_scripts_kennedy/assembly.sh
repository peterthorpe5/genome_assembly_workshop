#!/bin/bash -l
#SBATCH -J fastqc   #jobname
#SBATCH -N 1     #node
#SBATCH --ntasks-per-node=1
#SBATCH --threads-per-core=2
#SBATCH -p bigmem
#SBATCH --mem=4GB



# this line takes us into the correct directory where the data is
cd ~/scratch/genome_assembly_workshop/

# activate the software
export PATH=/gpfs1/scratch/bioinf/BL4273/conda/envs/genome_workshop/bin/:$PATH


# velvet : https://github.com/dzerbino/velvet 

##########################################################################################
# set this up with the trimmed reads.  We can compare all the assemblis after
# THE FOLLOWING LINE NEEDS YOUR INPUT (CHANGE ME)
# velveth directory_trim kmer_length(CHANGE_ME) -shortPaired -fastq R1.fq.gz R2.fq.gz
# velvetg directory_trim

#########################################################################################
# raw reads have been subsampled. Every 100th read taken
#velveth directory_subsampled 53 -shortPaired -fastq  ./reads/subsampled_R1.fastq.gz ./reads/subsampled_R2.fastq.gz ./reads/subsampled_R2.fastq.gz
#velvetg directory_subsampled

# raw data 

#########################################################################################
# qc trimmedd 
velveth directory_raw 53 -shortPaired -fastq ./reads/subsampled_R1.fastq.gz ./reads/subsampled_R2.fastq.gz
velvetg directory_raw

#########################################################################################
# qc trimmedd 
velveth directory_trimmed 53 -shortPaired -fastq ./subsampled_R1_paired.fastq.gz ./subsampled_R2_paired.fastq.gz
velvetg directory_trimmed








