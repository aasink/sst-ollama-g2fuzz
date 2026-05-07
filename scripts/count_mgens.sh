#!/bin/bash
echo "model,program,mutated_generators"
for model in /bigtemp/qux3ac/sst/runs/*/; do
    for program in flvmeta jhead mp42aac; do
        modelname=$(basename $model)
        mutlog="$model$program/output/default/mutation_log/relationship.json"
        if [ -f "$mutlog" ]; then
            count=$(python3 -c "
import json
with open('$mutlog') as f:
    data = json.load(f)
total = sum(len(v) for v in data.values())
print(total)
")
            echo "$modelname,$program,$count"
        fi
    done
done