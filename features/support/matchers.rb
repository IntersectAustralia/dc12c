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
RSpec::Matchers.define(:be_same_file_as) do |expected_file_path|
  match do |actual_file_path|
    md5_hash(actual_file_path).should == md5_hash(expected_file_path)
  end

  def md5_hash(file_path)
    contents = File.read(file_path)
    #normalise line endings:
    contents.gsub! /\r\n?/, "\n"
    Digest::MD5.hexdigest(contents)
  end
end

