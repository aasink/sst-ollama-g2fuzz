#!/bin/bash
echo "model,program,edges_found,bitmap_cvg,corpus_count,corpus_found,run_time,saved_crashes"

for stats in /bigtemp/qux3ac/sst/runs/*/*/output/default/fuzzer_stats; do
    # Extract model and program from path
    model=$(echo $stats | awk -F'/' '{print $(NF-4)}')
    program=$(echo $stats | awk -F'/' '{print $(NF-3)}')
    edges=$(grep "^edges_found" $stats | awk '{print $3}')
    coverage=$(grep "^bitmap_cvg" $stats | awk '{print $3}')
    corpus_count=$(grep "^corpus_count" $stats | awk '{print $3}')
    corpus_found=$(grep "^corpus_found" $stats | awk '{print $3}')
    run_time=$(grep "^run_time" $stats | awk '{print $3}')
    crashes=$(grep "^saved_crashes" $stats | awk '{print $3}')
    echo "$model,$program,$edges,$coverage,$corpus_count,$corpus_found,$run_time,$crashes"
done