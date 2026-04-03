#!/bin/bash
# Validity rate checker for G2Fuzz generated seeds
# Usage: ./check_validity.sh <seeds_dir> <target_binary>

SEEDS_DIR=$1
TARGET=$2

if [ -z "$SEEDS_DIR" ] || [ -z "$TARGET" ]; then
    echo "Usage: $0 <seeds_dir> <target_binary>"
    exit 1
fi

valid=0
total=0

for seed in "$SEEDS_DIR"/*; do
    total=$((total + 1))
    if "$TARGET" "$seed" > /dev/null 2>&1; then
        valid=$((valid + 1))
    fi
done

echo "Valid: $valid / $total"
echo "Validity rate: $(echo "scale=2; $valid * 100 / $total" | bc)%"