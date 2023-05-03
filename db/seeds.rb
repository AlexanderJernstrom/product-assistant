# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require Rails.root.join("app", "helpers")

# Create multiple products for Company with id 1


def create_data
  company = Company.find(1)
  products = []

  10.times do
    product = {
      :name => Faker::Commerce.product_name,
      :description => Faker::Lorem.paragraph,
      :price => Faker::Commerce.price,
      :brand => Faker::Commerce.brand,
      :category => Faker::Commerce.department,
      :company_id => company.id
    }
    products << product
  end

  embeddings = helpers.fetch_embeddings_many(products)

  products.each_with_index do |product, index|
    Product.create(product.merge(embedding: embeddings[index]))
  end
end

create_data