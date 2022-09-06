class Meal < ApplicationRecord

    belongs_to :meal_catagorie
    belongs_to :day
    belongs_to :recipe

end
