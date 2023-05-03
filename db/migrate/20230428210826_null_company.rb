class NullCompany < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :company_id, :integer, :null => true
  end
end
