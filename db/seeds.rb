# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create multiple products for Company with id 1
require "net/http"
require "csv"
require "json"


def fetch_embeddings_many(products)
  input = products.map do |product|
    table_string = product[:attributes_table].map do |key, value|
      "#{key}: #{value}"
    end.join("\n")
    "Namn: #{product[:product_name]}\n Beskrivning: #{product[:product_description]}\n Information: #{table_string} "
  end

  url = "https://api.openai.com/v1/embeddings"
  headers = {
    "Authorization" => "Bearer #{ENV["OPENAI_API_KEY"]}",
    "Content-Type" => "application/json"
  }
  data = {
    input: input,
    model: "text-embedding-ada-002"
  }

  response = Net::HTTP.post(URI(url), data.to_json, headers)
  JSON.parse(response.body)["data"].map { |v| v["embedding"] }
end

def create_data
  company = Company.find(1)

  file = File.read("./db/data/data.json")
  products = JSON.parse(file)

  products = products.map do |product|
    {
      name: product["product_name"],
      description: product["product_description"],
      price: 10,
      category: "Padel",
      brand: "Babolat",
      company_id: company.id,
      attributes_table: product["attributes_table"]
    }
  end
  embeddings = fetch_embeddings_many(products)
  products = products.map do |product|
    # remove attributes_table from product
    product.delete(:attributes_table)
    product
  end



  products.each_with_index do |product, index|
    pp product
    Product.create(product.merge(embedding: embeddings[index]))
  end
end

create_data
