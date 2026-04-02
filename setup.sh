#!/bin/bash

# Load required modules
ml gcc
ml python
ml miniforge
ml llvm/16.0.6
ml clang/15.0.5
ml cmake

# Ollama environment (use project-local paths instead of personal ones)
export OLLAMA_INSTALL_DIR="$PWD/ollama"
export OLLAMA_MODELS="$OLLAMA_INSTALL_DIR/models"
export PATH="$OLLAMA_INSTALL_DIR/bin:$PATH"

# Activate conda environment
conda activate sst
