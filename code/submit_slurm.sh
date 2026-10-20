#!/bin/bash -l
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 32
#SBATCH --time=8-08:05:00
#SBATCH --mem-per-cpu 6G
#SBATCH --job-name=hotelling_sim
#SBATCH --output=results/%x_%j.txt

cd "$SLURM_SUBMIT_DIR"

echo "sbatch: START SLURM_JOB_ID $SLURM_JOB_ID \
(SLURM_TASK_PID $SLURM_TASK_PID) on $SLURMD_NODENAME"
echo "sbatch: SLURM_JOB_NODELIST $SLURM_JOB_NODELIST"
echo "sbatch: SLURM_JOB_ACCOUNT $SLURM_JOB_ACCOUNT"

Rscript "$1"
wait
echo "sbatch: STOP"
