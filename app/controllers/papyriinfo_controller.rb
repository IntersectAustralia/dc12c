class PapyriinfoController < ApplicationController
  def download_zip
    Papyriinfo.with_zip do |zip|
      send_data File.read(zip), filename: 'macquarie_papyri.zip', type: 'application/zip'
    end
  end
end
