class CreateProductUploads < ActiveRecord::Migration[7.0]
  def change
    create_table :product_uploads do |t|
      t.references :company, null: false, foreign_key: true
      t.string :job_id
      t.string :status

      t.timestamps
    end
  end
end
