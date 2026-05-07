for model in /bigtemp/qux3ac/sst/runs/*/; do
    for program in flvmeta jhead mp42aac; do
        modelname=$(basename $model)
        seeds="$model$program/seeds"
        binary="/bigtemp/qux3ac/sst/targets/$program.afl"
        if [ -d "$seeds" ]; then
            result=$(bash /bigtemp/qux3ac/sst/scripts/check_validity.sh $seeds $binary)
            echo "$modelname,$program,$result"
        fi
    done
done