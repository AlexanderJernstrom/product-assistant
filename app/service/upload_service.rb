class UploadService
  def initialize(params)
    @params = params
  end

  def generate_embeddings
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
end
