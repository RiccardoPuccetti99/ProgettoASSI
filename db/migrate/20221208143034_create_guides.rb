class CreateGuides < ActiveRecord::Migration[6.1]
  def change
    create_table :guides do |t|
      t.string :title, null: false 
      t.string :champ_name, null: false 
      t.string :champ_role, null: false 
      t.text :champ_rune, null: false 
      t.string :skill_order, null: false 
      t.text :path_jungle, default: ""
      t.text :item, null: false 
      t.text :guida, null: false 
      t.text :counter, default: ""
      t.text :ideal, default: ""

      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
