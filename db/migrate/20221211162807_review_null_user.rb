class ReviewNullUser < ActiveRecord::Migration[6.1]
  def change
    change_column_null :reviews, :user_id, true
  end
end
