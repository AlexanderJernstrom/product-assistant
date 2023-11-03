class UploadProductDataJob < ApplicationJob
  queue_as :default

  def perform(products, company_id, job)
    begin
      embeddings = UploadSevice.new(products).generate_embeddings
      products.each_with_index do |product, index|
        Product.create(product.merge(embedding: embeddings[index]))
      end
      job.update(status: "Completed")
    rescue => e
      pp "An error occurred: #{e}"
      job.update(status: "Failed")
    end
   # Do something later
  end
end
