class PagesController < ApplicationController
  def home
	@title = "Cucushift Validator"

	@val_code = params[:user_code]	

	@re = Re.find(10)
  end

end
