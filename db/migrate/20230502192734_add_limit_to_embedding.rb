class AddLimitToEmbedding < ActiveRecord::Migration[7.0]
  def change
    change_column :products, :embedding, :vector, limit: 1536
  end
end
