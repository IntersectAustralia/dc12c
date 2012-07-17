# coding: UTF-8

require 'csv'

def import_from_filemaker_pro filename, image_root
  # TODO transactionally
  Papyrus.delete_all
  AccessRequest.delete_all
  Name.delete_all
  Connection.delete_all

  puts "importing from CSV: #{filename} image_root: #{image_root}"

  papyri_data = read_hashes_from_csv(filename)

  mapped_images, unmapped_images = candidate_images(image_root)

  needs_new_mqt_numbers = make_papyri_returning_those_needing_new_mqt_numbers(papyri_data, mapped_images)

  save_with_new_mqt_numbers(needs_new_mqt_numbers)

  stray_images = mapped_images.select{|inv_id, hsh| hsh[:assigned] == false}

  make_blank_records(unmapped_images, stray_images)
end

def make_blank_records(unmapped_images, stray_images)
  stray_images.each do |inferred_inventory_number, hsh|
    hsh[:paths].each do |filepath|
      make_new_papyrus_for_image_with_new_mqt_number(filepath, inventory_number: "guessing: #{inferred_inventory_number}", mqt_note: "couldn't find a matching FMP record for this image")
    end
  end
  unmapped_images.each do |filepath|
    make_new_papyrus_for_image_with_new_mqt_number(filepath, mqt_note: "couldn't find a match for this image")
  end
end
def make_new_papyrus_for_image_with_new_mqt_number(filepath, papyri_attrs)
  mqt_number = make_next_mqt_number
  p = Papyrus.create!(papyri_attrs.merge(mqt_number: mqt_number))
  create_image_for_papyrus(p, filepath)
end

def create_image_for_papyrus(p, filepath)
  image = p.images.build
  image.caption = File.basename(filepath)
  image.image = File.new(filepath)
  image.save!
end

def make_papyri_returning_those_needing_new_mqt_numbers(papyri_data, mapped_images)
  needs_new_mqt_numbers = []
  papyri_data.each do |hash|
    mqt_numbers, papyri_attrs, names, inventory_numbers = to_attrs(hash)
    if mqt_numbers.empty?
      needs_new_mqt_numbers << [papyri_attrs, names]
    else
      original_attrs = papyri_attrs
      papyri_attrs = papyri_attrs.dup
      mqt_numbers.each do |mqt_number|
        begin
          p = Papyrus.create!(papyri_attrs.merge(mqt_number: mqt_number))
          create_images_for_papyrus(p, inventory_numbers, mapped_images)
          names.each do |ordering, attrs|
            if attrs['name'].present?
              p.names.create!(attrs.merge(ordering: ordering))
            end
          end
        rescue ActiveRecord::RecordInvalid => e
          # if validation fails here, it is because of a duplicate MQT number (or possibly long strings)
          needs_new_mqt_numbers << [original_attrs, names, "original mqt_number: #{mqt_number}"]
        end
      end
    end
  end
  needs_new_mqt_numbers
end
def create_images_for_papyrus(papyrus, inventory_numbers, mapped_images)
  inventory_numbers.each do |inventory_number|
    hash = mapped_images[inventory_number]
    if hash
      hash[:paths].each do |path|
        create_image_for_papyrus(papyrus, path)
      end
      hash[:assigned] = true
    end
  end
end

def save_with_new_mqt_numbers(papyri_details)
  # make records for those that have no MQT number

  papyri_details.each do |papyri_attrs, names, additional_notes|
    mqt_number = make_next_mqt_number
    p = Papyrus.create!(papyri_attrs.merge(mqt_number: mqt_number))
    names.select{|name| name['name'].present?}.each do |ordering, name_attrs|
      name_attrs['role'] = name_attrs['role'].strip.upcase.tr('?','') if name_attrs['role']
      name_attrs['role'] = nil if name_attrs['role'] == ''
      loop do
        begin
          p.names.create!(name_attrs.merge(ordering: ordering))
          break
        rescue ActiveRecord::RecordInvalid => e
          puts e.inspect
          puts "WARN:  duplicate name #{name_attrs['name']}"
          name_attrs['name'] += '_2' # TODO increase this number each time instead of simply  appending _2 (but this will have no effect for the current database)
        end
      end
    end
  end
end

def make_next_mqt_number
  Papyrus.maximum(:mqt_number) + 1
end

def read_hashes_from_csv(file_name)
  csv_data = CSV.read(file_name, encoding: 'UTF-8')
  headers = csv_data.shift.map { |i| i.to_s }
  string_data = csv_data.map { |row| row.map { |cell| cell.to_s}}
  string_data.map { |row| Hash[*headers.zip(row).flatten] }
