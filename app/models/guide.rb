class Guide < ApplicationRecord
	  has_many :review 
    belongs_to :user             
end