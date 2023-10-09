class CreateChats < ActiveRecord::Migration[7.0]
  def change
    create_table :chats do |t|
      t.references :company, foreign_key: true 
      t.timestamps
    end
  end
end