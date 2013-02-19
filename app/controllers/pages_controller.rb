class PagesController < ApplicationController
  def home
	@title = "Cucushift Validator"

	@val_code = params[:user_code]	

	@regexes = Re.find(:all)
  end

end
