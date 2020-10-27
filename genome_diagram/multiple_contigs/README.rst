
READme: This is a readme to draw the genome diagrams .pdf for all contigs. 
==========================================================================
 WHY THIS?
In the workshop, the script I coded did not allow for more than one contig in the file. 

This is a long winded fix:


# first you have to convert the GFF to EMBL. This is not straight forward. 

1)  copy this perl script ``GFF_to_EMBL.pl`` and the perl module file ``Seq.pm`` to the folder where the prokka
output is generated (gene predictions). (you can use paths if you are confident enough, so then you can keep it where you want 
- this is better in the long run!)

2) convert: (if is complains about a missing module, copy this file to where you are working: ``Seq.pm``)
Note: you should not need to alter any files. This should just work for you. 

    USAGE:
    ``perl GFF_to_EMBL.pl   genome.fasta   prokka.gff >   OUT.EMBL``

    real example: ``perl /path_to/GFF_to_EMBL.pl /path_to/scaffolds.fasta PROKKA_123XZY.gff > prokka.embl``
    this example assumes you are in the same directory as the PROKKA_123XZY.gff, otherwise, just add the full path


Now make sure the ``prokka.embl`` files is not emtpy
(Perl is another coding language) -  look at the file to introduce yourself to another different syntax. 

3) split this embl file up: We need to create a .embl file for each contig.. 
If you want to run this like the example below, make sure the ``split_up_EMBLfile_individual_files.py`` is in the same directory as your
outputted ``prokka.embl`` - which you have checked is not empty. 

    # Make sure you have the software ready to use (note dot space):
    ``. /shelf/apps/pjt6/conda/etc/profile.d/conda.sh``

    ``conda activate python27``
    
    USAGE: python split_up_EMBLfile_individual_files.py prokka.embl prefix_any_name

    ``python split_up_EMBLfile_individual_files.py   prokka.embl  unknown``

This will output each contig into its own embl file, which can then be used as input for drawing. 
The ouput is in a folder called ``individual_files``

4) draw the genes (you cannot use the script from the workshop for this. Use the one in this
 " fix directory"  ``Genome_diagram_all_contigs.py``):

change directory into the "individual_files"

    ``cd individual_files``

we need a different python set up for this, the python2.7 script you used above was coded 10 years ago :)

``conda activate python36 ``
(copy the ``Genome_diagram_all_contigs.py`` file to the individual_files directory to run it). 
It will go though all the files and ouput .pdfs for you. 

``python Genome_diagram.py``

