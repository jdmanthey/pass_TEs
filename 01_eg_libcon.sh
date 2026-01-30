#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=libcon
#SBATCH --partition nocona
#SBATCH --nodes=1 --ntasks=120
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --array=1-83

source activate earlygrey

threads=120

# define main working directory
workdir=/lustre/scratch/jmanthey/03_passtes

# variables for directory name, fasta complete name, and name of organism
directory_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/raw_reference_list.txt | tail -n1 | cut -f1)

fasta_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/raw_reference_list.txt | tail -n1 | cut -f2)

name_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/raw_reference_list.txt | tail -n1 | cut -f3)

# run Earl Grey for library construction from the reference
earlGreyLibConstruct -g ${workdir}/raw_reference_genomes/${directory_array}/${fasta_array} \
-i 5 -s ${name_array} -o ${workdir}/01_annotations/ -n 20 -t $threads
