require 'spec_helper'

describe Trismegistos do
  before :each do
    @expected_headers = %Q("Trismegistos nr","Publication","Inventory","Other inventory nrs","Material","Language/script","Provenance","Date","Note"\n)
  end
  describe "csv" do
    it "returns headers" do
      Trismegistos.csv.should eq @expected_headers
    end

    it "works" do
      spanish = FactoryGirl.create(:language, name: 'spanish')
      langs = [spanish.id]

      FactoryGirl.create(:papyrus, visibility: Papyrus::VISIBLE, trismegistos_id: 1, publications: 'pub', inventory_number: 'inv', mqt_number: 2, material: 'mat', language_ids: langs, origin_details: 'abc', date_from: -1, date_to: 1, summary: 'sum')
      FactoryGirl.create(:papyrus, visibility: Papyrus::VISIBLE, mqt_number: 3)

      Trismegistos.csv.should eq @expected_headers + %Q("1","pub","inv","MQT 2","mat","spanish","abc","1 BCE - 1 CE","sum"\n) + %Q("","","","MQT 3","","","","",""\n)
    end

    it "only shows public/visible records" do
      spanish = FactoryGirl.create(:language, name: 'spanish')
      langs = [spanish.id]

      FactoryGirl.create(:papyrus, visibility: Papyrus::VISIBLE, mqt_number: 3)
      FactoryGirl.create(:papyrus, visibility: Papyrus::HIDDEN, mqt_number: 2)
      FactoryGirl.create(:papyrus, visibility: Papyrus::PUBLIC, mqt_number: 1)

      Trismegistos.csv.should eq @expected_headers + [1,3].map{|i|mqt_only_row(i)}.join
    end

    it "orders by MQT" do
      spanish = FactoryGirl.create(:language, name: 'spanish')
      langs = [spanish.id]

      FactoryGirl.create(:papyrus, visibility: Papyrus::VISIBLE, mqt_number: 3)
      FactoryGirl.create(:papyrus, visibility: Papyrus::VISIBLE, mqt_number: 4)
      FactoryGirl.create(:papyrus, visibility: Papyrus::VISIBLE, mqt_number: 2)

      Trismegistos.csv.should eq @expected_headers + mqt_only_row(2) + mqt_only_row(3) + mqt_only_row(4)
    end
  end
end

def mqt_only_row(i)
  %Q("","","","MQT #{i}","","","","",""\n)
end
