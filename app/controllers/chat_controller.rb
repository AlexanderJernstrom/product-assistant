require_relative "../service/openai.rb"
class ChatController < ApplicationController

  def create
    @query = params[:query]
    @company_id = params[:company_id]
    @chat_id = params[:chat_id]
    @chat = Chat.find(@chat_id)
    company = Company.find(@company_id)

    pp @chat_id


    query_embeddings = helpers.fetch_embeddings_query(@query, @chat.messages)
    products = Product.new(embedding: query_embeddings).nearest_neighbors(:embedding, distance: "inner_product").first(10)

    prompt = "You are an enthusiastic product assistant at this company who loves to help customers find the right product and give information about the products. You are asked to help a customer find a product that matches the following description: #{@query}.

    Always incorporate any previous interactions with the customer into your current response. Context is key. Remember, the goal is to find the best matches based on the customer's query, and to provide information about the products in a clear and concise manner. Be sure to consider factors like price, specifications, and user reviews.

    Return the products formatted in markdown and the link to the products. The product link is localhost:3000/company/#{params[:company_id]}/product/{product_name}. Format the link with an underline. Ensure to respond in the same language as the customer's query. This is important to provide a smooth and natural conversation experience.

    If the question is unclear, be sure to ask follow-up questions about price, expectations, and use cases. If multiple products match the query, return a maximum of four most relevant ones. If only one product perfectly matches the query, just return that one.

    Here are the details of the products: #{products.map{|p| helpers.format_product_context(p)}.join("\n")}.

    Example formatting:

    Product name Price: {product price}, Rating: {product rating}
    Example Response:

    Product A Price: $1000, Rating: 4.5/5. It perfectly matches your requirements of being light, powerful, and within budget.
    Product B Price: $800, Rating: 4.2/5. Although slightly less powerful than Product A, it's lighter and well within your budget.
    Remember, context from previous interactions is key to a meaningful conversation. Always aim to make the customer's experience as smooth and helpful as possible.
    "

    prompt2 = "You are a product assistant at #{company.name} and you are asked to help a customer by answering their questions. If the user has
    direct questions about certian products you may use these examples: #{products.map{|p| helpers.format_product_context(p)}.join("\n")}
    Otherwise just answer their enquiries.
    User prompt: #{@query}
    "
    pp products
    swe_prompt = "Du är en entusiastisk med arbetare på Ongoal, en expert på padelracket och ditt jobb är att hitta det rätta padelracket åt kunden. Om det frågas någonting annat som inte har med racket så avvisar du dem artigt.
      Om användaren har direkt frågor gällande vissa produkter kan du använda dessa exempel: #{products.map{|p| helpers.simple_product_context(p)}.join("\n")}
      Annars svara på deras frågor.
      När du returnerar produkterna, returnera dem i markdown. Du får endast svara med produkterna som du fått som exempel.
      Om det går, svara med minst tre produkter. Om det bara finns en produkt som matchar frågan, svara med den.
      Tänk på det som sagts tidigare i konversationen. Det är viktigt att du svarar på ett naturligt sätt.
      Svara endast på svenska, använd inte några engelska ord.
      Användarens fråga: #{@query}"


    @message = helpers.create_chat_completion(swe_prompt, @chat.messages)["message"]

    @chat.messages.create(content: @query, system: false)
    @chat.messages.create(content: @message["content"], system: true)

    respond_to do |format|
      format.turbo_stream
      format.html { render plain: "Success" } # Add a fallback format
    end
  end

  def chat

  end


end
