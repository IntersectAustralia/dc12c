module Jekyll
  class DebugTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
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

      post = site.posts.find do |post|
        post.name =~ /\d{4}-\d{2}-\d{2}-#{@post_name}.md$/ # match the date at the beginning
      end

      if post
        "[#{@title}](#{base_path}#{post.url})"
      else
        "couldn't find post #{@post_name.inspect}"
      end
    end
  end
end

Liquid::Template.register_tag('my_debug', Jekyll::DebugTag)
Liquid::Template.register_tag('link_to_post', Jekyll::LinkToPostTag)
