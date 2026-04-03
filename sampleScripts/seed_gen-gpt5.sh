#!/bin/bash
#SBATCH --gres=gpu:1
#SBATCH --constraint="rtx_6000"
#SBATCH --mem=16000
#SBATCH -n 3
#SBATCH -t 01:00:00
#SBATCH -p gpu

module purge

# Move to project root (script lives in sst/scripts/)
cd "$PWD/.."

# Load environment setup
source "./setup.sh"

# Ensure output directories exist
mkdir -p ./runs/gpt5m/jhead/output
mkdir -p ./runs/gpt5m/flvmeta/output
mkdir -p ./runs/gpt5m/mp42aac/output

# Generate seeds for all 3 programs in parallel
python ./G2FUZZ/program_gen.py --output ./runs/gpt5m/jhead/output --program jhead &
python ./G2FUZZ/program_gen.py --output ./runs/gpt5m/flvmeta/output --program flvmeta &
python ./G2FUZZ/program_gen.py --output ./runs/gpt5m/mp42aac/output --program mp42aac &

wait
