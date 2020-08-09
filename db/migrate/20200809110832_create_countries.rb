class CreateCountries < ActiveRecord::Migration[6.0]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :code
      t.text :topLevelDomain #serialize
      t.string :alpha2Code
      t.string :alpha3Code
      t.text :callingCodes #serialize
      t.string :capital
      t.string :region
      t.string :subregion
      t.text :timezones #serialize
      t.string :flag
      t.timestamps
    end
  end
end
