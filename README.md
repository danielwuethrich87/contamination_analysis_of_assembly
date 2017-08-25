Bacterial genome assembly pipeline
=======================

This pipeline compares the assembly of a bacterial genome against the NT database.

#Requirements:

-Linux 64 bit system<br />

-python (version 2.7)<br />
-BLAST (version 2.6.0+)<br />


#Installation:

wget https://github.com/danielwuethrich87/contamination_analysis_of_assembly/archive/master.zip<br />
unzip master.zip
cd contamination_analysis_of_assembly
sh get_dbs.sh

#Usage:

  sh contamination_analysis.sh <Sample_ID> <Final_contigs> <Low_qual_contigs> <Prokka_ffn_file> <Number_of_cores><br />
 
  <Sample_ID>               Unique identifier for the sample<br />
  <Final_contigs>           Final genome assembly contigs<br />
  <Low_qual_contigs>        Excluded contigs<br />
  <Prokka_ffn_file>         Prokka .ffn CDS annotation file<br />
  <Number_of_cores>         number of parallel threads to run (int)<br />

#example:


#!/bin/sh<br />
#$ -q all.q<br />
#$ -e $JOB_ID.cov.err<br />
#$ -o $JOB_ID.cov.out<br />
#$ -cwd<br />
#$ -pe smp 24<br />

module add Blast/ncbi-blast/2.6.0+;<br />

for i in FAM22234<br />

do<br />

sh /home/dwuethrich/Application/contamination_analysis/contamination_analysis.sh "$i" ../assembly/results/"$i"/3_annotation/"$i".fna ../assembly/results/"$i"/3_annotation/Low_coverage_and_short_scaffolds_"$i".fasta ../assembly/results/"$i"/3_annotation/"$i".ffn "$NSLOTS"<br />

done<br />

