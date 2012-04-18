module ApplicationHelper

  class SecuredRenderer
    def initialize(helper_module, papyrus, user)
      @helper_module = helper_module
      @papyrus = papyrus
      @ability = Ability.new(user)
    end
    def render(label, field_name)
      if Papyrus.basic_field(field_name) ||
        (Papyrus.detailed_field(field_name) && @ability.can?(:read_detailed_field, @papyrus)) ||
        (Papyrus.full_field(field_name) && (@ability.can?(:read_full_field, @papyrus)))
        @helper_module.render_field(label, @papyrus.send(field_name))
      end
    end
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  #shorthand for the required asterisk
  def required
    "<a class='asterisk_icon' title='Required'></a>".html_safe
  end

  # convenience method to render a field on a view screen - saves repeating the div/span etc each time
  def render_field(label, value)
    render_field_content(label, (h value))
  end

  def render_field_if_not_empty(label, value)
    render_field_content(label, (h value)) if value != nil && !value.empty?
  end

  # as above but takes a block for the field value
  def render_field_with_block(label, &block)
    content = with_output_buffer(&block)
    render_field_content(label, content)
  end

  def with_renderer_for(papyrus, current_user, &block)
    renderer = SecuredRenderer.new(self, papyrus, current_user)
    block.call(renderer)
  end

  private
  def render_field_content(label, content)
    div_class = cycle("field_bg","field_nobg")
    div_id = label.tr(" ,.", "_").downcase
    html = "<div class='#{div_class} control-group' id='display_#{div_id}'>"
    html << '<label class="control-label">'
    html << (h label)
    html << ":"
    html << '</label>'
    html << '<div class="controls">'
    html << content
    html << '</div>'
    html << '</div>'
    html.html_safe
  end


end
