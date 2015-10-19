class RenameMicropostsToEntries < ActiveRecord::Migration
  def change
  	rename_table :microposts, :entries
  end
end
