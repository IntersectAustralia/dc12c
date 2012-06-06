module RSpec::Matchers

  class FieldDisplayMatcher
    def initialize(value, field_id)
      @field_id = field_id
      @value = value
    end
    def matches?(actual)
      @actual = '<not found>'
      if @value
        if actual
          @actual = actual.text
          @value == actual.text
        else
          false
        end
      else
        @actual = actual.text if actual
        actual 
      end
    end

    def failure_message
      "expected '#{@value}' but got '#{@actual}' in '#{@field_id}'"
    end

    def negative_failure_message
      "expected something else but got '#{@actual}' in '#{@field_id}'"
    end
  end

  def display_a(value, field_id)
    FieldDisplayMatcher.new(value, field_id)
  end

  def be_displayed(field_id)
    FieldDisplayMatcher.new(nil, field_id)
  end

end
