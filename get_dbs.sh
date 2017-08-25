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


is_command_installed makeblastdb


mkdir databases
cd databases

echo
echo Dowloading databases ...
echo

wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/16SMicrobial.tar.gz
wget ftp://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nt.gz

echo
echo Unpacking databases ...
echo

tar xvzf 16SMicrobial.tar.gz
gunzip nt.gz

echo
echo Preparing databases ...
echo

makeblastdb -in nt -dbtype nucl

