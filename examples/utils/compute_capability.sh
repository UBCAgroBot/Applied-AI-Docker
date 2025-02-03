#!/bin/bash

# Path to the compiled deviceQuery binary
DEVICE_QUERY_PATH="/usr/local/cuda/samples/1_Utilities/deviceQuery/deviceQuery"

# Check if deviceQuery binary exists
if [[ ! -f "$DEVICE_QUERY_PATH" ]]; then
    echo "Error: deviceQuery binary not found. Please make sure CUDA samples are installed and deviceQuery is compiled."
    exit 1
fi

# Run deviceQuery and filter output for compute capability
COMPUTE_CAPABILITY=$($DEVICE_QUERY_PATH | grep -i "compute capability" | awk '{print $4}')

# Check if compute capability was found
if [[ -z "$COMPUTE_CAPABILITY" ]]; then
    echo "Error: Unable to determine compute capability. Please ensure CUDA is properly installed and deviceQuery works."
    exit 1
fi

# Output compute capability
echo "GPU Compute Capability: $COMPUTE_CAPABILITY"
