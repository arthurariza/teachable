class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params.expect(:id))
  end
end
