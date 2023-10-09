require "openai"
class OpenAIClient
  def initialize
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    @client
  end

  def embeddings(parameters:)
    @client.embeddings(parameters: parameters)
  end

  def chat(parameters:)
    @client.chat(parameters: parameters)
  end
end