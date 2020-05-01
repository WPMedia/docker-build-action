#!/bin/sh
##############################################################
# entrypoint.sh
#
set -e

packages=$1
directory=$2
token=$3
owner=$4
repository=$5

usage() {
  echo "entrypoint.sh packages directory token owner repository"
  echo "  packages - Github package list delimited by ' ' or '\\n'"
  echo "  directory - directory to install package"
  echo "  token - Github Access Token with permissions for Github Packages"
  echo "  owner - NPM Owner used in authentication"
  echo "  repository - NPM repository to authenticate"
}

test_param() {
  name=$1
  param=$2
  if test -z "${param}"; then
    echo "ERROR: Missing arg ${name}"
    usage
    exit 1
  fi
}

test_param "packages" "${packages}"
test_param "directory" "${directory}"
test_param "token" "${token}"
test_param "owner" "${owner}"
test_param "repository" "${repository}"

# ------------ #

install_directory=${GITHUB_WORKSPACE}/${directory}

GITHUB_PACKAGE_TOKEN=${token}
export GITHUB_PACKAGE_TOKEN

cd /tmp
npm config set "//${repository}/:_authToken" '${GITHUB_PACKAGE_TOKEN}'
npm config set "@${owner}:registry" "https://${repository}"

package_list=$(echo "${packages}" | tr '\n' ' ')

echo "## Installing npm packages '${package_list}'"
npm install ${package_list}

mkdir -p ${install_directory}
cp -R node_modules/* ${install_directory}
