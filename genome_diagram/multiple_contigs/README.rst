# This is a readme to draw the genome diagrams .pdf for all contigs. 

 WHY THIS?
In the workshop, the script I coded did not allow for more than one cotig in the file. 

This is a long winded fix:


# first you have to convert the GFF to EMBL. This is not straight forward. 

1) copy this perl script GFF_to_EMBL.pl and the perl module file Seq.pm to the folder with the prokka
output is generated. (you can use paths if you are confident enough, so then you can keep it where you want 
- this is better in the long run!)

2) convert: (if is complains about a missing module, copy this to where you are working: Seq.pm)

    perl ./GFF_to_EMBL.pl genome.fasta prokka.gff > OUT.EMBL

    real example: perl ./GFF_to_EMBL.pl ../scaffolds.fasta PROKKA_10262020.gff > prokka.embl

3) split this embl file up. 

    # Make sure you have the software ready to use (note dot space):
    . /shelf/apps/pjt6/conda/etc/profile.d/conda.sh

    conda activate python27

    python split_up_EMBLfile_individual_files.py   prokka.embl  unknown

This will output each contig into its own embl file, which can then be used as input for drawing. 
The ouput is in a folder called "individual_files"

4) draw the genes (you cannot use the script from the workshop for this. Use the one in this
 " fix directory"):

change directory into the "individual_files"

conda activate python36 
(copy the Genome_diagram.py file to this directory to run it). 
It will go though all the files and ouput .pdfs for you. 

python Genome_diagram.py

