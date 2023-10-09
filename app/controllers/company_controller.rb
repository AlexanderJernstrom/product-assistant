class CompanyController < ApplicationController
  before_action :authenticate_user!

  def show
    @company = Company.find(current_user.company_id)
    @products = @company.products.take(10)
    @chat = Chat.create(company_id: @company.id)
  end
end
