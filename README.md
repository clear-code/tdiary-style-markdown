# TDiary::Style::Markdown

"Markdown" style for tDiary 2.x format.

This is based on tdiary-style-gfm gem.

## Installation

Add this line to your application's Gemfile:

    gem 'tdiary-style-markdown'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tdiary-style-markdown

## Usage

If you want to use this style, add @style into tdiary.conf below:

    @style = 'Markdown'

### Style sheet

Use [rouge](https://github.com/jneen/rouge) for syntax highlighting.

```text
$ rougify style github > public/github.css
```

Add `@import url("/github.css");` to your style sheet via tdiary
configuration.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

 * Copyright (C) 2003, TADA Tadashi <sho@spc.gr.jp>
 * Copyright (C) 2004, MoonWolf <moonwolf@moonwolf.com>
 * Copyright (C) 2012, kdmsnr <kdmsnr@gmail.com>
 * Copyright (C) 2013, hsbt <shibata.hiroshi@gmail.com>
 * Copyright (C) 2015, Kenji Okimoto <okimoto@clear-code.com>
