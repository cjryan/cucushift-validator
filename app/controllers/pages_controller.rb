class PagesController < ApplicationController
  def home
	@title = "Cucushift Validator"
	@val_code = params[:user_code]
        @result = {}
        return 0 unless @val_code

	#Iterate over each line of code	
	@val_code.split("\n").each_with_index do |line, line_number|

            #if line starts with 'Feature: ', 'Scenario: ', or a comment remove it
            line.gsub!(/^\s*(Feature:|Scenario:)\s+(.*)/,'')
	    line.gsub!(/^#(.*)/,'')
                    
	    #the verification
	    next unless line.length > 1

	    #The +1 is added to the line number to account for the 0 offset. This is done to match up with 
	    #the line numbers in the text area in the view.
            @result[line_number + 1] = false


	    #remove leading whitespace from user input
	    line.chomp!
	    line = line.strip

	    #remove leading words: When, Then, And, or Given
	    line.sub!(/^\s*(When|Given|Then|And)\s+/,'')

	    Re.all.each do |str|
              re = str[:re_value]
              re.sub!(/^\//,'') #remove /.../
              re.sub!(/\/$/,'') #remove /.../
              #@result[line_number + 1] = "#{re} =~ #{line}"

	      if line =~ /#{re}/
                   #@result[line_number] = line + ' true'
            	   @result[line_number + 1] = true
                   break
              end
	    end
	end
	#@re = Re.find(10)
  end

end
