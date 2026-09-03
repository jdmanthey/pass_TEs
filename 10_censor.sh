#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=censor
#SBATCH --partition nocona
#SBATCH --nodes=1 --ntasks=24
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=4G

source activate censor

BLASTDIR=/home/jmanthey/miniconda3/envs/censor/bin/

censor.ncbi combined_90.fasta -mode norm -tab summary_table.txt -lib custom_library_certhia_colaptes.fa \
-bprm '-a 24 -F=none' -show_simple






