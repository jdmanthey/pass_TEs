#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=repeatmasker
#SBATCH --partition nocona
#SBATCH --nodes=1 --ntasks=36
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --array=1-106

threads=36

# define main working directory
workdir=/lustre/scratch/jmanthey/03_passtes

# variables for directory name, fasta complete name, and name of organism
directory_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/raw_reference_list.txt | tail -n1 | cut -f1)

fasta_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/raw_reference_list.txt | tail -n1 | cut -f2)

name_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/raw_reference_list.txt | tail -n1 | cut -f3)

# run Repeat Masker
RepeatMasker -pa $threads -s \
-lib ~/RepeatMasker/Libraries/vertebrate_repbase_31.08_added2.fasta \
-dir ${name_array} \
${workdir}/raw_reference_genomes/${directory_array}/${fasta_array}
