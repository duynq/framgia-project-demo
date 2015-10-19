class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    # change_table :users do |t|
    #   t.index :email
    # end
    
    add_index :users, :email, unique: true
  end
end
