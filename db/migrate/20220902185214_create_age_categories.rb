class CreateAgeCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :age_categories do |t|
      t.string :age
      
      t.timestamps
    end
  end
end
