# blog.tiga.tech

[tig's Blog](https://blog.tiga.tech), powered by [Hugo](https://gohugo.io/) and [Blowfish](https://github.com/nunocoracao/blowfish).

## Shortcodes

| Shortcode                           | Description                                                                                     |
| ----------------------------------- | ----------------------------------------------------------------------------------------------- |
| [**`gallery_glob`**](#gallery_glob) | Builds a gallery from a glob pattern, and applies image optimisation and optional watermarking. |
| [**`img`**](#img)                   | Custom image shortcode that integrates with image optimisation and watermarking.                |
| [**`spoiler`**](#spoiler)           | Toggles visibility of content. Useful for hiding spoilers or long sections of text.             |

### `gallery_glob`

Build a gallery of statically-sized images (as opposed to [Blowfish's gallery shortcode](https://blowfish.page/docs/shortcodes/#gallery) where the size of each image is configurable) from a file path glob.

* Outputs a clean, consistent layout with an optional caption.
* Through usage of the included `img` partial (usage of `img` as a shortcode is documented below), this shortcode:
  * Supports image processing and optimisation.
  * Automatically applies watermarking unless disabled.

**Parameters:**
* `images` (required, str): Path glob (relative to current path) of images to include.
* `class` (required, str): Class to apply to all images (e.g. `grid-w50`, `grid-w50 md:grid-w33`, etc.). See [Blowfish's gallery shortcode docs](https://blowfish.page/docs/shortcodes/#gallery) for more info.
* `caption` (optional, str): Optional caption to display below the gallery. Supports markdown.

**Example:** `{{< gallery_glob images="images/*" class="image-classes" caption="My Gallery" >}}`

### `img`

Display an image with optional watermarking and image optimisation.

**Parameters:**
* `src` (required, str): The image path.
* `class` (optional, str): Custom CSS classes for styling the image.
* `alt` (optional, str): Alternative text for the image.
* `watermark` (optional, bool): Control whether watermarking is applied (default: true).

**Example:** `{{< img src="images/example.jpg" class="img-class" alt="Example image" watermark=false >}}`

### `spoiler`

Toggle visibility of content, useful for spoilers or collapsible sections.

**Parameters:**
* `title` (required, str): The title displayed for the toggle.
* `open` (optional, str): Whether the content is initially visible (default: false).

**Example:** `{{< spoiler title="Click to reveal spoiler" open=false >}}This is hidden content.{{< /spoiler >}}`


## Featured image watermarking in article lists

If [`list.cardView`](https://blowfish.page/docs/configuration/#list) is `false`, each post's featured image will be watermarked using the [process_list_featured_img](layouts/partials/process_list_featured_img.html) partial.

This can be disabled per-page with by setting the `hideFeatureWatermark` page parameter to `false`.

<details>
  <summary>Implementation detail</summary>

  This works by overriding Blowfish's [`layouts/partials/article-link/simple.html`](https://github.com/nunocoracao/blowfish/blob/main/layouts/partials/article-link/simple.html) and moving all featured image processing to my [`process_list_featured_img`](layouts/partials/process_list_featured_img.html) partial, which handles watermarking and conditional image optimisation.
</details>

## Using images in posts

> [!NOTE]
> When an image is passed through the [`watermark` partial](layouts/partials/watermark.html), it will be watermarked **unless** the image path/URL contains `watermark`.

| Method                                                                                     | Description                                    |
| ------------------------------------------------------------------------------------------ | ---------------------------------------------- |
| `<img> src="image-path" class="image classes" alt="alt text"`                              | Adds the image directly, skips all processing. |
| `![**alt** text](image-path)`                                                                  | Markdown syntax, image is processed according to site's image optimisation config and passed through `watermark` partial. |
| `{{< img src="image-path" class="image classes" alt="alt text" watermark=true\|false >}}`  | Custom shortcode, image is optimised and passed through `watermark` partial.<br>Images are optimised by means of Hugo's [`Resize`](https://gohugo.io/methods/resource/resize/) method and HTML's `img` tag `srcset` attribute. Default resize is `600x`.<br>Images are watermarked if `watermark` is not false (default true). |
| `{{< gallery >}} ... {{< /gallery >}}`                                                     | [Blowfish gallery shortcode](https://blowfish.page/docs/shortcodes/#gallery), images are processed based on method used to add include them.<br>See rows above for image inclusion methods. |
| `{{< gallery_glob images="path-glob" class="image classes" caption="optional caption" >}}` | Builds a gallery from a glob pattern.<br>Passes images through `img` shortcode and inheriting its features. |

## Personal Notes

* [Blowfish built-in shortcodes](https://blowfish.page/docs/shortcodes/).
* [Blowfish built-in icons](https://blowfish.page/samples/icons/).
* Post thumbnails are cropped to a 1.67:1 aspect ratio (e.g. 300x180) and anchored to centre to fit the bounding box on article list pages.

## Upgrading

1. Upgrade theme: `hugo mod get -u`
2. Check latest supported Hugo version at [nunocoracao/blowfish/config.toml](https://github.com/nunocoracao/blowfish/blob/main/config.toml) after selecting relevant tag.
3. If supported Hugo version is not latest:
  1. go to [Homebrew/homebrew-core/hugo.rb](https://github.com/Homebrew/homebrew-core/commits/master/Formula/h/hugo.rb) and copy the commit hash for the relevant version.
  2. Run `scripts/update_hugo.sh commit_hash_here`
4. Else `brew upgrade hugo`
5. Patch Hugo version in [.github/workflows/hugo.yml](.github/workflows/hugo.yml#L24)
