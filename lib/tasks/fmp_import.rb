require 'csv'

def import_from_filemaker_pro filename, image_root
  puts "importing from CSV: #{filename} image_root: #{image_root}"
  papyri_data = read_hashes_from_csv(filename)
  papyri_data.each do |hash|
    to_attrs(hash)
  end
end

def read_hashes_from_csv(file_name)
  csv_data = CSV.read(file_name)
  headers = csv_data.shift.map { |i| i.to_s }
  string_data = csv_data.map { |row| row.map { |cell| cell.to_s } }
  string_data.map { |row| Hash[*headers.zip(row).flatten] }
end

def candidate_images(directory_name)
  all_filenames = Dir.glob("#{directory_name}/**").map{|filename| File.expand_path(filename)}
  tifs = all_filenames.select{|filename| filename =~ /tif$/i }

  images = {}
  tifs.each do |tif|
    inv_id = extract_inventory_id(tif)
    if !images.has_key? inv_id
      images[inv_id] = []
    end
    images[inv_id] << tif
    images[inv_id].sort! # for easier testing
  end
  puts "WARNING: unrecognised images: #{images[nil].join ', '}" if images.has_key? nil
  images
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

  #normalised[:inventory_number] = hash.delete "Inventory number" # TODO
  original_inventory_number = hash.delete 'Inventory number'
  normalise_inventory_numbers(original_inventory_number)

  #normalised[:genre] = Genre.find_by_name! hash.delete('Genre')
  #hash.delete('Genre') #normalised[:genre] = Genre.find_by_name! hash.delete('Genre')
  #normalised[:language] = Language.find_by_code! hash.delete('Language Code')
  #hash.delete('Language Code') #normalised[:language] = Language.find_by_code! hash.delete('Language Code')
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

# TODO
#  if mqt =~ /\AMQT (\d+)\Z/
#    normalised[:mqt_number ] = $1.to_i
#  else
#    raise "unrecognised mqt: #{mqt}"
#  end

  # hash.delete 'Dates for searching' # TODO
  # hash.delete 'Local Note' # TODO
  # hash.delete 'Physical Type' # TODO
  # connections = hash.delete 'Connections' # TODO

  normalised[:conservation_note] = hash.delete 'Conservation ststus' # not a typo
  normalised[:modern_textual_dates] = hash.delete 'Modern textual dates'

  normalised[:mqt_note] = hash.inspect # TODO
end

def normalise_inventory_numbers(str)
  str = str.dup
  str.strip!
  if str =~ /\Ap\. ?macquarie inv( |\. ?|\.?  )(\d+)( \(\d+\))?\Z/i
    Integer($2)
  elsif str =~ /\AMS\. Macquarie\.1 \(Inv\. (\d+)\)\Z/
    Integer($1)
  elsif str.gsub(' ', '') =~ /\AMS\.?Macq\.(\d+)\(Inv\.(\d+)\)\Z/
    [Integer($1), Integer($2)]
  elsif str.gsub(' ', '')  =~ /\ATL\.?Macq\.Inv\.(\d+)\Z/i
    Integer($1)
  elsif str =~ /\A(Lead|Silver) Inv\.? (\d+)\Z/
    Integer($2)
  elsif str =~ /\AP\. Oxy( |\.X\.)(\d+)\Z/
    Integer($2)
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
        Integer(str) rescue nil
      end.compact
      puts sth
      
    end
    puts "|#{str}|"
    #raise str.inspect
  end
end
