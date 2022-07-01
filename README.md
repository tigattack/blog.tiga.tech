# blog.tiga.tech

tig's Blog, powered by [Hugo](https://gohugo.io/) and a customised version of [Coder](https://github.com/luizdepra/hugo-coder/).

## PrismJS

[Download page for current selection](https://prismjs.com/download.html#themes=prism-tomorrow&languages=markup+css+clike+javascript+bash+diff+docker+hcl+json+json5+makefile+nginx+powershell+python+regex+systemd+toml+yaml&plugins=line-highlight+line-numbers+autolinker+command-line+normalize-whitespace+toolbar+copy-to-clipboard).

* Theme: Tomorrow Night
* Languages
    * Markup + HTML + XML + SVG + MathML + SSML + Atom + RSS
    * CSS
    * CLike
    * JavaScript
    * Bash
    * Diff
    * Docker
    * HCL
    * JSON/JSON5
    * Makefile
    * NGINX
    * PowerShell
    * Python
    * RegEx
    * Systemd
    * TOML
    * YAML
* Plugins
    * Line highlight
    * Line numbers
    * Autolinker (MD-syntax links within codeblocks)
    * Command line (not working, plugin compatibility issue?)
    * Normalise whitespace
    * Toolbar
    * Copy to clipboard button

Line numbers are enabled globally in `<theme>/layouts/_default/baseof.html`.

To disable line numbers for specific element:
```html
<pre class="no-line-numbers"><code>...</code></pre>
```

Custom changes have been made to [prism.css](static/css/prism.css), such as [unminify](https://unminify.com/) and some style changes.

## Shortcodes

Not installed but could be useful:

* <https://github.com/rvanhorn/hugo-dynamic-tabs>
* <https://github.com/statropy/github-button-hugo-shortcode>

### Table of contents

Add a ToC anywhere in a page with:

```text
{{< toc >}}
```

Source: <https://ruddra.com/hugo-add-toc-anywhere/>

### Notice boxes

Usage, where `TYPE` is one of `note`, `tip`, `example`, `question`, `info`, `warning`, `error`:

```text
{{< notice TYPE >}} This is a TYPE notice. {{< /notice >}}
```

Source: Part of Coder theme.

### Tab groups

```text
{{< tabgroup >}}
  {{< tab name="Hello" >}}
  Hello World!
  {{< /tab >}}

  {{< tab name="Goodbye" >}}
  Goodbye World!
  {{< /tab >}}
{{< /tabgroup >}}
```

Source: Part of Coder theme.

### GitHub cards

Parameters:
* `size`: One of `small`, `medium`, `large`.
* `repo`: `username/repo-name`
* `image`: Image URL to use as the banner. Optional, will use user avatar if not specified. If set to `opengraph`, an OpenGraph card for the repository will be used for the image.

Parameters can be named or positional, in the order listed above.

```text
{{< gh-card large "tigattack/VeeamNotify" "opengraph" >}}
{{< gh-card size=large repo="tigattack/VeeamNotify" image="opengraph" >}}
{{< gh-card size=large repo="tigattack/VeeamNotify" image="https://some.url.to/banner.png" >}}
```

Source: <https://codepen.io/aranscope/pen/RZazrK> (Shortcode is self-created).

### Image gallery

Usage:

```html
<figure>
  {{< gallery match="DIR/*" sortOrder="asc" rowHeight="250" margins="5" thumbnailResizeOptions="600x600 q90 Lanczos" showExif=false previewType="blur" embedPreview="true" loadJQuery=true >}}
  <figcaption>Gallery caption.</figcaption>
</figure>
```

Source: <https://github.com/mfg92/hugo-shortcode-gallery>

### Spoiler

Usage:

``html
{{< spoiler "Optional spoiler title" >}}
Spoiler content
{{< /spoiler >}}
```
