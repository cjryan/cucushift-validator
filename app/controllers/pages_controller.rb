class PagesController < ApplicationController
  def home
	@title = "Cucushift Validator"
	@val_code = params[:user_code]
        @result = {}
        @result2 = {}

	 Step_db_version.all.each do |db_vers|
		@dbv = db_vers[:version]
	end
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
            @result2[line_number + 1] = line


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

	      begin
		      if line =~ /#{re}/
			   #@result[line_number] = line + ' true'
			   @result[line_number + 1] = true
			   break
		      end
               rescue
               end
	    end
	end
	#@re = Re.find(10)
  end
  def instructions
    @title = "Cucushift Validator Instructions"
  end
  def status
    @title = "Cucushift Validator Status"
    @db_for_stats = Re.all
  end
  def push
    @sql_file = params[:sql_gz_file]
     uploaded_io = params[:person][:sql]
     File.open(Rails.root.join(ENV['OPENSHIFT_TMP_DIR'], uploaded_io.original_filename), 'w') do |file|
       file.write(uploaded_io.read)
     end

  end
end
