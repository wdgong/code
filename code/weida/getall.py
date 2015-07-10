#1/nas02/apps/python-2.7.6/bin/python
import sys


# Open file - File name is first command line argument
infilename = sys.argv[1]
outfilename = sys.argv[1][:-16]+".getall.tab"
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
        myclass = line_elements[17].split("=>")
        myclass1 = line_elements[17].split("=>")[1]
        myclass2 = line_elements[17].split("=>")[2]
        myclass3 = line_elements[17].split("=>")[3]
        myclass4 = line_elements[17].split("=>")[4]
        line_elements.insert(18,myclass1)
        line_elements.insert(19,myclass2)
        line_elements.insert(20,myclass3)
        line_elements.insert(21,myclass4)
        if (len(myclass)<=5):
            line_elements.insert(22,'')
            line_elements.insert(23,'')
        elif (len(myclass)<=6):
            myclass5 = line_elements[17].split("=>")[5]
            line_elements.insert(22,myclass5)
            line_elements.insert(23,'')
        else:
            myclass5 = line_elements[17].split("=>")[5]
            myclass6 = line_elements[17].split("=>")[6]
            line_elements.insert(22,myclass5)
            line_elements.insert(23,myclass6)
        outfile.write("\t".join(line_elements)+"\n")

# Close file and MySQL interface
infile.close()
outfile.close()
