#!/usr/bin/env bash

set -Eeo pipefail

readarray -t variables < <(grep -v '^#' environment.variables 2>/dev/null)

for value in ${variables[@]};
do
    if test -z "${!value}"
    then
          echo "${value} is empty. Terminating."
          exit 1
    else
          echo "${value} value is : ${!value}"
    fi
done