
require "net/http"

module ProductsHelper
  def fetch_embeddings(product_params)

    input = "Name: #{product_params[:name]}\n Description: #{product_params[:description]}\n Price: #{product_params[:price]}\n Brand: #{product_params[:brand]}\n Category: #{product_params[:category]}" 

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

  def fetch_embeddings_many(products)
    input = products.map do |product|
      "Name: #{product_params[:name]}\n Description: #{product_params[:description]}\n Price: #{product_params[:price]}\n Brand: #{product_params[:brand]}\n Category: #{product_params[:category]}" 
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
end
