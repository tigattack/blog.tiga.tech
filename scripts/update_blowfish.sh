#!/usr/bin/env bash -e

# Get current Blowfish version
blowfish_ver=$(cat go.mod | grep 'github.com/nunocoracao/blowfish/v2' | gsed -e 's/.*blowfish\/v2\s*//' -e 's/\s\/.*//')

# Update Blowfish theme (and any other go modules)
echo "Current Blowfish version: $blowfish_ver"
echo "Updating Blowfish..."
hugo mod get -u

# Get updated Blowfish version
blowfish_ver=$(cat go.mod | grep 'github.com/nunocoracao/blowfish/v2' | gsed -e 's/.*blowfish\/v2\s*//' -e 's/\s\/.*//')

echo "Updated Blowfish to $blowfish_ver"

# Stage and commit if there are changes
git add go.mod go.sum
if ! git diff --cached --quiet; then
    git commit -m "chore: bump blowfish to $blowfish_ver"
    echo "Committed blowfish update"
else
    echo "No changes to commit (already up to date)"
fi

# Get Blowfish's supported Hugo version
echo "Checking Hugo supported, installed, and available versions..."
blowfish_supported_hugo_ver=$(curl -s "https://raw.githubusercontent.com/nunocoracao/blowfish/refs/tags/${blowfish_ver}/release-versions/hugo-latest.txt" | gsed 's/v//')
installed_hugo_ver=$(hugo version 2>/dev/null | gsed -e 's/hugo v//' -e 's/[-+].*//' -e 's/\s.*//' || echo "none")

# Install or update Hugo to match Blowfish's supported version if needed
if [[ $blowfish_supported_hugo_ver != $installed_hugo_ver ]]; then
    echo "Installing Hugo version $blowfish_supported_hugo_ver (currently installed: $installed_hugo_ver)..."
    scripts/install_hugo.sh "$blowfish_supported_hugo_ver"
else
    echo "Validated Hugo is up to date with the latest supported version in Blowfish."
fi

# Get build workflow's Hugo version and test if it matches Blowfish's latest supported version of Hugo
build_workflow_hugo_ver=$(grep 'HUGO_VERSION:' .github/workflows/hugo.yml | gsed 's/.*: //')

if [[ $blowfish_supported_hugo_ver != $build_workflow_hugo_ver ]]; then
    gsed -i .github/workflows/hugo.yml -e "s/$build_workflow_hugo_ver/$blowfish_supported_hugo_ver/"
    echo "Updated Hugo version in build workflow."
    # Stage and commit
    git add .github/workflows/hugo.yml
    if ! git diff --cached --quiet; then
        git commit -m "ci: bump hugo to $blowfish_supported_hugo_ver"
        echo "Committed Hugo update in site build workflow"
    fi
else
    echo "Validated Hugo version in build workflow is up to date with the latest supported version in Blowfish."
fi
