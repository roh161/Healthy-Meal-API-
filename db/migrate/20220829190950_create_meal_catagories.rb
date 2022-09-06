class CreateMealCatagories < ActiveRecord::Migration[7.0]
  def change
    create_table :meal_catagories do |t|
      t.string :name

      t.timestamps
    end
  end
end
