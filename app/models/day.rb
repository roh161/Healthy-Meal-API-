class Day < ApplicationRecord

    has_many :meals
    belongs_to :plan
    
end
