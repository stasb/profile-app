class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :sub_headline
      t.text :about
      t.text :favourite_music
      t.text :favourite_quotes
      t.text :favourite_websites

      t.timestamps
    end
  end
end
