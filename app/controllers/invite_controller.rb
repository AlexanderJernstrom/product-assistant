class InviteController < ApplicationController
  before_action :authenticate_user!

  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.new(invite_params)
    if @invite.save
      redirect_to root_path, notice: 'Invite was successfully created.'
    else
      render :new
    end
  end

 
end
