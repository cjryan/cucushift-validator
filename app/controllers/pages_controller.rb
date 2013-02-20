class PagesController < ApplicationController
  def home
	@title = "Cucushift Validator"
	@val_code = params[:user_code]
        @result = {}
        return 0 unless @val_code

        line_number = 0 
        
	#Iterate over each line of code	
	@val_code.split("\n").each_with_index do |line, line_number|
	    #the verification
	    next unless line.length > 1
            @result[line_number] = false
	    Re.all.each do |str|
              re = str[:re_value]
              re.sub!(/^\//,'') #remove /.../
              re.sub!(/\/$/,'') #remove /.../
	      if line =~ /#{re}/
                   #@result[line_number] = line + ' true'
            	   @result[line_number] = true
                   break
              end
	    end
	end
	#@re = Re.find(10)
  end

end
