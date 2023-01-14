#!/usr/bin/env bash

set -euo pipefail

rc=$1

if [[ $rc -eq 0 ]]; then
  echo "No diff, no apply needed"
  echo "##vso[task.setvariable variable=result;isOutput=true]unchanged"
elif [[ $rc -eq 1 ]]; then
  echo "Error running plan"
  exit 1
elif [[ $rc -eq 2 ]]; then
  echo "Diff, apply needed"
  echo "##vso[task.setvariable variable=result;isOutput=true]changed"
else
  echo "Unexpected rc $rc - erroring"
  exit $rc
fi
