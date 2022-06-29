# blog.tiga.tech

tig's Blog, powered by [Hugo](https://gohugo.io/) and a customised version of [Coder](https://github.com/luizdepra/hugo-coder/).

## PrismJS

[Download page for current selection](https://prismjs.com/download.html#themes=prism-twilight&languages=markup+css+clike+javascript+bash+diff+docker+hcl+json+json5+nginx+powershell+python+regex+yaml&plugins=line-highlight+line-numbers+autolinker+highlight-keywords+command-line+toolbar+copy-to-clipboard).

Line numbers are enabled globally in `<theme>/layouts/_default/baseof.html`.

To disable line numbers for specific element:
```html
<pre class="no-line-numbers"><code>...</code></pre>
```

Custom changes have been made to [prism.css](static/css/prism.css).

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

Usage, where `TYPE` is one of `note`, `type`, `example`, `question`, `info`, `warning`, `error`:

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