end

def candidate_images(directory_name)
  all_filenames = Dir.glob("#{directory_name}/**/*").map{|filename| File.expand_path(filename)}
  tifs = all_filenames.select{|filename| filename =~ /tif$/i }

  images = {}
  unrecognised = []
  tifs.each do |tif|
    inv_id = extract_inventory_id(tif)
    if inv_id.nil?
      unrecognised << tif
    else
      if !images.has_key?(inv_id)
        images[inv_id] = { assigned: false, paths: []}
      end
      images[inv_id][:paths] << tif
      images[inv_id][:paths].sort! # for easier testing
    end
  end
  puts "WARNING: unrecognised images: #{images[nil].join ', '}" if images.has_key? nil
  [images, unrecognised]
end

def extract_inventory_id(pathname)
  filename = pathname.split('/')[-1]
  if filename =~ /(inv)?(\d+).*\.tif/i
    $2.to_i
  end
end

def to_attrs(hash)
  normalised = {}
  names = {}
  ('a'..'j').each do |letter|
    names[letter] = {}
  end

  errors = []

  names['a']['added_information'] =  hash.delete "Added name information"
  names['b']['added_information'] =  hash.delete "Added name b information"
  names['c']['added_information'] =  hash.delete "Added name c information"
  names['d']['added_information'] =  hash.delete "Added name d information"
  names['e']['added_information'] =  hash.delete "Added name information name e"
  names['f']['added_information'] =  hash.delete "Added name information f"
  names['g']['added_information'] =  hash.delete "Added name g information"
  names['h']['added_information'] =  hash.delete "Added name h information"
  names['i']['added_information'] =  hash.delete "Added name i information"
  names['j']['added_information'] =  hash.delete "Added name j information"

  names['a']['date'] = hash.delete 'Dates assoc with name'
  names['b']['date'] = hash.delete 'Dates assoc with name b'
  names['c']['date'] = hash.delete 'Dates assoc with name c'
  names['d']['date'] = hash.delete 'Dates assoc with name d'
  names['e']['date'] = hash.delete 'Dates Associated with name e'
  names['f']['date'] = hash.delete 'Dates associated with name f'
  names['g']['date'] = hash.delete 'Dates Assoc name g'
  names['h']['date'] = hash.delete 'Dates associated with name h'
  names['i']['date'] = hash.delete 'Dates associated with name i'
  names['j']['date'] = hash.delete 'Dates associated with name j'

  names['a']['name'] = hash.delete 'Name'
  names['b']['name'] = hash.delete 'Name b'
  names['c']['name'] = hash.delete 'Name c'
  names['d']['name'] = hash.delete 'Name d'
  names['e']['name'] = hash.delete 'Name e'
  names['f']['name'] = hash.delete 'Name f'
  names['g']['name'] = hash.delete 'Name g'
  names['h']['name'] = hash.delete 'Name h'
  names['i']['name'] = hash.delete 'Name i'
  names['j']['name'] = hash.delete 'Name j'

  names['a']['role'] = hash.delete 'Personal Name role'
  names['b']['role'] = hash.delete 'Personal name b role'
  names['c']['role'] = hash.delete 'Personal name c role'
  names['d']['role'] = hash.delete 'Personal name d role'
  names['e']['role'] = hash.delete 'Name e role'
  names['f']['role'] = hash.delete 'Name f role'
  names['g']['role'] = hash.delete 'Name g role'
  names['h']['role'] = hash.delete 'Name h role'
  names['i']['role'] = hash.delete 'Name i role'
  names['j']['role'] = hash.delete 'Name j role'

  normalised[:apis_id] = hash.delete "APIS ID"
  normalised[:dimensions] = hash.delete 'Dimensions'
  normalised[:general_note] = hash.delete 'General Note'

  original_inventory_number = hash.delete 'Inventory number'
  normalised[:inventory_number] = original_inventory_number
  inventory_numbers = normalise_inventory_numbers(original_inventory_number)

  genre_name = hash.delete('Genre')
  genre_name = genre_name.strip
  genre_name = genre_name.slice(0...-1) if genre_name.ends_with? '?'
  genre_name = genre_name.strip
  genre_name = genre_name.slice(0...-1) if genre_name.ends_with? '?'

  if ['Subliterary', 'Sub literary'].include? genre_name
    genre_name = 'Paraliterary'
  elsif genre_name == 'Literary'
    genre_name = 'Literary Text'
  end
  begin
    normalised[:genre_id] = Genre.find_by_name!(genre_name).id if genre_name.present?
  rescue ActiveRecord::RecordNotFound
    errors << "bad genre: #{genre_name}"
  end

  language_code = hash.delete('Language Code')
  language_code.gsub!('?', '')
  language_codes = language_code.split(/[,; ]/).map do |lc|
    modded = lc.downcase
    if ['gc', 'greek', 'grc', 'grd'].include? modded
      'grc'
    elsif ['cpt'].include? modded
      'cop'
    elsif ['dem'].include? modded
      'egy-Egyd'
    elsif modded.blank?
      nil
    else
      modded
    end
  end.compact
  normalised[:language_ids] = language_codes.map{|code| Language.find_by_code!(code).id}

  normalised[:language_note] = hash.delete 'Language note'

  normalised[:physical_location] = hash.delete 'Location of originals'
  normalised[:translated_text] = hash.delete 'Translation of Text'
  normalised[:summary] = hash.delete 'Summary'
  normalised[:keywords] = hash.delete 'Subjects keywords'
  normalised[:recto_verso_note] = hash.delete 'Noter: Recto Verso note'
  normalised[:paleographic_description] = hash.delete 'Note: Palaeographic Description'
  normalised[:origin_details] = hash.delete 'Origin'
  normalised[:other_characteristics] = hash.delete 'Other characteristics'
  normalised[:preservation_note] = hash.delete 'Prservation Note'

  normalised[:type_of_text] = hash.delete 'Type of Text: title'
  normalised[:publications] = hash.delete 'Publication'
  normalised[:source_of_acquisition] = hash.delete 'Source of Acquisition'
  normalised[:lines_of_text] = hash.delete 'Note: lines of text'

  mqt = hash.delete('Macq Control  No')
  mqt.gsub!(' (r)', '')
  mqt.gsub!(' (v)', '')
  mqt.gsub!(',', '')
  mqt.gsub!(/\[.*\]/, '')
  mqt.gsub!(/n\/a/i, '')
  mqt.gsub!('MQD', 'MQT')
  mqt.gsub!('MGT', 'MQT')
  mqt_numbers = mqt.split(/MQT (\d+)/).map(&:strip).select{|x|x != ''}.map{|x|Integer(x)}

  normalised[:conservation_note] = hash.delete 'Conservation ststus' # not a typo
  normalised[:modern_textual_dates] = hash.delete 'Modern textual dates'

  date_string = hash.delete 'Dates for searching'
  normalised[:date_note] = date_string
  normalised.merge!(normalised_dates(date_string))

  # mqt_note contains Local Note, Physical Type, Connections, Errors
  hash.merge!(errors: errors.inspect)
  normalised[:mqt_note] = hash_format(hash)
  [mqt_numbers, normalised, names, inventory_numbers]
