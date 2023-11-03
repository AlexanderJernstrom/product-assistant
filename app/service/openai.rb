require "openai"
class OpenAIClient
  def initialize
    @client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    @should_fetch_embeddings_function = {
      :name => "should_fetch_embedding_or_ask_follow_up_questions",
      :description => "If the product data should be fetche and if the assistant should ask follow up questions",
      :parameters => {
        :type => "object",
        :properties => {
          :should_fetch_embeddings => {
            :type => "boolean",
            :description => "If the product data should be fetched"
          },
          :should_ask_follow_up_questions => {
            :type => "boolean",
            :description => "If the assistant should ask follow up questions"
          },
        }
      }
    }
    @client
  end
  def format_conversation_string(conversation)
    conversation.map {|message| {"role": message.system? ? "assistant" : "user", "content": message.content}}.each{|message| format_message(message)}.join("\n")
  end

  def format_message(message)
    if message["role"] == "assistant"
      "Role: assistant, Message: #{message["content"]}"
    else
      "Role: user, Message: #{message["content"]}"
    end
  end
  def should_fetch_embeddings?(message, conversation=[])
    prompt = "You are helpful LLM helping out as a product assistant at this company. Based on the question from the user and previous conversation,
    is it necessary to fetch query the products and do you have the information needed to query the products or do you need to ask some more questions? User query: #{message}.
    Previous conversation: #{format_conversation_string(conversation)}"
    pp prompt
    parameters = {
      "model" => "gpt-3.5-turbo-0613",
      "messages" => [{role: "user", content: prompt}],
      "functions" => [@should_fetch_embeddings_function]
    }

    response = @client.chat(parameters: parameters)
    message = response.dig("choices", 0, "message")
    pp message
    args =
            JSON.parse(
                message.dig("function_call", "arguments"),
                { symbolize_names: true },
            )
    args[:should_fetch_embeddings]
  end


  def embeddings(parameters:)
    @client.embeddings(parameters: parameters)
  end

  def chat(parameters:)
    @client.chat(parameters: parameters)
  end
end
