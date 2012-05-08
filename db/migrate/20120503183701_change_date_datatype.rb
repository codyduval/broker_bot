class ChangeDateDatatype < ActiveRecord::Migration
  def up
    change_table :listings do |t|
      t.change :date_entered, :date
    end
  end

  def down
    change_table :listings do |t|
      t.change :date_entered, :string
    end
  end
end