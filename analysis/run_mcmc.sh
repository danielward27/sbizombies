#!/bin/env bash
#PBS -l select=1:ncpus=1
#PBS -l walltime=00:30:00
#PBS -o ./logs/
#PBS -e ./logs/
#PBS -J 1-100

cd ${PBS_O_WORKDIR}
source load_modules.sh

echo Start Time: $(date)
Rscript run_mcmc.R
echo End Time: $(date)
