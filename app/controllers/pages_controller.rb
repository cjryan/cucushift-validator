class PagesController < ApplicationController
  def home
	@title = "Cucushift Validator"
	@val_code = params[:user_code]
        @result = {}
        return 0 unless @val_code

	#Iterate over each line of code	
	@val_code.split("\n").each_with_index do |line, line_number|
	    #the verification
	    next unless line.length > 1
            @result[line_number] = false

	    #if line starts with 'Feature: ' remove it
	    line.gsub!(/^\s*(Feature:)\s+(.*)/,'')

	    #remove leading whitespace from user input
	    line.chomp!
	    line = line.strip

	    #remove leading words: When, Then, And, or Given
	    line.sub!(/^\s*(When|Given|Then|And)\s+/,'')

	    Re.all.each do |str|
              re = str[:re_value]
              re.sub!(/^\//,'') #remove /.../
              re.sub!(/\/$/,'') #remove /.../
              @result[line_number] = "#{re} =~ #{line}"

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
