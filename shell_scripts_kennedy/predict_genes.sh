#!/bin/bash -l
#SBATCH -J all   #jobname
#SBATCH -N 1     #node
#SBATCH --ntasks-per-node=4
#SBATCH --threads-per-core=2
#SBATCH -p bigmem
#SBATCH --mem=10GB


cd ~/scratch/genome_assembly_workshop/


# activate the software
export PATH=/gpfs1/scratch/bioinf/BL4273/conda/envs/genome_workshop/bin/:$PATH

######################################################################
#  use prokka to predict genes
# install in conda first
# conda activate prokka
# then submit the shell with the -V option.
# conda commands do not currently work in qrsh or when put in shell scripts. 
# sorry. We are working on that!!!


# https://github.com/tseemann/prokka

# must be full path here
prokka --cpus 4 ~/scratch/genome_assembly_workshop/directory_trimmed/contigs.fa


