#!/bin/bash -l
#SBATCH -J spades   #jobname
#SBATCH -N 1     #node
#SBATCH --ntasks-per-node=4
#SBATCH --threads-per-core=2
#SBATCH -p singlenode
#SBATCH --mem=20GB

cd ~/scratch/bioinf/${USER}/genome_assembly_workshop/

# to activate the software, paste the following in your terminal:
# activate the software
export PATH=/gpfs1/scratch/bioinf/BL4273/conda/envs/genome_workshop/bin/:$PATH

# set up some variables
threads=4



spades.py -1 ./reads/ERR861370_1.fastq.gz \
    -2 ./reads/ERR861370_2.fastq.gz \
    -o spades -t 4 

