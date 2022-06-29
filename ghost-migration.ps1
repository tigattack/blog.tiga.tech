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
