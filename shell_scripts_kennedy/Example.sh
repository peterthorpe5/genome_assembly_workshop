#!/bin/bash -l
#SBATCH -J example   #jobname
#SBATCH -N 1     #node
#SBATCH --ntasks-per-node=1
#SBATCH --threads-per-core=2
#SBATCH -p singlenode
#SBATCH --mem=1GB

cd ~/scratch/genome_assembly_workshop/
echo "I am running the script"
echo "tell me someting good"



