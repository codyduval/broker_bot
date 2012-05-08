class DeleteDateColumnFromListings < ActiveRecord::Migration
  def up
    remove_column :listings, :date_entered
  end

  def down
    add_column :listings, :date_entered, :string
  end
end
