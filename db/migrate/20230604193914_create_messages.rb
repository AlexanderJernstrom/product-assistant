class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :content
      t.boolean :system
      
      t.timestamps
    end
  end
end
