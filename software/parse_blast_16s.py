import operator
import csv
import sys
import math
from Bio.Blast import NCBIXML


inputOptions = sys.argv[1:]

# usage: out_xml sequence.fasta  

def main():

	sequences={}
	input_file = [n for n in open(inputOptions[1],'r').read().replace("\r","").split("\n") if len(n)>0]
	for line in input_file:
		if line[0:1]==">":
			name = line[1:]
			sequences[name]=""
		else:
			sequences[name]+=line

	if len(sequences)==0:
		print inputOptions[2]+"\t"+"Bad assembly (low read number): No 16s found!"


	best_hits={}
	input_file2 = [n for n in open(inputOptions[0],'r').read().replace("\r","").split("\n") if len(n)>0]
	for line in input_file2:
		best_hits[line.split("\t")[0]]=line

	to_print=""

	total_bp=0
	for name in sequences.keys():

		if (name.split(" ")[0] in best_hits.keys()) == bool(1):
			line=best_hits[name.split(" ")[0]]

			total_bp+=len(sequences[name])


			idendities=int(line.split("\t")[7])
			alignment_length=int(line.split("\t")[5])
				
			species_line=line.split("\t")[2]
				
			species=species_line.split(" ")[0]

			k=2
			if species_line.lower().find("subsp.")!=-1:
				k=4
			for i in range(1,k):
				species+=" "+species_line.split(" ")[i]
				
			coverage=round((float(alignment_length)/float(int(line.split("\t")[5]))),3)
			alignmnt_similarity=round((float(idendities)/float(alignment_length)),3)
				
			to_print+=species +" ("+str(alignmnt_similarity)+", "+str(coverage)+"); "
		else:
			to_print+="Unknown species (0, 0); "

	print inputOptions[2]+"\t"+to_print

main()
				
