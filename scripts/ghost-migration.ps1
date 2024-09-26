<#
This is incredibly messy and hacked together.
It served a purpose and I didn't want to lose it, so here it is.
#>

param(
  [Parameter(ParameterSetName = 'Migrate')]
  [switch]$Migrate,
  [Parameter(ParameterSetName = 'Convert')]
  [switch]$Convert
)

Function migrate {
  $site = "https://blog.tiga.tech"
  $api = $site + '/ghost/api/content'
  $key = ''

  $api_posts = $api + '/posts'

  $params = @{
    Body        = @{ key = $key ; include = 'tags' }
    Headers     = @{ 'Accept-Version' = 'v5.0' }
    Method      = 'Get'
    ContentType = 'application/x-www-form-urlencoded'
    ErrorAction = 'Stop'
  }

  Write-Output 'Retrieving posts...'

  $posts = (Invoke-RestMethod -Uri $api_posts @params).posts

  Write-Output 'Retrieved posts.'

  foreach ($post in $posts) {

    Write-Output "`nProcessing post: $($post.title)`n"

    $tags = ''
    foreach ($tag in $post.tags) {
      if ($tag.slug -eq 'tech-homelab') {
        $tags += '"technology"'
      }
      else {
        $tags += "`"$($tag.slug)`""
      }
    }

    $primary_tag = if ($post.primary_tag.slug -eq 'tech-homelab') {'technology'} else {$post.primary_tag.slug}

    $excerpt = if ($post.custom_excerpt) {
      $post.custom_excerpt.Replace("`n", ' ').Replace('   ', ' ').Replace('"', '\"')
    } else {''}

    If ($post.feature_image) {
      $ext = [System.IO.Path]::GetExtension($post.feature_image)
      $head_img = 'header' + $ext
    }
    Else { $head_img = '' }

    $header = @"
+++
draft = false
date = $(Get-Date $post.created_at -UFormat '+%Y-%m-%dT%H:%M:%S%Z:00')
title = "$($post.title)"
description = "$excerpt"
featuredImage = "$head_img"
slug = "$($post.slug)"
authors = ["tigattack"]
tags = [$($tags.Replace('""', '", "'))]
categories = ["$primary_tag"]
series = []
+++
"@

    $html = $post.html -replace "<!--kg-card-(begin|end): markdown-->", ''

    $content = $header + "`n`n" + $html

    $dir = New-Item (
      Join-Path "$PSScriptRoot" '/content/posts/' | Join-Path -ChildPath $post.slug
    ) -Type Directory -Force

    $file = New-Item (
      Join-Path -Path $dir -ChildPath "index.html"
    ) -Type File -Force

    Set-Content -Path $file -Value $content -Force

    If ($head_img.Length -gt 0) {
      Invoke-WebRequest -Uri "$($post.feature_image)" -OutFile (Join-Path -Path $dir -ChildPath $head_img)
    }

    Write-Output "Processed post.`n"
  }
}

Function convert {
  $regex = '^(\+{3}(.|\n)*?\+{3}\n)((.|\n)*)$'

  $htmlPosts = Get-ChildItem -Path $PSScriptRoot/content/posts/* -Include index.html -Recurse -File

  Write-Output "Found $($htmlPosts.Count) HTML posts to convert to Markdown."

  foreach ($post in $htmlPosts) {

    $parentdir = $post.PSParentPath.Split('/') | Select-Object -Last 1
    Write-Output "`nConverting $parentdir/index.html ..."
    $content = Get-Content $post -Raw
    $header = ($content | Select-String -Pattern $regex).Matches.Groups[1].Value
    $body = ($content | Select-String -Pattern $regex).Matches.Groups[3].Value

    Set-Content -Path $post -Value ($header)

    Add-Content -Path $post -Value ($body | pandoc --from html+raw_html --to markdown_strict)

    Rename-Item -Path $post -NewName "$([System.IO.Path]::GetFileNameWithoutExtension($post)).md"

    Write-Output "Converted.`n"
  }
}

If ($Migrate) { migrate }
Elseif ($Convert) { convert }
Else { Write-Output 'Please specify -Migrate or -Convert' }


# Slightly buggy code used to pull all referenced images and put them in the right place
# Wrapped in a function mostly so it won't be run by accident.

function images {
  # Find and download all images
  (grep -lo 'https://blog.tiga.tech/content/' ../*/index.md).Split("`n") | ForEach-Object {
    (grep '\"https://blog.tiga.tech/content/images/2' $_
    ).split("`n") | ForEach-Object {
      $url = $_.Split('"')[1]
      wget $url
    }
  }

  (grep -lo 'https://img.tiga.tech/' ../*/index.md).Split("`n") | ForEach-Object {
    (grep '\"https://img.tiga.tech/' $_
    ).split("`n") | ForEach-Object {
      $url = $_.Split('"')[1]
      wget $url
    }
  }

  # List all images, matched with the file they appear in
  Get-ChildItem . | ForEach-Object {
    $grep = grep -l $_.Name ../*/index.md

    "$($_.Name)`n$grep`n"
  }

  # Move images to the correct directory
  Get-ChildItem . | ForEach-Object {
    $grep = (grep -l $_.Name ../*/index.md).TrimEnd('index.md')

    Move-Item -Path $_ -Destination $grep -WhatIf
  }
}
