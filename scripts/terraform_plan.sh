#!/usr/bin/env bash

set -euo pipefail

# -detailed error code give 2 as rc if plan needs an apply
set +e
terraform plan -detailed-exitcode "${@}" -out tfplan.tfout
rc=$?
set -e

if [[ $rc -eq 0 ]]; then
  echo "No diff, no apply needed"
elif [[ $rc -eq 1 ]]; then
  echo "Error running plan"
  exit 1
elif [[ $rc -eq 2 ]]; then
  echo "Diff, apply needed"
else
  echo "Unexpected rc $rc - erroring"
  exit $rc
fi
