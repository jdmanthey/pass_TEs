#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=censor
#SBATCH --partition nocona
#SBATCH --nodes=1 --ntasks=48
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=4G

source activate censor

BLASTDIR=/home/jmanthey/miniconda3/envs/censor/bin/

censor.ncbi _others_seqs.fasta -mode norm -tab _others_summary_table.txt -lib vertebrate_repbase_31.08_added1.fasta \
-bprm '-a 48 -F=none' -show_simple

