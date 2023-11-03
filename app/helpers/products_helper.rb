
require "net/http"
require_relative "../service/openai.rb"

module ProductsHelper
  def fetch_embeddings(product_params)

    input = "Name: #{product_params[:name]}\n Description: #{product_params[:description]}\n Price: #{product_params[:price]}\n Brand: #{product_params[:brand]}\n Category: #{product_params[:category]}"

    client = OpenAIClient.new

    response = client.embeddings(
      parameters: {
        input: input,
        model: "text-embedding-ada-002"
      }
    )

    response["data"].map { |v| v["embedding"] }
  end

  def fetch_embeddings_query(query, conversation=[])

    OpenAIClient.new.should_fetch_embeddings?(query, conversation)
    data = {
      input: query,
      model: "text-embedding-ada-002"
    }

    client = OpenAIClient.new

    response = client.embeddings(
      parameters: data
    )

    response["data"].map { |v| v["embedding"] }[0]
  end

  def get_product_embedding_string(product)
    "Name: #{product[:name]}\n Description: #{product[:description]}\n Price: #{product[:price]}\n Brand: #{product[:brand]}\n Category: #{product[:category]}"
  end


  def create_chat_completion(prompt, chat_messages)
    gpt_messages = chat_messages.map {|message| {"role": message.system? ? "assistant" : "user", "content": message.content}}

    data = {
      "model" => "gpt-3.5-turbo",
      "messages" => gpt_messages.push({"role": "user", "content": prompt})
    }

    client = OpenAIClient.new


    response = client.chat(
      parameters: data
    )

    pp response

    response["choices"][0]
  end

  def format_product_context(product)
    "Name: #{product[:name]}\n Description: #{product[:description]}\n Price: #{product[:price]}\n Brand: #{product[:brand]}\n Category: #{product[:category]}"
  end

  def simple_product_context(product)
    "Name: #{product[:name]}\n Description: #{product[:description]}\n"
  end
end
