#!/usr/bin/env bash -e

modifiedfiles=(
  "layouts/partials/article-link/simple.html"
  "layouts/partials/vendor.html"
  "layouts/_default/_markup/render-image.html"
)

repopath="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P | xargs dirname )"
clonepath=$(mktemp -d)

git clone git@github.com:nunocoracao/blowfish "$clonepath"

cd "$clonepath"
git checkout $(git describe --tags "$(git rev-list --tags --max-count=1)")
cd "$repopath"

for file in ${modifiedfiles[@]}; do
  echo -e "\n--- DIFFING FILE: ${file}\n"
  git diff "${clonepath}/$file" "$file" || true
done

rm -rf "$clonepath"
