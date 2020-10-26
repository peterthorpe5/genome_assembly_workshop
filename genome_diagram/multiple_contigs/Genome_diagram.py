
"""
this is an untaural process of voodoo to make a very pretty picture!!!

"""

############################################################################
#imports.......

from reportlab.lib import colors
from reportlab.lib.units import cm
# Biopython core
from Bio import SeqIO
from Bio import GenBank
from Bio.SeqFeature import SeqFeature, FeatureLocation
#to loop over files in the folder
import os

# Bio.Graphics.GenomeDiagram
from Bio.Graphics.GenomeDiagram import Diagram

################################################################

################################################################

def get_names_of_interest(interesting_names):
    with open(interesting_names) as file:
        return file.read().split("\n")

# load the gene of interest ....    


MIN_GAP_JAGGY = 1000
def add_jaggies(contig_seq, offset, gd_contig_features):
    """Add JAGGY features for any run of NNNN or XXXX in sequence."""
    contig_seq = contig_seq.upper().replace("X", "N")
    i = 0
    j = 0
    NNN = "N" * MIN_GAP_JAGGY
    while i < len(contig_seq):
        i = contig_seq.find(NNN, i)
        if i == -1:
            return
        j = i
        while j < len(contig_seq) and contig_seq[j] == "N":
            j += 1
        #print("Adding jaggy")
        gd_contig_features.add_feature(SeqFeature(FeatureLocation(offset+i,
                                                                  offset+j)),
                                       sigil="JAGGY",
                                       color=colors.slategrey,
                                       border=colors.black)
        i = j + 1


def squash_exons(feature):
    """Makes a new SewqFeature discarding the exon information."""
    start = feature.location.start
    end = feature.location.end
    strand = feature.location.strand
    return SeqFeature(FeatureLocation(start, end, strand),
                      type=feature.type,
                      qualifiers=feature.qualifiers)


def draw_me_something_nice (infile, outfile, outfile2 = None):
    """function to draw genome diagrams by looping over
    a load of gbk files in a folder>>> this is supposed to add
    effectors of interest on as coloured items"""
    genbank_entry = SeqIO.read(open(infile), "embl")
    gdd = Diagram('Test Diagram')
    #Add a track of features,
    gdt_features = gdd.new_track(1, greytrack=True,
                                 name="CDS Features",
                                 scale_largetick_interval=10000,
                                 scale_smalltick_interval=1000,
                                 scale_fontsize=4,
                                 scale_format = "SInt",
                                 greytrack_labels=False, #e.g. 5
                                 height=0.75)

    #We'll just use one feature set for these features,
    gds_features = gdt_features.new_set()
    add_jaggies(str(genbank_entry.seq), 0, gds_features)
    count = 0
    for feature in genbank_entry.features:
        count = count +1
        shape = "ARROW"
        #if feature.type not in ["CDS", "tRNA", "rRNA"] :
        if feature.type in ["source", "gene"] :#["source", "CDS"]
            #print "CDS"
            #We're going to ignore these (ignore genes as the CDS is enough)
            continue

        #Note that I am using strings for color names, instead
        #of passing in color objects.  This should also work!
        color2 = "grey"
        if feature.type == "tRNA" :
            color = "red"
        elif feature.type == "rRNA":
            color = "purple"
        elif feature.type == "gap":
            color = "grey"
            shape = "JAGGY"
            feature.strand = None #i.e. draw it strandless
        elif feature.type != "CDS" :
            color = "lightgreen"
        # adding two features per gene, so not just odd/even:
        #elif len(gds_features) % 4 == 0 :
        elif count % 2 ==0:
            color = "blue"
            color2 = "lightblue"
            color = colors.Color(0, 0, 1, 0.9)
            color2 = colors.Color(.678431,.847059,.901961,0.5)
        else :
            color = "green"
            color2 = "lightgreen"
            color = colors.Color(0, 0.501961, 0, 0.99)
            color2 = colors.Color(0.564706, 0.933333, 0.564706, 0.5)
        #colour the RNA_seq_full_list genes yellow
        
        gds_features.add_feature(squash_exons(feature), color=color2,
                                 sigil="BOX",
                                 #sigil=shape,
                                 arrowshaft_height=0.8,
                                 arrowhead_length=0.5,
                                 label_position = "start",
                                 label_size = 3,label_angle = 90,
                                 label=True)
        # Don't want the line round the feature as starts to overlap
        gds_features.add_feature(feature, border=False, color=color,
                                 sigil=shape,
                                 arrowshaft_height=0.6,
                                 arrowhead_length=0.5,
                                 label_position = "start",
                                 label_size = 1,label_angle = 90,
                                 label=False)

    gdd.draw(format='linear', orientation='landscape',
             tracklines=False, pagesize='A3', fragments=10)
    gdd.write(outfile, 'PDF')

    # And a circular version
    # Change the order and leave an empty space in the center:
    gdd.move_track(1,3)
    out2 = outfile.split(".pdf")[0] + "_circular.pdf"
    gdd.draw(format='circular', tracklines=False, pagesize=(30*cm,30*cm))
    gdd.write(out2, 'PDF')


###############################################################################

for filename in os.listdir("."):
    if not filename.endswith(".embl") : continue
    infile = filename
    outfile = filename.split(".embl")[0] + ".pdf"
    draw_me_something_nice (infile, outfile)


