
READme: This is a readme to draw the genome diagrams .pdf for all contigs. 
==========================================================================
 WHY THIS?
The fix I sent for you will not work if the contig names are longer than 16 characters. This is the new
standard format for genbank files. Which has been breaking the scripts ... 

This is a long winded fix:


# first you have to rename the contigs names if the final assembly.  

1)  copy this python script ``rewrite_as_fasta.py``  to the folder where the genome assembly is outputted. 

    # Make sure you have the software ready to use (note dot space):
    ``. /shelf/apps/pjt6/conda/etc/profile.d/conda.sh``

    ``conda activate python36``

    USAGE:
    ``python rewrite_as_fasta.py  -i genome.fasta   -o prokka.gff``
    
    real example: `` python rewrite_as_fasta.py -i scaffolds.fasta -o fixed.fasta``


this will rename all the contigs for you. 

Now repredict the genes. 

2) repredict the genes:

    ``conda activate prokka``

    ``prokka --cpus 8 /path_to_/fixed.fasta``


3) change directory into the PROKKA ouptu:

    ``cd PROKKA_XYZ/``
    
 copy the python file: Genome_diagram_multi_contigs.py
 
 run it
 
    ``python Genome_diagram_multi_contigs.py``