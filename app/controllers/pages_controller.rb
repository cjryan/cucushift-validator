class PagesController < ApplicationController
  def home
	@title = "Cucushift Validator"
	@val_code = params[:user_code]
        @result = []
        return 0 unless @val_code

        line_number = 0 
        
	#Iterate over each line of code	
	@val_code.split("\n").each do |line|
	    #the verification
            @result.push (false)
	    Re.all.each do |str|
              re = str[:re_value]
              re.sub!(/^\//,'') #remove /.../
              re.sub!(/\/$/,'') #remove /.../
              #@debug_x = re
	      if line =~ /#{re}/
                   @result[line_number] = true
                 #break
              end
	    end
            line_number += 1
	end

	#@re = Re.find(10)
        #@resul t
  end

end
