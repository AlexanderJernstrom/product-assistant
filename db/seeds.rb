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


def fetch_embeddings_many(products)
  input = products.map do |product|
    "Name: #{product[:name]}\n Price: #{product[:price]}\n Rating: #{product[:description]}\n Category: #{product[:category]}" 
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
  
  file = File.read("./db/data/products.csv")
  products = CSV.parse(file, headers: true).map(&:to_h).reject { |hash| hash.values.include?(nil) }

  products = products.take(100)

  products = products.map do |product|
    pp products.index product
    {
      name: product["name"],
      price: product["actual_price"].gsub(/[^\d]/, '').to_i,
      description: product["rating"],
      category: product["main_category"],
      brand: product["sub_category"],
      company_id: company.id
    }
  end
  embeddings = fetch_embeddings_many(products)

  products.each_with_index do |product, index|
    Product.create(product.merge(embedding: embeddings[index]))
  end
end

create_data