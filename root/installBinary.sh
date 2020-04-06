#!/bin/bash

. /plex-common.sh

case ${TARGETPLATFORM} in
  "linux/386") export PLEX_BUILD=linux-x86 ;;
  "linux/arm64") export PLEX_BUILD=linux-aarch64 ;;
  "linux/arm/v7") export PLEX_BUILD=linux-armv7hf_neon ;;
  *) export PLEX_BUILD=linux-x86_64 ;;
esac

echo "${TAG}" > /version.txt
echo "${PLEX_BUILD}" > /plex-build.txt
echo "${PLEX_DISTRO}" > /plex-distro.txt
if [ ! -z "${URL}" ]; then
  echo "Attempting to install from URL: ${URL}"
  installFromRawUrl "${URL}"
elif [ "${TAG}" != "beta" ] && [ "${TAG}" != "public" ]; then
  getVersionInfo "${TAG}" "" remoteVersion remoteFile

  if [ -z "${remoteVersion}" ] || [ -z "${remoteFile}" ]; then
    echo "Could not get install version"
    exit 1
  fi

  echo "Attempting to install: ${remoteVersion}"
  installFromUrl "${remoteFile}"
fi
