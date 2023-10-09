require 'weaviate'
=begin class Weaviate
  def self.get_client
    client = Weaviate::Client.new(
      url: 'http://localhost:8080',  # Replace with your endpoint
      model_service: :openai, # Service that will be used to generate vectors. Possible values: :openai, :azure_openai, :cohere, :huggingface
      model_service_api_key: ENV["OPENAI_API_KEY"] # Either OpenAI, Azure OpenAI, Cohere or Hugging Face API key
    )
    client
  end

end =end
