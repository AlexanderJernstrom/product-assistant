class ProductSynced < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :synced, :boolean, default: false
  end
end
