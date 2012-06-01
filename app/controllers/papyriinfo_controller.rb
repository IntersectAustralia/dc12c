class PapyriinfoController < ApplicationController
  def download_zip
    send_data Trismegistos.csv, filename: 'trismegistos.csv'
  end
end
