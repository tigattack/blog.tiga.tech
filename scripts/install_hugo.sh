#!/usr/bin/env bash -e

if [ -z "$1" ]; then
    echo "No version specified, fetching latest..."
    version=$(gh release view --repo gohugoio/hugo --json tagName --jq '.tagName' | sed 's/^v//')
    if [ -z "$version" ]; then
        echo "Failed to fetch latest version"
        exit 1
    fi
    echo "Latest version is $version"
else
    version="$1"
fi

echo "Uninstalling existing Hugo..."
# Uninstall pkg-installed Hugo if present
if pkgutil --pkgs | grep -qi hugo; then
    sudo pkgutil --forget io.gohugo.hugo
fi
# Remove binary (works for both pkg and manual installs)
if which hugo &>/dev/null; then
    sudo rm -f "$(which hugo)"
fi

echo "Installing Hugo version $version"

# Check what asset format is available for this release
assets=$(gh release view "v${version}" --repo gohugoio/hugo --json assets --jq '.assets[].name')

temp_dir=$(mktemp -d)
trap "rm -rf $temp_dir" EXIT

if echo "$assets" | grep -q "hugo_extended_${version}_darwin-universal.pkg"; then
    # Newer releases use .pkg
    asset_name="hugo_extended_${version}_darwin-universal.pkg"
    file_ext="pkg"
elif echo "$assets" | grep -q "hugo_extended_${version}_darwin-universal.tar.gz"; then
    # Older releases use .tar.gz
    asset_name="hugo_extended_${version}_darwin-universal.tar.gz"
    file_ext="tar.gz"
else
    echo "Could not find darwin-universal asset (pkg or tar.gz) for version $version"
    exit 1
fi

download_url="https://github.com/gohugoio/hugo/releases/download/v${version}/${asset_name}"
echo "Downloading Hugo from $download_url"
curl -s -L -o "$temp_dir/hugo.${file_ext}" "$download_url"

if [ "$file_ext" = "pkg" ]; then
    echo "Installing pkg..."
    sudo installer -pkg "$temp_dir/hugo.pkg" -target /
else
    echo "Extracting..."
    tar -xzf "$temp_dir/hugo.tar.gz" -C "$temp_dir"
    echo "Installing to /usr/local/bin/hugo"
    sudo install -m 755 "$temp_dir/hugo" /usr/local/bin/hugo
fi

echo "Hugo $version installed successfully"
hugo version
