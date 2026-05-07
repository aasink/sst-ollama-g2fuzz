#!/bin/bash
echo "model,program,mutation_rounds,total_cost_time"
for model in /bigtemp/qux3ac/sst/runs/*/; do
    for program in flvmeta jhead mp42aac; do
        modelname=$(basename $model)
        logdir="$model$program/output/default/gen_seeds_energy_log"
        if [ -f "$logdir" ]; then
            rounds=$(grep "^cnt:" $logdir | wc -l)
            total_time=$(grep "^cost_time:" $logdir | awk -F: '{sum+=$2} END {print sum}')
            echo "$modelname,$program,$rounds,$total_time"
        fi
    done
done