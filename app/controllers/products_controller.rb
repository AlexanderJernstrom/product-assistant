class ProductsController < ApplicationController

  before_action :authenticate_user!

  def new
    @product = Product.new
  end


  def create
    embeddings = helpers.fetch_embeddings(product_params)[0]
    pp product_params.merge(embedding: embeddings)
    @product = Product.new(product_params.merge(embedding: embeddings))

    if @product.save!
      redirect_to company_path(current_user.company)
    else
      render :new
    end
  end

  private 

  def product_params
    params.require(:product).permit(:name, :description, :price, :brand, :category, :company_id)
  end
end
