#!/bin/bash
echo "model,program,generator_count"
for model in /bigtemp/qux3ac/sst/runs/*/; do
    for program in flvmeta jhead mp42aac; do
        modelname=$(basename $model)
        gendir="$model$program/output/default/generators"
        if [ -d "$gendir" ]; then
            count=$(ls $gendir/*.py 2>/dev/null | wc -l)
            echo "$modelname,$program,$count"
        fi
    done
done