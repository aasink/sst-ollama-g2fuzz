#!/bin/bash
#SBATCH --gres=gpu:1
#SBATCH --constraint="rtx_6000"
#SBATCH --mem=16000
#SBATCH -n 3
#SBATCH -t 04:30:00
#SBATCH -p gpu

module purge
source /path/to/your/setup.sh

cd /path/to/your/project

# Set model and run name here
MODEL="qwen2.5-coder:1.5b"
RUN_NAME="qwen1.5b"

# Start Ollama and save PID
ollama serve &
OLLAMA_PID=$!
sleep 15
ollama pull $MODEL

# Assemble seed corpus
mkdir -p ./runs/$RUN_NAME/jhead/seeds
mkdir -p ./runs/$RUN_NAME/flvmeta/seeds
mkdir -p ./runs/$RUN_NAME/mp42aac/seeds

cp -r ./runs/$RUN_NAME/jhead/output/default/gen_seeds/* ./runs/$RUN_NAME/jhead/seeds/
cp -r ./runs/$RUN_NAME/flvmeta/output/default/gen_seeds/* ./runs/$RUN_NAME/flvmeta/seeds/
cp -r ./runs/$RUN_NAME/mp42aac/output/default/gen_seeds/* ./runs/$RUN_NAME/mp42aac/seeds/

# Fuzz all 3 programs in parallel
AFL_SKIP_CPUFREQ=1 /path/to/G2FUZZ/afl-fuzz \
    -i ./runs/$RUN_NAME/jhead/seeds \
    -o ./runs/$RUN_NAME/jhead/output \
    -c ./targets/jhead.cmp \
    -m 4096 -k /path/to/G2FUZZ/ \
    -V 14400 \
    -- ./targets/jhead.afl @@ &

AFL_SKIP_CPUFREQ=1 /path/to/G2FUZZ/afl-fuzz \
    -i ./runs/$RUN_NAME/flvmeta/seeds \
    -o ./runs/$RUN_NAME/flvmeta/output \
    -c ./targets/flvmeta.cmp \
    -m 4096 -k /path/to/G2FUZZ/ \
    -V 14400 \
    -- ./targets/flvmeta.afl @@ &

AFL_SKIP_CPUFREQ=1 /path/to/G2FUZZ/afl-fuzz \
    -i ./runs/$RUN_NAME/mp42aac/seeds \
    -o ./runs/$RUN_NAME/mp42aac/output \
    -c ./targets/mp42aac.cmp \
    -m 4096 -k /path/to/G2FUZZ/ \
    -V 14400 \
    -- ./targets/mp42aac.afl @@ &

wait

# Kill ollama
kill $OLLAMA_PID