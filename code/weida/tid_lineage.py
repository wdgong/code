#1/nas02/apps/python-2.7.6/bin/python
import sys
import mysql.connector

# Set up MySQL connection to marine_ref_db on bioapts.its.unc.edu

#mysql -h bioapps.its.unc.edu -D marine_ref_db -u marine_user -p
cnx = mysql.connector.connect(user='marine_user', password='marine_user_ro',
                              host='bioapps-7-6',
                              database='marine_ref_db')
cursor = cnx.cursor()

# Open file - File name is first command line argument
infilename = sys.argv[1]
outfilename = sys.argv[1]+".tid_lineage.out"
infile = open(infilename, "r")
outfile = open(outfilename, "w")

# Read file line by line
for line in infile:

    if (line[0]=='#'):
        # If first character is '#', just output line
        outfile.write(line)
    else:
        # Else, run query to get taxon_name and sequence display_id

        # Split line on "\t" to get array
        line_elements = line.split("\t")
        line_elements.insert(17,0)

        # Second element (index 1) corresponds to subject_id
        subject_id = line_elements[1]

        # Build MySQL query
        query = ("SELECT tn.name, tfl.taxon_id, tfl.full_lineage "
                 "FROM seq_annot AS sa, "
                 "     tax_names AS tn, "
                 "     tax_full_lineage AS tfl "
                 "WHERE sa.taxon_id = tn.taxon_id AND "
                 "      sa.taxon_id = tfl.taxon_id AND "
                 "      sa.seq_id = %s;")

        # Run MySQL query
        cursor.execute(query % subject_id)

        # Get results of MySQL query
        taxon_name = ''
        taxon_id = ''
        full_lineage = ''
        rows = cursor.fetchall()
        for row in rows:
            taxon_name = row[0]
            taxon_id = row[1]
            full_lineage = row[2]

        # Build output line replacing 16th and 17th columns
        line_elements[15]=taxon_name
        line_elements[16]=str(taxon_id)
        line_elements[17]=full_lineage
        outfile.write("\t".join(line_elements)+"\n")

# Close file and MySQL interface
infile.close()
outfile.close()
cursor.close()
cnx.close()
