#!/bin/bash
#$ -V ## pass all environment variables to the job, VERY IMPORTANT
#$ -N FastQCTraining ## job name
#$ -S /bin/bash ## shell where it will run this job
#$ -j y ## join error output to normal output
#$ -cwd ## Execute the job from the current working directory
#$ -l hostname=marvin  # can only download from this node

# this line takes us into the correct directory where the data is
cd $HOME/genome_assembly_workshop/




# this line run fastqc on a data file.
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR861/ERR861370/ERR861370_1.fastq.gz

echo "R1 dowloaded"
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR861/ERR861370/ERR861370_2.fastq.gz

echo "finished"


