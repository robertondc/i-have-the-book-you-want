class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :author
      t.string :title
      t.string :language

      t.timestamps
    end
  end
end
