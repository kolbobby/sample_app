class AddFromToMicroposts < ActiveRecord::Migration
  def change
  	add_column :microposts, :from, :string
  end
end