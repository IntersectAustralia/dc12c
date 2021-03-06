class Image < ActiveRecord::Base
  attr_accessible :image, :caption, :ordering
  IMAGE_ROOT = APP_CONFIG.fetch 'image_root'

  belongs_to :papyrus

  has_attached_file :image,
    url: '/papyrus/:papyrus_id/image/:id/:style',
    path: "#{IMAGE_ROOT}/:id-:style.:extension",
    styles: {
      low_res: {
        geometry: '450x300>',
        format: 'jpg'
      },
      thumbnail: {
        geometry: '100x80>',
        format: 'jpg'
      }
    }

  validates_attachment :image, presence: true, content_type: {content_type: ->(xtn){['image/gif', 'image/png', 'image/jpeg', 'image/tiff'].include?(xtn)}}, size: {in: (1..(200.megabytes)) }

  validates_presence_of :papyrus_id
  validates_presence_of :caption

  validates_length_of :caption, maximum: 255
  validates_length_of :ordering, maximum: 1

  validates_format_of :ordering, with: /[A-Z]/, allow_nil: true

  default_scope order: 'ordering'

  before_validation :upcase_ordering

  def high_res_filename
    "p.macq.#{id}.#{original_extension}"
  end

  def low_res_filename
    sanitized_caption = caption.downcase.gsub(/[^[a-z][0-9]]/, '').slice(0,50-"#{papyrus_id}--low.jpeg".length)
    "#{papyrus_id}-#{sanitized_caption}-low.jpeg"
  end

  private

  def original_extension
    dot_index = image_file_name.rindex('.') || -1
    first_extension_char_index = dot_index + 1
    image_file_name.slice (first_extension_char_index..-1)
  end

  def upcase_ordering
    if ordering
      self.ordering = ordering.to_s.upcase
    end
  end
end
