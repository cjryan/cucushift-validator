class PagesController < ApplicationController
  def home
	@title = "Cucushift Validator"
	@val_code = params[:user_code]
        return 0 unless @val_code

        @result = []
        line_number = 0 
        
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
