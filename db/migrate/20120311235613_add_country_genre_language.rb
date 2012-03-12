class AddCountryGenreLanguage < ActiveRecord::Migration
  def up
    create_table :countries do |t|
      t.string :name
    end

    create_table :genres do |t|
      t.string :name
    end

    create_table :languages do |t|
      t.string :name
    end

    create_table :languages_papyri do |t|
      t.references :language
      t.references :papyrus
    end

    change_table :papyri do |t|
      t.integer :country_of_origin_id
      t.references :genre
    end
  end
  def down
    change_table :papyri do |t|
      t.remove :genre_id
      t.remove :country_of_origin_id
    end
    drop_table :languages_papyri
    drop_table :languages
    drop_table :genres
    drop_table :countries
  end

end
