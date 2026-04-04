#!/bin/bash
#SBATCH --gres=gpu:1
#SBATCH --constraint="rtx_6000"
#SBATCH --mem=16000
#SBATCH -n 3
#SBATCH -t 01:00:00
#SBATCH -p gpu

module purge
source /path/to/your/setup.sh

cd /path/to/your/project

# Set model and run name here
MODEL="gpt-3.5-turbo"
RUN_NAME="gpt35"

# Create output directories
mkdir -p ./runs/$RUN_NAME/jhead/output
mkdir -p ./runs/$RUN_NAME/flvmeta/output
mkdir -p ./runs/$RUN_NAME/mp42aac/output

# Generate seeds in parallel
python ./G2FUZZ/program_gen.py --output ./runs/$RUN_NAME/jhead/output --program jhead &
python ./G2FUZZ/program_gen.py --output ./runs/$RUN_NAME/flvmeta/output --program flvmeta &
python ./G2FUZZ/program_gen.py --output ./runs/$RUN_NAME/mp42aac/output --program mp42aac &

wait
