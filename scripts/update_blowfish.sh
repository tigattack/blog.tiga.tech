#!/usr/bin/env bash -e

# Get current Blowfish version
blowfish_ver=$(cat go.mod | grep 'require github.com/nunocoracao/blowfish/v2' | gsed -e 's/.*blowfish\/v2\s*//' -e 's/\s\/.*//')

# Update Blowfish theme (and any other go modules)
echo "Current Blowfish version: $blowfish_ver"
echo "Updating Blowfish..."
hugo mod get -u

# Get updated Blowfish version
blowfish_ver=$(cat go.mod | grep 'require github.com/nunocoracao/blowfish/v2' | gsed -e 's/.*blowfish\/v2\s*//' -e 's/\s\/.*//')

echo "Updated Blowfish to $blowfish_ver"

# Stage and commit
git add go.mod go.sum
git commit -m "chore: bump blowfish to $blowfish_ver"
echo "Commited blowfish update"

# Get Blowfish's supported Hugo version
echo "Checking Hugo supported, installed, and available versions..."
blowfish_supported_hugo_ver=$(curl -s "https://raw.githubusercontent.com/nunocoracao/blowfish/refs/tags/${blowfish_ver}/release-versions/hugo-latest.txt" | gsed 's/v//')
installed_hugo_ver=$(hugo version | gsed -e 's/hugo v//' -e 's/\+extended.*\|\s.*//')

# Test if Blowfish's latest supported version of Hugo matches the installed version
if [[ $blowfish_supported_hugo_ver != $installed_hugo_ver ]]; then
    echo "Installed Hugo version ($installed_hugo_ver) does not match Blowfish's latest supported version ($blowfish_supported_hugo_ver). Checking latest Brew version..."
    brew_current_hugo_ver=$(brew info hugo | head -n1 | gsed -e 's/.*stable\s//' -e 's/\s(.*//')

    # Test if Blowfish's latest supported version of Hugo matches the version available from Brew
    if [[ $blowfish_supported_hugo_ver != $brew_current_hugo_ver ]]; then
        echo "Hugo version in Brew does not match Blowfish's supported Hugo version:"
        echo "Hugo version in Brew: $brew_current_hugo_ver"
        echo "Hugo version for Blowfish: $blowfish_supported_hugo_ver"
        echo
        echo "Find commit hash of required version from https://github.com/Homebrew/homebrew-core/commits/master/Formula/h/hugo.rb"
        echo "Then run scripts/update_hugo.sh <hash>"

    # Update Hugo if Blowfish's latest supported version of Hugo is available from Brew
    elif [[ $brew_current_hugo_ver != $installed_hugo_ver ]]; then
        echo "Updating Hugo..."
        HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade hugo
    fi
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
    git commit -m "ci: bump hugo to $blowfish_supported_hugo_ver"
    echo "Commited Hugo update in site build workflow"
else
    echo "Validated Hugo version in build workflow is up to date with the latest supported version in Blowfish."
fi
