class PagesController < ApplicationController
  def home
	@title = "Cucushift Validator"
        @result = []
        line_number = 0 
	@val_code = params[:user_code]
        return nil unless @val_code
        
	#Iterate over each line of code	
	@val_code.split("\n").each do |line|
	    #the verification
            @result.push (false)
	    Re.all.each do |str|
              str.sub!(/^\//,'') #remove /.../
              str.sub!(/\/$/,'') #remove /.../
              @debug_x = str
	      if line =~ /#{str}/
                 @result[line_number] = true
                 break
              end
	    end
            line_number += 1
	end

	#@re = Re.find(10)
        @result
  end

end
