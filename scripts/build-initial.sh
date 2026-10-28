#!/bin/sh
# Reproduce the original image without changing the hardened working tree.
set -eu
task_stage1_dir=$(mktemp -d)
trap 'rm -rf "$task_stage1_dir"' EXIT HUP INT TERM
for task_source in Dockerfile requirements.txt app.py .dockerignore; do
  git show "545a3b6:backend/$task_source" > "$task_stage1_dir/$task_source"
done
docker build -t fest-backend:0.1 "$task_stage1_dir"
docker image ls fest-backend:0.1
