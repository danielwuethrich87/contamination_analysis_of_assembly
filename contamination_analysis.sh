#!/bin/bash

export working_dir=$PWD
export cores=$5
export cds=$4
export excluded_contigs=$3
export contigs=$2
export sample_id=$1
export software_location=$(dirname $0)


echo
echo "Input:"
echo

echo number_of_cores:"$cores"
echo contigs:"$contigs"
echo excluded_contigs:"$excluded_contigs"
echo cds:"$cds"
echo sample_id:"$sample_id"


echo
echo "Checking software ..."
echo

is_command_installed () {
if which $1 &>/dev/null; then
    echo "$1 is installed in:" $(which $1)
else
    echo
    echo "ERROR: $1 not found."
    echo
    exit
fi
}


is_command_installed blastn
is_command_installed python

echo

if [ -r "$cds" ] && [ -r "$contigs" ]&& [ -r "$excluded_contigs" ] && [ "$cores" -eq "$cores" ] 

then

#actual analysis---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#16s analysis--------------------------------------------------------------------------------------------

mkdir -p "$working_dir"/results/"$sample_id"/blast_16s/

python "$software_location"/software/get_16s.py "$cds" > "$working_dir"/results/"$sample_id"/blast_16s/"$sample_id"_16S_genes.ffn 
blastn -db "$software_location"/databases/16SMicrobial -num_threads "$cores" -max_target_seqs 1 -max_hsps 1 -query "$working_dir"/results/"$sample_id"/blast_16s/"$sample_id"_16S_genes.ffn -out "$working_dir"/results/"$sample_id"/blast_16s/"$sample_id".tab -outfmt "6 qseqid sseqid stitle qlen slen length pident nident mismatch gaps evalue bitscore"

python "$software_location"/software/parse_blast_16s.py "$working_dir"/results/"$sample_id"/blast_16s/"$sample_id".tab "$working_dir"/results/"$sample_id"/blast_16s/"$sample_id"_16S_genes.ffn "$sample_id" > "$working_dir"/results/"$sample_id"/blast_16s/"$sample_id"_16S_species.txt

#WGS blast----------------------------------------------------------------------------------------------------

mkdir -p "$working_dir"/results/"$sample_id"/WGS/

blastn -db "$software_location"/databases/nt -num_threads "$cores" -max_target_seqs 1 -max_hsps 1 -query "$contigs" -out "$working_dir"/results/"$sample_id"/WGS/"$sample_id".results.tab -outfmt "6 qseqid sseqid stitle qlen slen length pident nident mismatch gaps evalue bitscore"

python "$software_location"/software/parse_blast_WGS.py "$working_dir"/results/"$sample_id"/WGS/"$sample_id".results.tab "$contigs" "$sample_id" > "$working_dir"/results/"$sample_id"/WGS/"$sample_id"_WGS_species.txt

blastn -db "$software_location"/databases/nt -num_threads "$cores" -max_target_seqs 1 -max_hsps 1 -query "$excluded_contigs" -out "$working_dir"/results/"$sample_id"/WGS/"$sample_id"_excluded_contigs_results.tab -outfmt "6 qseqid sseqid stitle qlen slen length pident nident mismatch gaps evalue bitscore"

python "$software_location"/software/parse_blast_WGS.py "$working_dir"/results/"$sample_id"/WGS/"$sample_id"_excluded_contigs_results.tab "$excluded_contigs" "$sample_id" > "$working_dir"/results/"$sample_id"/WGS/"$sample_id"_WGS_excluded_contigs_species.txt

#actual analysis---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

else

echo " "
echo "ERROR: Incorrect input!"
echo "contamination_analysis version 0.1 by Daniel Wüthrich (danielwue@hotmail.com)"
echo " "
echo "Usage: "
echo "  sh contamination_analysis.sh <Sample_ID> <Final_contigs> <Low_qual_contigs> <Prokka_ffn_file> <Number_of_cores>"
echo " "
echo "  <Sample_ID>               Unique identifier for the sample"
echo "  <Final_contigs>           Final genome assembly contigs"
echo "  <Low_qual_contigs>        Excluded contigs"
echo "  <Prokka_ffn_file>         Prokka .ffn CDS annotation file"
echo "  <Number_of_cores>         number of parallel threads to run (int)"
echo " "
if ! [ -r "$excluded_contigs" ];then
echo File not found: "$excluded_contigs"
fi
if ! [ -r "$contigs" ];then
echo File not found: "$contigs"
fi
if ! [ -r "$cds" ];then
echo File not found: "$cds"
fi
if ! [ -n "$sample_id" ];then
echo Incorrect input: "$sample_id"
fi
if ! [ "$cores" -eq "$cores" ] ;then
echo Incorrect input: "$cores"
fi


fi



