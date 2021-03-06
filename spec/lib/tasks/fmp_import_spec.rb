# coding: utf-8

rails_root = File.dirname(__FILE__) + '/../../..'
require "#{rails_root}/lib/tasks/fmp_import.rb"

require "#{rails_root}/db/seed_helper.rb"

require 'set'
require 'spec_helper'

describe "FMP import" do
  test_data_path = "#{rails_root}/spec/test_data"
  let (:filename){"#{test_data_path}/test.csv"}
  #let (:filename){"/home/devel/papyri.csv"}
  let (:image_root){"#{test_data_path}/images/"}
  let (:empty_root){"#{test_data_path}/images/empty"}
  before :each do
    create_languages
    create_genres
  end

  pending "works" do
    
    import_from_filemaker_pro filename, image_root
    
  end

  describe "candidate_images" do
    it "should return an empty hash for an empty directory" do
      candidate_images(empty_root).should eq [{}, []]
    end
    it "should return a hash keyed on inventory number to file paths" do
      x = ->(*filenames){filenames.map{|filename| File.expand_path("#{image_root}/#{filename}")}}
      mapped = {
        1 => {assigned: false, paths: x['inv001a.tif']},
        11 => {assigned: false, paths: x["inv011b.tif"]},
        11 => {assigned: false, paths: x['inv011b.tif']},
        111 => {assigned: false, paths: x['inv111aa.tif']},
        19 => {assigned: false, paths: x['inv019ABCa.tif']},
        433 => {assigned: false, paths: x['Inv433.tif']},
        584 => {assigned: false, paths: x['inv584_3a.tif']},
        587 => {assigned: false, paths: x['inv587_det.tif']},
        597 => {assigned: false, paths: x['597a.tif']},
        624 => {assigned: false, paths: x['inv624.tif']},
        632 => {assigned: false, paths: x['inv632_detail_a.tif']},
      }
      unmapped = x['last_extras_a.tif', 'last_extras_b.tif']
      actual_mapped, actual_unmapped = candidate_images(image_root)

      Hash[actual_mapped.sort].should eq Hash[mapped.sort]
      actual_unmapped.sort.should eq unmapped.sort
    end
  end

  describe "extract_inventory_id" do
    it "123.tif" do
      extract_inventory_id("123.tif").should eq 123
    end
    it "012.tif" do
      extract_inventory_id("012.tif").should eq 12
    end
    it "inv012.tif" do
      extract_inventory_id("inv012.tif").should eq 12
    end
    it "Inv044.tif" do
      extract_inventory_id("Inv044.tif").should eq 44
    end
    it "last_extras_a.tif" do
      extract_inventory_id("last_extras_a.tif").should eq nil
    end
    it "inv632_detail_a.tif" do
      extract_inventory_id("inv632_detail_a.tif").should eq 632
    end
    it "inv019ABCa.tif" do
      extract_inventory_id("inv019ABCa.tif").should eq 19
    end
    it "/some/p32ath/inv019ABCa.tif" do
      extract_inventory_id("/some/p32ath/inv019ABCa.tif").should eq 19
    end
  end
  describe "normalise_inventory_numbers" do
    it { normalise_inventory_numbers("Lead Inv. 123").should eq [123] }
    it { normalise_inventory_numbers("P. Oxy.X.1300 ").should eq [1300] }
    it "should not modify the original string" do
      str = 'p. macquarie inv. 3 '
      original = str.dup
      normalise_inventory_numbers(str)
      str.should eq original

    end
  end

  describe "normalise_dates" do
    [
      '', {},
      '800-999 AD', {date_from: 800, date_to: 999},
      '-199  –  -100-199  –  -100', {date_from: -199, date_to: -100},
      '6 lines', {},
      '-199  –  -100', {date_from: -199, date_to: -100},
      '100  – 299', {date_from: 100, date_to: 299},
    ].each_slice(2) do |input, expected|
      it "(#{input}).should eq #{expected}" do
        normalised_dates(input).should eq expected
      end
    end
  end
  
end
