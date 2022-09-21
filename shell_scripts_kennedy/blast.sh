#!/bin/bash -l
#SBATCH -J fastqc   #jobname
#SBATCH -N 1     #node
#SBATCH --ntasks-per-node=2
#SBATCH --threads-per-core=2
#SBATCH -p bigmem
#SBATCH --mem=4GB


cd $HOME/genome_assembly_workshop//directory_trimmed

######################################################################
# lets use BLAST to try and see what the mistery data set was. 
# The likely hood is, it didnt assemble well.
# Let BLASTN a contig against GenBank nt

# this is where the nr nt diamond db are
export BLASTDB=/gpfs1/scratch/bioinf/db/databases/

# just grab some of the contigs file. Otherwise, it will take ages. 
head -n 10 contigs.fa >  first_10_lines.txt

# long lines split up with \ character. Interpreted as one line
blastn -query first_10_lines.txt -db nt -outfmt 1 \
 -evalue 1e-40 -out n.first_10_lines.txt_versus_nt_outfmt1.out -num_threads 4

# tabular output - most useful to me. 
blastn -task megablast -query first_10_lines.txt -db nt -outfmt \
'6 qseqid staxids bitscore std scomnames sscinames sblastnames sskingdoms stitle' \
-evalue 1e-20 -out n.first_10_lines.txt_versus_ntOutfmt6.out -num_threads 4
