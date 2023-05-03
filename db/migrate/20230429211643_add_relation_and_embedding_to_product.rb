class AddRelationAndEmbeddingToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :embedding, :vector
    add_reference :products, :company, foreign_key: true


  end
end
