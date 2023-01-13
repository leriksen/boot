#!/usr/bin/env bash
# requires bash5, which is default on MS-hosted ubuntu build agents

set -euo pipefail

function parseCLIArgs() {
  local -n args="${1}"

  shift

  while getopts "t:s:c:o:" arg; do
    case "${arg}" in
    t) args[tenancy]="${OPTARG}"      ;;
    s) args[subscription]="${OPTARG}" ;;
    c) args[client]="${OPTARG}"       ;;
    o) args[filename]="${OPTARG}"     ;;
    *) usage && exit 1                ;;
    esac
  done
}

function argSanity() {
  local -nr args="${1}"

  if [[ ${#SP_SECRET} -eq 0 ]]; then
    echo "need to set the service principal secret id envvar SP_SECRET"
    usage
    exit 1
  elif [[ ${#args[tenancy]} -eq 0 ]]; then
    echo "must specify -t tenant_id"
    usage
    exit 1
  elif [[ ${#args[subscription]}  -eq 0 ]]; then
    echo "must specify -s subscription"
    usage
    exit 1
  elif [[ ${#args[client]}  -eq 0 ]]; then
    echo "must specify -c client"
    usage
    exit 1
  elif [[ ${#args[filename]}  -eq 0 ]]; then
    echo "must specify -o filename to write block to"
    usage
    exit 1
  fi
}

function usage() {
  echo "Mandatory arguments - "
  echo "  -t <tenancy>      : tenancy_id to auth against"
  echo "  -s <subscription> : subscription_id to auth against"
  echo "  -c <client>       : client id of SP"
  echo "  -o <filename>     : filename to write block to"
  echo "Mandatory environment - "
  echo "  SP_SECRET    : client secret for SP auth to azurerm"
}

function write_azure_provider_block() {
  local -nr args="${1}"

  echo "writing details to ${args[filename]}"

# heredocs strips tabs, use spaces, format is important
  cat>"${args[filename]}" <<EOT
provider "azurerm" {
  tenant_id                  = "${args[tenancy]}"
  subscription_id            = "${args[subscription]}"
  client_id                  = "${args[client]}"
  client_secret              = "${SP_SECRET}"
  skip_provider_registration = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

provider "azuread" {}

EOT
}

declare -A arguments=()

echo "Before processing, CLI args are"
echo "${*}"

echo "parse CLI"
parseCLIArgs arguments "${@}"

echo "check argument sanity"
argSanity arguments

write_azure_provider_block arguments

exit 0
