class PagesController < ApplicationController
  def home
	@title = "Cucushift Validator"

	@val_code = params[:user_code]	
  end

end
