#!/bin/bash -l
#SBATCH -J all   #jobname
#SBATCH -N 1     #node
#SBATCH --ntasks-per-node=2
#SBATCH -p debug
#SBATCH --mem=20GB


cp -rv /scratch/bioinf/BL4273/genome_assembly_workshop ~/scratch/

wait

cd ~/scratch/genome_assembly_workshop/

# set up some variables
kmer=127
threads=2

# activate the software
export PATH=/gpfs1/scratch/bioinf/BL4273/conda/envs/genome_workshop/bin/:$PATH


# download the reads:
echo "downloading the reads"
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/DRR021/DRR021340/DRR021340_1.fastq.gz
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/DRR021/DRR021340/DRR021340_2.fastq.gz

# it would be best to symbolic link these reads rather than everyone have them.
# ln -s file1 link1

# QC the raw
fqc_cmd="fastqc ./reads/DRR*.fastq.gz"
echo ${fqc_cmd}
eval ${fqc_cmd}

# trim the raw reads
trim_cmd="trimmomatic PE 
    -summary trim_summary.txt 
    -threads ${threads} -phred33 
    ./reads/DRR021340_1.fastq.gz ./reads/DRR021340_2.fastq.gz 
    DRR_R1_paired.fastq.gz DRR_R1_unpaired.fastq.gz 
    DRR_R2_paired.fastq.gz DRR_R2_unpaired.fastq.gz 
    ILLUMINACLIP:/gpfs1/scratch/bioinf/BL4273/conda/bin/TruSeq3-PE.fa:2:30:10 
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:30 MINLEN:147"
echo ${trim_cmd}
eval ${trim_cmd}

# QC the trimmed reads:
fqc_cmd="fastqc DRR*paired.fastq.gz"
echo ${fqc_cmd}
eval ${fqc_cmd}

# assemble with velvet
#########################################################################################
# qc trimmed 
velveth_raw_cmd="velveth unknown_raw_${kmer} ${kmer} -shortPaired 
        -fastq DRR021340_1.fastq.gz DRR021340_2.fastq.gz"
velvethg_raw="velvetg unknown_raw_${kmer}"
echo ${velveth_raw_cmd}
eval ${velveth_raw_cmd}
echo ${velvethg_raw}
eval ${velvethg_raw}

#########################################################################################
# qc trimmedd 
velveth_trim_cmd="velveth unknown_trimmed ${kmer} -shortPaired 
        -fastq DRR_R1_paired.fastq.gz DRR_R2_paired.fastq.gz"
velveg_assembl="velvetg unknown_trimmed"
echo ${velveth_trim_cmd}
eval ${velveth_trim_cmd}
echo ${velveg_assembl}
eval ${velveg_assembl}

# assembly stats
stats="perl /gpfs1/scratch/bioinf/BL4273/conda/bin/scaffold_stats.pl 
     -f ./unknown*/contigs.fa 
     > contig_${kmer}_len.stats.txt"
echo ${stats}
eval ${stats}

# blast something ....
# this is where the nr nt diamond db are
export BLASTDB=/gpfs1/scratch/bioinf/db/databases/

# just grab some of the contigs file. Otherwise, it will take ages. 
head -n 10 ./unknown_raw_${kmer}/contigs.fa >  first_10_lines.txt

# long lines split up with \ character. Interpreted as one line
# tabular output - most useful to me. 
blast_cmd="blastn -task megablast -query first_10_lines.txt -db nt -outfmt 
    '6 qseqid staxids bitscore std scomnames sscinames sblastnames sskingdoms stitle' 
    -evalue 1e-20 -out n.first_10_lines.txt_versus_ntOutfmt6.out 
    -num_threads ${threads}"
echo ${blast_cmd}
eval ${blast_cmd}
 
# predict genes
annotate="prokka --cpus ${threads} ./unknown_trimmed/contigs.fa "
echo ${annotate}
eval ${annotate}

# do assemblies over a whole range of kmers, odd numbers only:
# you should only assemble with odd kmer due to palindromes. 
# for kmer in {55..127} # this will take too long 19 hours!
for kmer in {55..99}
do
    rem=$(($kmer % 2))
    if [ "$rem" -ne "0" ]; then
        echo $kmer
        velveth_trim_cmd="velveth unknown_trimmed_${kmer} ${kmer} -shortPaired 
        -fastq DRR_R1_paired.fastq.gz DRR_R2_paired.fastq.gz"
        velveg_assembl="velvetg unknown_trimmed_${kmer}"
        echo ${velveth_trim_cmd}
        eval ${velveth_trim_cmd}
        echo ${velveg_assembl}
        eval ${velveg_assembl}
    fi
done


# assembly stats
stats="perl scaffold_stats.pl 
     -f ./unknown*/contigs.fa 
     > all_contig_len.stats.txt"
echo ${stats}
eval ${stats}
