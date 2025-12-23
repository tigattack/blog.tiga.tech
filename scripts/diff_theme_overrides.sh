#!/usr/bin/env bash -e

modifiedfiles=(
  "layouts/partials/article-link/simple.html"
  "layouts/_default/_markup/render-image.html"
)

no_clean=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --no-clean)
      no_clean=true
      shift
      ;;
    *)
      # If a file is passed as an argument, use it instead of the default list
      if [ -n "$arg" ]; then
        modifiedfiles=("$arg")
      fi
      shift
      ;;
  esac
done

repopath="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P | xargs dirname )"

# Check for existing clone
existing_clone=$(find "$TMPDIR" -maxdepth 1 -type d -name "blowfish-theme-diff.*" 2>/dev/null | head -n 1)

if [ -n "$existing_clone" ] && [ -d "$existing_clone/.git" ]; then
  echo "Found existing clone at: $existing_clone"
  clonepath="$existing_clone"
else
  clonepath=$(mktemp -d -t blowfish-theme-diff)
  echo "Clone path: $clonepath"
  git clone git@github.com:nunocoracao/blowfish "$clonepath" --depth 1
fi

cd "$clonepath"
git checkout $(git describe --tags "$(git rev-list --tags --max-count=1)") 2>/dev/null || echo "No tags found, using default branch"
cd "$repopath"

for file in ${modifiedfiles[@]}; do
  echo -e "\n--- DIFFING FILE: ${file}\n"
  git diff "${clonepath}/$file" "$file" || true
done

if [ "$no_clean" = false ]; then
  rm -rf "$clonepath"
else
  echo -e "\nSkipping cleanup. Clone path preserved at: $clonepath"
fi
