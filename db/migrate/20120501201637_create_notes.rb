class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :note_text
      t.string :note_author
      t.timestamps
    end
  end
end
