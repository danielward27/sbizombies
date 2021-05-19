#!/bin/env bash
#PBS -l select=1:ncpus=1
#PBS -l walltime=00:10:00
#PBS -o ./logs/
#PBS -e ./logs/
#PBS -J 1-5

cd ${PBS_O_WORKDIR}
source load_modules.sh

echo Start Time: $(date)
Rscript simulation_chunks.R
echo End Time: $(date)
