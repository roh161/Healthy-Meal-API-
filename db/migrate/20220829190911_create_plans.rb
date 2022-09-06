class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.text :description
      t.integer :plan_duration
      t.integer :plan_cost
      t.integer :age_category_id
      
      t.timestamps
    end
  end
end
