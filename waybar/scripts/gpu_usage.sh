#!/bin/bash

# Query usage via nvidia-smi
usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n1)
# Fallback if blank:
if [ -z "$usage" ]; then
  usage=0
fi

# Output JSON for Waybar
echo "{\"text\": \"$usage%\", \"percentage\": $usage}"