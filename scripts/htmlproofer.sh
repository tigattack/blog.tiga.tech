#!/usr/bin/env bash -e

project_dir=$(pwd)
build_dir=$(mktemp -d)

hugo build --gc -d "${build_dir}"

default_args=(
  /src
  --ignore_missing_alt
  --ignore_status_codes 403
  --checks Links,Images,Scripts,Favicon,OpenGraph
  --typhoeus="{\"headers\":{\"User-Agent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:134.0) Gecko/20100101 Firefox/134.0\"}}"
  --cache='{"timeframe": {"external": "30d"}, "storage_dir": "/cache/.htmlproofer/"}'
  --swap_urls 'https\:\/\/blog.tiga.tech/:/'
)

docker run --rm \
  -v "${build_dir}:/src:ro" \
  -v "${project_dir}/tmp:/cache:rw" \
  parkr/html-proofer:5.0.9 \
  "${default_args[@]}" "$@"

rm -rf "${build_dir}"
