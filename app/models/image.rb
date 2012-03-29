class Image < ActiveRecord::Base
  IMAGE_ROOT = APP_CONFIG.fetch 'image_root'

  belongs_to :papyrus

  has_attached_file :image,
    url: '/papyrus/:papyrus_id/image/:id/:style/:filename',
    path: "#{IMAGE_ROOT}/:id-:style.:extension",
    styles: {
      low_res: {
        geometry: '450x300>',
        format: 'jpg'
      }
    }

  validates_attachment :image, presence: true, content_type: {content_type: ->(xtn){['image/gif', 'image/png', 'image/jpeg', 'image/tiff'].include?(xtn)}}, size: {in: (1..(200.megabytes)) }

  validates_presence_of :papyrus_id
  validates_presence_of :caption
end
