#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=srf
#SBATCH --partition nocona
#SBATCH --nodes=1 --ntasks=16
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --array=1-106

threads=16

# define main working directory
workdir=/lustre/scratch/jmanthey/03_passtes

# variables for directory name, fasta complete name, and name of organism
directory_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/raw_reference_list.txt | tail -n1 | cut -f1)

fasta_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/raw_reference_list.txt | tail -n1 | cut -f2)

name_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/raw_reference_list.txt | tail -n1 | cut -f3)

# make temp directory
mkdir temp_${name_array}


# count high-occurrence k-mers in assembly
kmc -fm -k151 -ci20 -cs100000 -t16 -sr16 -sf16 -sp16 \
${workdir}/raw_reference_genomes/${directory_array}/${fasta_array} \
${name_array}_count.kmc temp_${name_array}

kmc_dump ${name_array}_count.kmc ${name_array}_count.txt


# assemble satellite DNA
srf  ${name_array}_count.txt > ${name_array}_srf.fa


# analyze
# enlong short contigs for mapping
srfutils.js enlong ${workdir}/raw_reference_genomes/${directory_array}/${fasta_array} > enlong_${fasta_array}


# align
minimap2 -c -N1000000 -f1000 -r100,100 ${name_array}_srf.fa enlong_${fasta_array} > srf-aln_${name_array}.paf

# filter and extract non-overlapping regions
srfutils.js paf2bed srf-aln_${name_array}.paf > srf-aln__${name_array}.bed  

# calculate abundance of each srf contig
srfutils.js bed2abun srf-aln__${name_array}.bed > srf-aln__${name_array}.len  

# remove files
rm enlong_${fasta_array}
rm srf-aln_${name_array}.paf
rm -rf temp_${name_array}
rm ${name_array}_count.kmc.kmc_pre
rm ${name_array}_count.kmc.kmc_suf
rm ${name_array}_count.txt




