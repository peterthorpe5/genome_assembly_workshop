#title: this script splits up the huge EMBL file made by the perl scripts
 # into one file per contig

#why? so these can be drawn with genomediagram


import os
from sys import stdin,argv

# make a folder for the out file. There could be thousands

file_name = 'test.txt'
working_dir = os.getcwd()
dest_dir = os.path.join(working_dir, 'individual_files')
try:
    os.makedirs(dest_dir)
except OSError:
    print "already exists"

#function to split it up    
#############################################################################################
def emble_file_splitter(embl_file, prefix):
    """input is the huge embl file.
    out are individual files fo each contig"""
    f_in= open(embl_file, "r")
    data = f_in.readlines()
    #f_out = open("test.txt", "w")
    #load the data
    body = ""
    title=""
    for line in data:
        string_to_replace = 'tag="'+prefix
        line = line.replace('tag="mRNA', string_to_replace)
        if line.startswith("ID   "):
            new_file_name = line.split("ID   ")[1]
            new_file_name = new_file_name.split("|")[0]
            title = ""
            body = ""
            
            title = line.rstrip("\n")+"; SV ; ; ; ; ; "
            out_name = "./individual_files/%s.embl" %(new_file_name.rstrip("\n"))
            #print out_name
            
        elif line.startswith("SQ   Sequence"):
            body = body+line
            seq_len = line.replace(";", ".").split("SQ   Sequence ")[1]
            title = "%s%s" %(title,seq_len.rstrip("\n"))
        else:
            body = body+line
        if "//" in line:
            #end of the contig
            f_out = open(out_name, "w")
            print >> f_out, "%s\n%s" %(title, body)

            f_out.close()
            

###############################################################################################        
print """usage: python plit_up_EMBL...py file.EMBL prefix_to_replace (eg. Rpa)

when making the EMBL file, it is one large file. To draw a genome diagram for each scaffold.
Individual EMBLs are required. This script will do this.

The GFF to EMBL conversion does not preserve the gene names. So prefix is used to
replace mRNA with prefix.

e.g. mRNA0001 is changed to Rpa0001 is, Rpa is sys arg 2. 
"""

emble_file_splitter(argv[1], argv[2])
print 'done'
