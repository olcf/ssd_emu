class WelcomeController < ApplicationController
  def index
    render json: {connection: true}
  end
end
