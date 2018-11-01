require "test-helper"

class TestMarkdownDiary < Test::Unit::TestCase
  def setup
    @diary = TDiary::Style::MarkdownDiary.new(Time.at( 1041346800 ), "TITLE", "")
  end

  class Append < self
    def setup
      super
      @source = <<-'EOF'
# subTitle
honbun

## subTitleH4
honbun

```
# comment in code block
```

      EOF
      @diary.append(@source)
    end

    def test_html
      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p>honbun</p>
<h4>subTitleH4</h4>
<p>honbun</p>
<pre class="highlight plaintext"><code># comment in code block
</code></pre>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end

    def test_source
      assert_equal(@source, @diary.to_src)
    end
  end

  class Replace < self
    def setup
      super
      source = <<-'EOF'
# subTitle
honbun

## subTitleH4
honbun

      EOF
      @diary.append(source)

      @replaced = <<-'EOF'
# replaceTitle
replace

## replaceTitleH4
replace

      EOF
    end

    def test_replace
      @diary.replace(Time.at( 1041346800 ), "TITLE", @replaced)
      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "replaceTitle" ) %></h3>
<p>replace</p>
<h4>replaceTitleH4</h4>
<p>replace</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end
  end

  def test_auto_link
    source = <<-EOF
# subTitle

 * http://www.google.com

