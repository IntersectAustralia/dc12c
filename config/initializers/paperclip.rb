Paperclip.interpolates :papyrus_id do |attachment, style|
  attachment.instance.papyrus.id
end

Paperclip.interpolates :style_and_extension do |attachment, style|
  if style == :low_res
    "#{style}.jpg"
  else
    "#{style}.:extension"
  end
end
