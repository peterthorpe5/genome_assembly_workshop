#$ -cwd

cd $HOME

# to activate the software, paste the following in your terminal (with the dot):
. /shelf/apps/pjt6/conda/etc/profile.d/conda.sh 

# copy (cp) all (-rv) the training files to your home directory (~/)
cp -rv /shelf/Computational_Genomics/genome_assembly_workshop/ ~/
wait

cd $HOME/genome_assembly_workshop/

#####################################################################
# Quality control
# load the software called fastqc
module load FASTQC

fastqc ./reads/subsampled_R1.fastq.gz
fastqc ./reads/subsampled_R2.fastq.gz

# look at the output of both. Note R2 quality drops off. 

# now lets quality trim the reads
java -jar /shelf/training/Trimmomatic-0.38/trimmomatic-0.38.jar PE -summary trim_summary.txt \
-threads 2 -phred33 ./reads/subsampled_R1.fastq.gz ./reads/subsampled_R2.fastq.gz subsampled_R1_paired.fastq.gz \
subsampled_R1_unpaired.fastq.gz subsampled_R2_paired.fastq.gz subsampled_R2_unpaired.fastq.gz \
ILLUMINACLIP:/shelf/training/Trimmomatic-0.38/adapters/TruSeq3-PE.fa:2:30:10 \
LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:45 

# Look at the trim summary file. This will tell you how much data was removed. 

# now lets do QC again and see what the QC trimming did to the reads
fastqc subsampled_R1_paired.fastq.gz
fastqc subsampled_R2_paired.fastq.gz

# look at these html files, is the R2 files looking better now?
# we do not want to try and assemble low quality data and this could make a very messy
# graph and confuse the assembler. 

result="Using PrefixPair: 'TACACTCTTTCCCTACACGACGCTCTTCCGATCT' and 'GTGACTGGAGTTCAGACGTGTGCTCTTCCGATCT'
ILLUMINACLIP: Using 1 prefix pairs, 0 forward/reverse sequences, 0 forward only sequences, 0 reverse only sequences
Input Read Pairs: 1933183 Both Surviving: 1863570 (96.40%) Forward Only Surviving: 54968 (2.84%) Reverse Only Surviving: 2846 (0.15%) Dropped: 11799 (0.61%)
TrimmomaticPE: Completed successfully"

###################################################################
# Genome assembly
# load the velvet module
module load velvet/gitv0_9adf09f

# raw 
velveth directory_raw 53 -shortPaired -fastq ./reads/subsampled_R1.fastq.gz ./reads/subsampled_R2.fastq.gz
velvetg directory_raw


# qc trimmedd 
velveth directory_trimmed 53 -shortPaired -fastq ./subsampled_R1_paired.fastq.gz ./subsampled_R2_paired.fastq.gz
velvetg directory_trimmed


# lets see if the qc reads assembled better than the raw reads
perl ~/genome_assembly_workshop/shell_scripts/scaffold_stats.pl -f ./directory_raw/contigs.fa ./directory_trimmed/contigs.fa > assembly.stats

more assembly.stats

####################################################################
# predict genes
# load the software called prokka
conda activate prokka

prokka --cpus 8 ./directory_trimmed/contigs.fa

####################################################################
# now lets find out what we have just assembled



cd $HOME/genome_assembly_workshop/directory_trimmed

######################################################################
# lets use BLAST to try and see what the mistery data set was. 
# The likely hood is, it didnt assemble well.
# Let BLASTN a contig against GenBank nt

# this is where the nr nt diamond db are
export BLASTDB=/shelf/public/blastntnr/blastDatabases


# latest version of blast - this will now be in your path
export PATH=/shelf/apps/ncbi-blast-2.7.1+/bin/:$PATH

# just grab some of the contigs file. Otherwise, it will take ages. 
head -n 20 contigs.fa >  first_20_lines.txt

# tabular output - most useful to me. 
blastn -task megablast -query first_20_lines.txt -db nt -outfmt \
'6 qseqid staxids bitscore std scomnames sscinames sblastnames sskingdoms stitle' \
-evalue 1e-20 -out n.first_20_lines.txt_versus_ntOutfmt6.out -num_threads 4


