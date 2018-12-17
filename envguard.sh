#!/usr/bin/env bash

set -Eeo pipefail

optionSeparator="|"
isSecretOption="s"
usage="Guarding your application ENV variables and fail fast if there is an unset env variable which is necessary for your application.

Usage: $(basename "$0") [OPTIONS] [COMMAND] --

OPTIONS:
    -h, --help          Print this help
    -s, --silent        Turn off env variable printout
"

# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
positional=()
while [[ $# -gt 0 ]]
do
case "$1" in
    -h|--help)
    echo "$usage"
    exit
    ;;
    -s|--silent)
    silent=1
    shift
    ;;
    *) # unknown option
    positional+=("$1") # save it in an array for later
    shift
    ;;
esac
done
set -- "${positional[@]}" # restore positional parameters

readarray -t variables < <(grep -v '^#' environment.variables 2>/dev/null)

for value in ${variables[@]};
do
    environmentVariableName=${value%"${optionSeparator}${isSecretOption}"}
    optionsForEnvironmentVariable=${value#"$environmentVariableName${optionSeparator}"}

    if test -z "${!environmentVariableName}"
    then
          if test -z "$silent"
          then
            echo "${environmentVariableName} is empty. Terminating."
          fi

          exit 1
    else
        if [[ ${optionsForEnvironmentVariable} == *"${isSecretOption}"* ]]; then
            if test -z "$silent"
            then
                secretLength=$(printf "%s" "${!environmentVariableName}" | wc -c)
                secretMask=$(printf '%*s' ${secretLength} | tr ' ' '*')
                echo "${environmentVariableName} value is : ${secretMask}"
            fi
        else
            if test -z "$silent"
            then
                echo "${environmentVariableName} value is : ${!environmentVariableName}"
            fi
        fi
    fi
done