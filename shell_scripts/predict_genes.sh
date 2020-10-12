#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N GenePreTraining ## job name
#$ -S /bin/bash ## shell where it will run this job
####$ -j y ## join error output to normal output
#$ -cwd ## Execute the job from the current working directory


cd $HOME/genome_assembly_workshop 

######################################################################
#  use prokka to predict genes
# install in conda first
# conda activate prokka
# then submit the shell with the -V option.
# conda commands do not currently work in qrsh or when put in shell scripts. 
# sorry. We are working on that!!!


# https://github.com/tseemann/prokka

# must be full path here
prokka --cpus 8 $HOME/genome_assembly_workshop /directory_trimmed/contigs.fa


