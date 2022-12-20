class RemoveKarmaFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :karma, :integer
  end
end
