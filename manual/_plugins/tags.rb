module Jekyll
  class MyTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @tag_name = tag_name
      @text = text
      @tokens = tokens
    end
    def render(context)
      <<-EOS
        #{@tag_name}
        #{@text}
        #{@tokens}
        #{context.methods.inspect}
        #{context.registers.inspect}
      EOS
    end
  end
  class LinkToPostTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
      @tag_name = tag_name
      @text = text
      @tokens = tokens
      args = text.split($-F, 2)
      raise "wrong number of args. expected [post, title], got #{args}" if args.length != 2
      @post_name, @title = args
    end
    def render(context)

      site = context.registers[:site]
      base_path = site.config['JB']['BASE_PATH']

      post = site.posts.find { |post| post.name =~ /#{@post_name}.md$/ }

      if post
        "[#{@title}](#{base_path}#{post.url})"
      else
        "couldn't find post #{@post_name.inspect}"
      end
    end
  end
end

Liquid::Template.register_tag('my_tag', Jekyll::MyTag)
Liquid::Template.register_tag('link_to_post', Jekyll::LinkToPostTag)
