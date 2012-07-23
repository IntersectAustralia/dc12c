class Papyriinfo
  def self.with_zip &block
    saved_zip_file = Tempfile.new('some_zip_file')
    Zip::ZipOutputStream.open(saved_zip_file.path) do |zos|
      Papyrus.accessible_by(Ability.none).each do |p|
        zos.put_next_entry("macquarie.apis.#{p.id}.xml")
        zos << xml_data(p)
      end
    end

    block.call saved_zip_file
    saved_zip_file.close
    saved_zip_file.unlink
  end

  private

  def self.h(*args)
    ERB::Util.html_escape(*args)
  end

  def self.xml_data(papyrus)
    url_opts = ActionController::Base.default_url_options
    the_papyrus_url = Rails.application.routes.url_helpers.papyrus_url(papyrus, url_opts)
    papyrus = papyrus.anonymous_view

# "the_papyrus_url" and "papyrus" are used by the template. do not modify their names here without also modifying them in the ERB!

    ERB.new(File.read(Rails.root.join('app/views/papyri/papyri_info.xml.erb'))).result(binding)
  end
end
