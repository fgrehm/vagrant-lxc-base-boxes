#!/bin/bash

export NO_COLOR='\033[0m'
export OK_COLOR='\033[32;01m'
export ERROR_COLOR='\033[31;01m'
export WARN_COLOR='\033[33;01m'

log() {
  LOG_PREFIX="${DISTRIBUTION}-${RELEASE}"
  echo "    [${LOG_PREFIX}] ${1}" >>${LOG}
  echo "    [${LOG_PREFIX}] ${1}" >&2
}

warn() {
  LOG_PREFIX="${DISTRIBUTION}-${RELEASE}"
  echo "==> [${LOG_PREFIX}] [WARN] ${1}" >>${LOG}
  echo -e "${WARN_COLOR}==> [${LOG_PREFIX}] ${1}${NO_COLOR}"
}

info() {
  LOG_PREFIX="${DISTRIBUTION}-${RELEASE}"
  echo "==> [${LOG_PREFIX}] [INFO] ${1}" >>${LOG}
  echo -e "${OK_COLOR}==> [${LOG_PREFIX}] ${1}${NO_COLOR}"
}

confirm() {
  LOG_PREFIX="${DISTRIBUTION}-${RELEASE}"
  question=${1}
  default=${2}
  default_prompt=

  if [ $default = 'n' ]; then
    default_prompt="y/N"
    default='No'
  else
    default_prompt="Y/n"
    default='Yes'
  fi

  echo -e -n "${WARN_COLOR}==> [${LOG_PREFIX}] ${question} [${default_prompt}] ${NO_COLOR}" >&2
  read answer

  if [ -z $answer ]; then
    debug "Answer not provided, assuming '${default}'"
    answer=${default}
  fi

  if $(echo ${answer} | grep -q -i '^y'); then
    return 0
  else
    return 1
  fi
}

debug() {
  LOG_PREFIX="${DISTRIBUTION}-${RELEASE}"
  [ ! $DEBUG ] || echo "    [${LOG_PREFIX}] [DEBUG] ${1}" >&2
}