[google](https://www.google.com)

http://www.google.com
      EOF
    @diary.append(source)
    @html = <<-EOF
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<ul>
<li><a href="http://www.google.com">http://www.google.com</a></li>
</ul>
<p><a href="https://www.google.com">google</a></p>
<p><a href="http://www.google.com">http://www.google.com</a></p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  def test_auto_image_link
    source = <<-EOF
# subTitle

![](http://www.google.com/logo.jpg)

![google](http://www.google.com/logo.jpg)
    EOF
    @diary.append(source)
    @html = <<-EOF
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><img src="http://www.google.com/logo.jpg" alt=""></p>
<p><img src="http://www.google.com/logo.jpg" alt="google"></p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  def test_html_link
    source = <<-EOF
# subTitle

<a href="http://www.exaple.com" target="_blank">Anchor</a>
    EOF
    @diary.append(source)
    @html = <<-EOF
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><a href="http://www.exaple.com" target="_blank">Anchor</a></p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  def test_url_syntax_with_code_blocks
    source = <<-'EOF'
# subTitle

```ruby
@foo
```

http://example.com is example.com

    EOF
    @diary.append(source)

    @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<pre class="highlight ruby"><code><span class="vi">@foo</span>
</code></pre>
<p><a href="http://example.com">http://example.com</a> is example.com</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  def test_ignore_url_syntax_with_markdown
    source = <<-'EOF'
# subTitle

[example](http://example.com) is example.com

    EOF
    @diary.append(source)

    @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><a href="http://example.com">example</a> is example.com</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  def test_plugin_syntax
    source = <<-'EOF'
# subTitle
{{plugin 'val'}}

{{plugin "val", 'val'}}

    EOF
    @diary.append(source)

    @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><%=plugin 'val'%></p>
<p><%=plugin "val", 'val'%></p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  def test_plugin_syntax_with_url_args
    source = <<-'EOF'
# subTitle
{{plugin 'http://www.example.com/foo.html', "https://www.example.com/bar.html"}}

    EOF
    @diary.append(source)

    @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><%=plugin 'http://www.example.com/foo.html', "https://www.example.com/bar.html"%></p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  def test_link_to_my_plugin
    source = <<-'EOF'
# subTitle

[](20120101p01)

[Link](20120101p01)

    EOF
    @diary.append(source)

    @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><%=my "20120101p01", "20120101p01" %></p>
<p><%=my "20120101p01", "Link" %></p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  def test_code_highlighting
    source = <<-'EOF'
# subTitle

```ruby
 def class
   @foo = 'bar'
 end
 ```
    EOF
    @diary.append(source)

    @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<pre class="highlight ruby"><code> <span class="k">def</span> <span class="nf">class</span>
   <span class="vi">@foo</span> <span class="o">=</span> <span class="s1">'bar'</span>
 <span class="k">end</span>
</code></pre>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  class TwitterUsername < self
    def test_plain
      source = <<-'EOF'
# subTitle

@a_matsuda is amatsuda
      EOF
      @diary.append(source)

      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p>@<a class="tweet-url username" href="https://twitter.com/a_matsuda" rel="nofollow">a_matsuda</a> is amatsuda</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end

    def test_twitter_username_with_pre
      source = <<-'EOF'
# subTitle

```ruby
p :some_code
```

@a_matsuda is amatsuda
      EOF
      @diary.append(source)

      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<pre class="highlight ruby"><code><span class="nb">p</span> <span class="ss">:some_code</span>
</code></pre>
<p>@<a class="tweet-url username" href="https://twitter.com/a_matsuda" rel="nofollow">a_matsuda</a> is amatsuda</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end

    def test_twitter_username_with_code
      source = <<-'EOF'
# subTitle

`:some_code`

@a_matsuda is amatsuda
      EOF
      @diary.append(source)

      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><code>:some_code</code></p>
<p>@<a class="tweet-url username" href="https://twitter.com/a_matsuda" rel="nofollow">a_matsuda</a> is amatsuda</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end

    def test_twitter_username_with_code_and_username
      source = <<-'EOF'
# subTitle

`:some_code` @a_matsuda is amatsuda
      EOF
      @diary.append(source)

      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><code>:some_code</code> @<a class="tweet-url username" href="https://twitter.com/a_matsuda" rel="nofollow">a_matsuda</a> is amatsuda</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end

    def test_twitter_username_with_code_and_username_without_space
      source = <<-'EOF'
# subTitle

`:some_code`@a_matsuda is amatsuda
      EOF
      @diary.append(source)

      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><code>:some_code</code>@a_matsuda is amatsuda</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end

    def test_twitter_username_with_code_tag
      source = <<-'EOF'
# subTitle

<code>@a_matsuda</code> is amatsuda
      EOF
      @diary.append(source)

      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><code>@a_matsuda</code> is amatsuda</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end

    def test_twitter_username_in_link_text
      source = <<-'EOF'
# subTitle

[@a_matsuda is amatsuda](https://example.com)
      EOF
      @diary.append(source)

      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><a href="https://example.com">@a_matsuda is amatsuda</a></p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end

    def test_twitter_username_in_sourcecode
      source = <<-'EOF'
# subTitle

```ruby
@a_matsuda = "amatsuda"
```
      EOF
      @diary.append(source)

      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<pre class="highlight ruby"><code><span class="vi">@a_matsuda</span> <span class="o">=</span> <span class="s2">"amatsuda"</span>
</code></pre>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end
  end

  class Emoji < self
    def test_in_plain_context
      source = <<-'EOF'
# subTitle

:sushi: は美味しい
				EOF
      @diary.append(source)

      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><img src='//www.webpagefx.com/tools/emoji-cheat-sheet/graphics/emojis/sushi.png' width='20' height='20' title='sushi' alt='sushi' class='emoji' /> は美味しい</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end

    def test_in_multiline
      source = <<-'EOF'
# subTitle

```
:sushi: は
美味しい
```
				EOF
      @diary.append(source)

      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<pre class="highlight plaintext"><code>:sushi: は
美味しい
</code></pre>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end

    def test_in_code
      source = <<-'EOF'
# subTitle

`:sushi:` は美味しい
      EOF
      @diary.append(source)

      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><code>:sushi:</code> は美味しい</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end

    def test_in_code_with_attribute
      source = <<-'EOF'
# subTitle

<code class="foo">:sushi:</code> は美味しい
      EOF
      @diary.append(source)

      @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p><code class="foo">:sushi:</code> は美味しい</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF
      assert_equal(@html, @diary.to_html)
    end
  end

  def test_stashes_in_pre_code_plugin
    source = <<-'EOF'
# subTitle

```
ruby -e "puts \"hello, world.\""
```

`ruby -e "puts \"hello, world.\""`

{{plugin "\0", "\1", "\2"}}
    EOF
    @diary.append(source)

    @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<pre class="highlight plaintext"><code>ruby -e "puts \"hello, world.\""
</code></pre>
<p><code>ruby -e &quot;puts \&quot;hello, world.\&quot;&quot;</code></p>
<p><%=plugin "\0", "\1", "\2"%></p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  def test_plugin_syntax_in_pre_code_block
    source = <<-'EOF'
# subTitle

Get IP Address of Docker Container:

```
% docker inspect -f "{{.NetworkSettings.IPAddress}}  {{.Config.Hostname}}  # Name:{{.Name}}" `docker ps -q`
```

NOTE: `{{.NetworkSettings.IPAddress}}` is golang template.
    EOF
    @diary.append(source)

    @html = <<-'EOF'
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p>Get IP Address of Docker Container:</p>
<pre class="highlight plaintext"><code>% docker inspect -f "{{.NetworkSettings.IPAddress}}  {{.Config.Hostname}}  # Name:{{.Name}}" `docker ps -q`
</code></pre>
<p>NOTE: <code>{{.NetworkSettings.IPAddress}}</code> is golang template.</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF
    assert_equal(@html, @diary.to_html)
  end

  def test_footnote
    pend("footnote is unsupported for now.")
    source = <<-'EOF'
# subTitle

Ruby{{fn "Object Oriented language"}} is fun!
HTML[^1] is a markup language[^2][^3].

[^1]: Hyper Text Markup Language
[^2]: [example](http://www.example.com)
[^3]: http://www.example.com

    EOF
    @diary.append(source)

    @html = <<-EOF
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "subTitle" ) %></h3>
<p>Ruby<%=fn "Object Oriented language"%> is fun!
HTML<%=fn %Q(Hyper Text Markup Language)%> is a markup language<%=fn %Q(<a href="http://www.example.com">example</a>)%><%=fn %Q(<a href="http://www.example.com">http://www.example.com</a>)%>.</p>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
    EOF

    assert_equal(@html, @diary.to_html)
  end

  class QiitaStyleCodeBlock < self
    def test_caption
      source = <<-EOF
# Code Blocks

```plaintext:example1.rb
p "OK"
```

~~~plaintext:example2.rb
p "OK"
~~~
      EOF
      @diary.append(source)

      @html = <<-EOF
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "Code Blocks" ) %></h3>
<pre class="highlight plaintext"><span class="caption">example1.rb</span>
<code>p "OK"
</code></pre>
<pre class="highlight plaintext"><span class="caption">example2.rb</span>
<code>p "OK"
</code></pre>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF

      assert_equal(@html, @diary.to_html)
    end

    def test_caption_with_tilde
      source = <<-EOF
# Code Blocks

```plaintext:~/example1.rb
p "OK"
```
      EOF
      @diary.append(source)
      # note: tilde after three-tilde code fence is not supported by cmark...

      @html = <<-EOF
<div class="section">
<%=section_enter_proc( Time.at( 1041346800 ) )%>
<h3><%= subtitle_proc( Time.at( 1041346800 ), "Code Blocks" ) %></h3>
<pre class="highlight plaintext"><span class="caption">~/example1.rb</span>
<code>p "OK"
</code></pre>
<%=section_leave_proc( Time.at( 1041346800 ) )%>
</div>
      EOF

      assert_equal(@html, @diary.to_html)
    end
  end
end
