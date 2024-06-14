# blog.tiga.tech

[tig's Blog](https://blog.tiga.tech), powered by [Hugo](https://gohugo.io/) and [Blowfish](https://github.com/nunocoracao/blowfish).

## Shortcodes

Not installed but could be useful:

* <https://github.com/rvanhorn/hugo-dynamic-tabs>
* <https://github.com/statropy/github-button-hugo-shortcode>

### Spoiler

Parameters:
- `title`: The spoiler title/summary.
- `open`: Whether the spoiler will default-open or not. One of `true` or `false`. If this parameter is omitted, it will default closed.

Usage:

``html
{{< spoiler "Optional spoiler title" [true|false] >}}
Spoiler content **here**
{{< /spoiler >}}
```

``html
{{< spoiler title="Optional spoiler title" open=true >}}
Spoiler content **here**
{{< /spoiler >}}
```

## Notes

* Post thumbnails should be 1.67:1 aspect ratio (e.g. 300x180) to correctly fit the bounding box on the posts page.
