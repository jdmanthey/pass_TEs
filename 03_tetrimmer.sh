#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=tetrimmer
#SBATCH --partition nocona
#SBATCH --nodes=1 --ntasks=40
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --array=1-107

threads=40

# define main working directory
workdir=/lustre/scratch/jmanthey/03_passtes

# variables for directory name, fasta complete name, and name of organism
directory_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/raw_reference_list.txt | tail -n1 | cut -f1)

genome_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/raw_reference_list.txt | tail -n1 | cut -f2)

name_array=$( head -n${SLURM_ARRAY_TASK_ID} ${workdir}/raw_reference_list.txt | tail -n1 | cut -f3)

# make the which command compatible with the container
unset -f which

# run TEtrimmer
singularity exec --writable-tmpfs \
--bind ${workdir}/02_strainer_files/:/input \
--bind ${workdir}/raw_reference_genomes/${directory_array}:/genome \
--bind ${workdir}/03_tetrimmer:/output \
--bind /home/jmanthey/TEtrimmer/pfam_database:/pfam \
~/tetrimmer_1.5.4--hdfd78af_0.sif \
TEtrimmer \
-i /input/${name_array}-families.fa.strained \
-g /genome/${genome_array} \
-o /output/${name_array} \
--pfam_dir /pfam \
-t $threads --classify_all











