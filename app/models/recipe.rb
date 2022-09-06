class Recipe < ApplicationRecord

    has_many :meals
    has_many :meal_catagories, through: :meals

    validates :name, presence: true
    validates :description, presence: true
    validates :ingredients, presence: true
end
