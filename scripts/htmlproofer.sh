#!/usr/bin/env bash -e

project_dir=$(pwd)
build_dir=$(mktemp -d)

hugo build --gc -d "${build_dir}"

default_args=(--typhoeus="{\"headers\":{\"User-Agent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:134.0) Gecko/20100101 Firefox/134.0\"}}" --cache='{"timeframe": {"external": "30d"}, "storage_dir": "/cache/.htmlproofer/"}')

docker run --rm -it \
  -v "${build_dir}:/src:ro" \
  -v "${project_dir}/tmp:/cache:rw" \
  parkr/html-proofer:latest \
  "${default_args[@]}" "$@"

rm -rf "${build_dir}"
