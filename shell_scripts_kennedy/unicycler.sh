#!/bin/bash -l
#SBATCH -J unicycle   #jobname
#SBATCH -N 1     #node
#SBATCH --ntasks-per-node=4
#SBATCH --threads-per-core=2
#SBATCH -p debug
#SBATCH --mem=20GB

# https://github.com/rrwick/Unicycler#quick-usage
cd ~/scratch/bioinf/${USER}/genome_assembly_workshop/

# to activate the software, paste the following in your terminal:
# activate the software
export PATH=/gpfs1/scratch/bioinf/BL4273/conda/envs/genome_workshop/bin/:$PATH
wait

conda activate unicyclerENV

cd $HOME/genome_assembly_workshop/

unicycler -1 ./reads/ERR861370_1.fastq.gz \
    -2 ./reads/ERR861370_2.fastq.gz \
    -o unicycler -t 4 

