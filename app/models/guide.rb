class Guide < ApplicationRecord
	has_many :review, dependent: :destroy 
    belongs_to :user   

	#constraints
	validates :title, :champ_name, :champ_role, :guida, presence: true
    
    
    def avg_reviews
        sum = 0
		self.review.each do |review|
			sum = sum + review.rating
		end
		if self.review.count>0
			return sum/self.review.count
		else
			return "--"
		end
    end    
end