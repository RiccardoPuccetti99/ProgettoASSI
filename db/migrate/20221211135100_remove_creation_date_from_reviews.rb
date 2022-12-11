class RemoveCreationDateFromReviews < ActiveRecord::Migration[6.1]
  def change
    remove_column :reviews, :creation_date, :datetime
  end
end
