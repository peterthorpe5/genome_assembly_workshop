#!/bin/bash -l
#SBATCH -J trimmo   #jobname
#SBATCH -N 1     #node
#SBATCH --ntasks-per-node=1
#SBATCH -p debug
#SBATCH --mem=4GB


# this line takes us into the correct directory where the data is
cd ~/scratch/genome_assembly_workshop/

# activate the software
export PATH=/gpfs1/scratch/bioinf/BL4273/conda/envs/genome_workshop/bin/:$PATH

###########################################################################
# this is how we ran fastqc (run this again on the trimmed reads)
#fastqc ecoli_R1.fastq.gz


###########################################################################
# this is how we will trim the reads - trimmomatic
#java -jar trimmomatic-0.35.jar PE -phred33 input_forward.fq.gz input_reverse.fq.gz output_forward_paired.fq.gz output_forward_unpaired.fq.gz output_reverse_paired.fq.gz output_reverse_unpaired.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
#
#This will perform the following:
#
#    Remove adapters (ILLUMINACLIP:TruSeq3-PE.fa:2:30:10)
#    Remove leading low quality or N bases (below quality 3) (LEADING:3)
#    Remove trailing low quality or N bases (below quality 3) (TRAILING:3)
#    Scan the read with a 4-base wide sliding window, cutting when the average quality per base drops below 15 (SLIDINGWINDOW:4:15)
#    Drop reads below the 36 bases long (MINLEN:36)
# \ chacter means you can look at one long command.  over multiple lines. 

trimmomatic PE -summary trim_summary.txt \
-threads 2 -phred33 ./reads/subsampled_R1.fastq.gz ./reads/subsampled_R2.fastq.gz subsampled_R1_paired.fastq.gz \
subsampled_R1_unpaired.fastq.gz subsampled_R2_paired.fastq.gz subsampled_R2_unpaired.fastq.gz \
ILLUMINACLIP:/gpfs1/scratch/bioinf/BL4273/conda/bin/TruSeq3-PE.fa:2:30:10 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:45 
