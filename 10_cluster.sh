#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=cdhit
#SBATCH --partition nocona
#SBATCH --nodes=1 --ntasks=10
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=4G

source activate censor

threads=10

cd-hit-est -i _CR1_seqs_step2.fasta -o _CR1_seqs_step3.fasta -c 0.95 -n 8 -T $threads -M 35000

cd-hit-est -i _ERV_seqs_step2.fasta -o _ERV_seqs_step3.fasta -c 0.95 -n 8 -T $threads -M 35000



