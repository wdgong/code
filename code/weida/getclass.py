#1/nas02/apps/python-2.7.6/bin/python
import sys


# Open file - File name is first command line argument
infilename = sys.argv[1]
outfilename = sys.argv[1][:-16]+".getclass.tab"
infile = open(infilename, "r")
outfile = open(outfilename, "w")

# Read file line by line
for line in infile:
    if (line[0]=='#'):
        # If first character is '#', just output line
        outfile.write(line)
    else:

        # Split line on "\t" to get array
        line_elements = line.split("\t")
        myclass = line_elements[17].split("=>")[4]
        line_elements.insert(18,myclass)
        outfile.write("\t".join(line_elements)+"\n")

# Close file and MySQL interface
infile.close()
outfile.close()
