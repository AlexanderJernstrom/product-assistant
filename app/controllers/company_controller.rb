class CompanyController < ApplicationController
  before_action :authenticate_user!

  def show
    @company = Company.find(current_user.company_id)
  end
end
