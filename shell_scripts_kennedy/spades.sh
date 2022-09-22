#!/bin/bash -l
#SBATCH -J spades   #jobname
#SBATCH -N 1     #node
#SBATCH --ntasks-per-node=2
#SBATCH -p debug
#SBATCH --mem=20GB

cd ~/scratch/genome_assembly_workshop/

# to activate the software, paste the following in your terminal:
# activate the software
export PATH=/gpfs1/scratch/bioinf/BL4273/conda/envs/genome_workshop/bin/:$PATH

# set up some variables
threads=2



spades.py -1 ./reads/ERR861370_1.fastq.gz \
    -2 ./reads/ERR861370_2.fastq.gz \
    -o spades -t ${threads}  

