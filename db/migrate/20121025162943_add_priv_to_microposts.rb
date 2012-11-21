class AddPrivToMicroposts < ActiveRecord::Migration
  def change
  	add_column :microposts, :priv, :boolean, :default => false
  end
end