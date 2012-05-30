class TrismegistosController < ApplicationController
  def download
    send_data Trismegistos.csv, filename: 'trismegistos.csv'
  end
end
