class PresentationController < ApplicationController
  def index
    @company_id = 1
    @company = Company.find(@company_id)
    @chat = Chat.create(company_id: @company_id)
  end
end
