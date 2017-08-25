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
			name = line[1:].split(" ")[0]
			sequences[name]=""
		else:
			sequences[name]+=line


	total_bp=0
	for name in sequences.keys():
		total_bp+=len(sequences[name])


	added_queries={}
	best_hits={}
	input_file2 = [n for n in open(inputOptions[0],'r').read().replace("\r","").split("\n") if len(n)>0]
	for line in input_file2:

		query=line.split("\t")[0]
		idendities=int(line.split("\t")[7])
		alignment_length=int(line.split("\t")[5])
				
		species_line=line.split("\t")[2]
				
		species=species_line.split(" ")[1]

		k=2
		if species_line.lower().find("subsp.")!=-1:
			k=4
		for i in range(1,k):
			species+=" "+species_line.split(" ")[i+1]
				
		coverage=round((float(alignment_length)/float(int(line.split("\t")[5]))),3)
		alignmnt_similarity=round((float(idendities)/float(alignment_length)),3)


		if alignmnt_similarity>=0.9 and ((alignment_length*3>len(sequences[query])) or (alignment_length >= 10000)) and (query in added_queries.keys())== bool(0):


			if (species in best_hits.keys())==bool(0):
				best_hits[species]=0
			best_hits[species]+=len(sequences[query]) 
			added_queries[query]=1

	to_print=""
	for species in sorted(best_hits.items(), key=operator.itemgetter(1), reverse=True):

		percentage=float(species[1])/float(total_bp)*100
		if percentage >= 1:
			to_print+=species[0]+":"+str(round(percentage,2))+", "

	print inputOptions[2]+"\t"+to_print
		

	

main()		
