#!/bin/bash
#SBATCH --gres=gpu:1
#SBATCH --constraint="rtx_6000"
#SBATCH --mem=16000
#SBATCH -n 3
#SBATCH -t 04:30:00
#SBATCH -p gpu

module purge

# Move to project root (script is in sst/scripts/)
cd "$PWD/.."

# Load your environment setup
source "./setup.sh"

# Assemble seed corpus
mkdir -p ./runs/gpt35/jhead/seeds
mkdir -p ./runs/gpt35/flvmeta/seeds
mkdir -p ./runs/gpt35/mp42aac/seeds

cp -r ./runs/gpt35/jhead/output/default/gen_seeds/* ./runs/gpt35/jhead/seeds/
cp -r ./runs/gpt35/flvmeta/output/default/gen_seeds/* ./runs/gpt35/flvmeta/seeds/
cp -r ./runs/gpt35/mp42aac/output/default/gen_seeds/* ./runs/gpt35/mp42aac/seeds/

# Fuzz all 3 programs in parallel
AFL_SKIP_CPUFREQ=1 ./G2FUZZ/afl-fuzz \
    -i ./runs/gpt35/jhead/seeds \
    -o ./runs/gpt35/jhead/output \
    -c ./targets/jhead.cmp \
    -m 4096 -k ./G2FUZZ \
    -V 14400 \
    -- ./targets/jhead.afl @@ &

AFL_SKIP_CPUFREQ=1 ./G2FUZZ/afl-fuzz \
    -i ./runs/gpt35/flvmeta/seeds \
    -o ./runs/gpt35/flvmeta/output \
    -c ./targets/flvmeta.cmp \
    -m 4096 -k ./G2FUZZ \
    -V 14400 \
    -- ./targets/flvmeta.afl @@ &

AFL_SKIP_CPUFREQ=1 ./G2FUZZ/afl-fuzz \
    -i ./runs/gpt35/mp42aac/seeds \
    -o ./runs/gpt35/mp42aac/output \
    -c ./targets/mp42aac.cmp \
    -m 4096 -k ./G2FUZZ \
    -V 14400 \
    -- ./targets/mp42aac.afl @@ &

wait
