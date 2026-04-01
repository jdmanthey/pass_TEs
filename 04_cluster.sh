#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=cdhit
#SBATCH --partition nocona
#SBATCH --nodes=1 --ntasks=10
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --array=1-47

workdir=/lustre/scratch/jmanthey/03_passtes/eg1_out_combined

fasta_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/fasta_list.txt | tail -n1 )

out_array=${fasta_array%.fasta}_90.fasta

threads=10

cd-hit-est -i $fasta_array -o $out_array -c 0.90 -n 8 -s 0.8 -T $threads -M 35000

