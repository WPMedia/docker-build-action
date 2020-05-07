#!/bin/sh
##############################################################
# entrypoint.sh
#
set -e

dockerfile=$1
context=$2
repository_url=$3
repository_name=$4
repository_user=$5
repository_password=$6
docker_tag=$7
docker_cache_tag=$8
docker_args=$9

usage() {
  echo "entrypoint.sh context repository_url repository_name repository_user repository_password docker_tag docker_cache_tag [dockerfile] [docker_args]"
  echo "  context"
  echo "  repository_url"
  echo "  repository_name"
  echo "  repository_user"
  echo "  repository_password"
  echo "  docker_tag"
  echo "  docker_cache_tag"
  echo "  dockerfile"
  echo "  docker_args"
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

test_param "context" "${context}"
test_param "repository_url" "${repository_url}"
test_param "repository_name" "${repository_name}"
test_param "repository_user" "${repository_user}"
test_param "repository_password" "${repository_password}"
test_param "docker_tag" "${docker_tag}"
test_param "docker_cache_tag" "${docker_cache_tag}"
# Optional: test_param "dockerfile" "${dockerfile}"
# Optional: test_param "docker_args" "${docker_args}"

# ------------ #

dockerfile_option=
if test "${dockerfile}" -ne ""; then
  dockerfile_option="-f ${dockerfile}"
fi

echo "## Login to ${repository_url}"
docker login -u="$repository_user" -p="$repository_password" ${repository_url}

docker_repo_tag=${repository_url}/${repository_name}:${docker_tag}
docker_repo_cache_tag=${repository_url}/${repository_name}:${docker_cache_tag}

echo "## Pull group image for cache"
docker pull ${docker_repo_cache_tag} || true

echo "## Docker Build"
docker build \
  --cache-from ${docker_repo_cache_tag} \
  --tag ${docker_repo_tag} \
  --tag ${docker_repo_cache_tag} \
  ${dockerfile_option} \
  ${context} \
  ${docker_args}

echo "## Push to Quay.io"
docker push ${docker_repo_tag}
docker push ${docker_repo_cache_tag}

echo "## Set Environment Variables"
echo "::set-env name=quayio_docker_tag::${docker_tag}"
echo "::set-env name=quayio_docker_image::${docker_repo_tag}"