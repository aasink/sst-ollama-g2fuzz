for model in /bigtemp/qux3ac/sst/runs/*/; do
    for program in flvmeta jhead mp42aac; do
        modelname=$(basename $model)
        seeds="$model$program/seeds"
        if [ -d "$seeds" ]; then
            count=$(ls $seeds | wc -l)
            echo "$modelname,$program,$count"
        fi
    done
done