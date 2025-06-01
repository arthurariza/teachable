class ImportersController < ApplicationController
  def create
    Teachable::ImportJob.perform_later

    redirect_to root_path, notice: "Import started, come back later!"
  end
end
