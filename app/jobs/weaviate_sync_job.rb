require 'weaviate'
class WeaviateSyncJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    weaviate_client = Weaviate::Client.new(
      url: 'http://localhost:8080',  # Replace with your endpoint
      model_service: :openai, # Service that will be used to generate vectors. Possible values: :openai, :azure_openai, :cohere, :huggingface
      model_service_api_key: ENV["OPENAI_API_KEY"] # Either OpenAI, Azure OpenAI, Cohere or Hugging Face API key
    )
    unsynced_products = Product.where(synced: false)
    product_embedding_string = unsynced_products.map {|product| {properties:  {text: "Name: #{product[:name]}\n Description: #{product[:description]}\n Price: #{product[:price]}\n Brand: #{product[:brand]}\n Category: #{product[:category]}"}, class: 'Products'}}
    weaviate_client.objects.batch_create({objects: product_embedding_string}})
    unsynced_products.update_all(synced: true)
  end
end
