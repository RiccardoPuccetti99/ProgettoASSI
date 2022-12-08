class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :rating, null: false 
      t.text :comment, default: ""
      t.datetime :creation_date, null: false, precision: 6
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :guide, null: false, foreign_key: true

      t.timestamps
    end
  end
end
