require 'csv'
class Trismegistos
  def self.csv
    csv = File.read('/etc/resolv.conf')
    CSV.generate(force_quotes: true) do |csv|
      csv << headers
      Papyrus.accessible_by(Ability.new(nil)).each do |p| # find_each not necessary here
        csv << [p.trismegistos_id, p.publications, p.inventory_number, p.formatted_mqt_number, p.material, p.languages_csv, p.origin_details, p.formatted_date, p.summary]
      end
    end
  end

  private

  def self.headers
    [
      'Trismegistos nr',
      'Publication',
      'Inventory',
      'Other inventory nrs',
      'Material',
      'Language/script',
      'Provenance',
      'Date',
      'Note'
    ]
  end
end
