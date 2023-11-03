class CompanyController < ApplicationController
  before_action :authenticate_user!

  def show
    @company = Company.find(current_user.company_id)
    @products = @company.products.take(10)
    @chat = Chat.create(company_id: @company.id)
  end

  def chat_testing
    @chat = Chat.create(company_id: current_user.company_id)
    @company = Company.find(current_user.company_id)
    # create chat message on @chat
    # create chat message on @chat
  end

end
