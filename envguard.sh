#!/usr/bin/env bash

set -Eeo pipefail

optionSeparator="|"
isSecretOption="s"

readarray -t variables < <(grep -v '^#' environment.variables 2>/dev/null)

for value in ${variables[@]};
do
    environmentVariableName=${value%"${optionSeparator}${isSecretOption}"}
    optionsForEnvironmentVariable=${value#"$environmentVariableName${optionSeparator}"}

    if test -z "${!environmentVariableName}"
    then
          echo "${environmentVariableName} is empty. Terminating."
          exit 1
    else
        if [[ ${optionsForEnvironmentVariable} == *"${isSecretOption}"* ]]; then
            secretLength=$(printf "%s" "${!environmentVariableName}" | wc -c)
            secretMask=$(printf '%*s' ${secretLength} | tr ' ' '*')

            echo "${environmentVariableName} value is : ${secretMask}"
        else
            echo "${environmentVariableName} value is : ${!environmentVariableName}"
        fi
    fi
done