end

def normalise_inventory_numbers(str)
  str = str.dup
  str.strip!
  if str =~ /\Ap\. ?macquarie inv( |\. ?|\.?  )(\d+)( \(\d+\))?\Z/i
    [Integer($2)]
  elsif str =~ /\AMS\. Macquarie\.1 \(Inv\. (\d+)\)\Z/
    [Integer($1)]
  elsif str.gsub(' ', '') =~ /\AMS\.?Macq\.(\d+)\(Inv\.(\d+)\)\Z/
    [Integer($1), Integer($2)]
  elsif str.gsub(' ', '')  =~ /\ATL\.?Macq\.Inv\.(\d+)\Z/i
    [Integer($1)]
  elsif str =~ /\A(Lead|Silver) Inv\.? (\d+)\Z/
    [Integer($2)]
  elsif str =~ /\AP\. Oxy( |\.X\.)(\d+)\Z/
    [Integer($2)]
  else
    if str.downcase.start_with? 'p. macquarie inv.'
      str = str.slice('P. Macquarie inv.'.length..-1)
      str.gsub!(/\[\d\/\d\]/, '')
      str.gsub!(/\/\d/, '')
      str.gsub!(/inv\.?/i, '')
      str.gsub!(/\([a-z0-9]\)/, '')
      str.gsub!('see', '')

      tokens = str.split(/[,\+ ]/)
      sth = tokens.map do |str|
        Integer(str) rescue puts("WARN unrecognised inventory numbers: #{str}") unless str.strip.blank?
      end.compact
    else
      puts "WARN unrecognised inventory numbers: |#{str}|" unless str.strip.blank?
    end
  end
end

def normalised_dates(date_string)
  if date_string.tr('–', '-') =~ /(-?\d+).*?-.*?(-?\d+)/
    {date_from: $1.to_i, date_to: $2.to_i}
  else
    {}
  end
end

def hash_format(hash)
  hash.map do |field, val|
    "#{field}: #{val}"
  end.join("\n")
end
