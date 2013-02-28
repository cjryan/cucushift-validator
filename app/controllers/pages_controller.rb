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
  end

  def instructions
    @title = "Cucushift Validator Instructions"
  end

  def status
    @title = "Cucushift Validator Status"
    @db_for_stats = Re.all
  end

  def push
     @title = "Cucushift Validator Status"
     begin
       uploaded_io = params[:sql_gz]
       json_uploaded_io = params[:json_upload]

       #Add some logic here to check if the file is a .bz2 file.
       @path_for_file = Rails.root.join(ENV['OPENSHIFT_TMP_DIR'], 'cucushift_dump.sql.bz2')
       logger.info "path_for_file=#{@path_for_file}"
       logger.info ENV['OPENSHIFT_TMP_DIR']
       #The write mode should be 'wb' to avoid encoding errors.
       File.open(@path_for_file, 'wb') do |file|
         file.write(uploaded_io.read)
       end

       @path_for_json_file = Rails.root.join(ENV['OPENSHIFT_TMP_DIR'], json_uploaded_io.original_filename)
       logger.info "path_for_file=#{@path_for_json_file}"
       logger.info ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>The JSON Uploader Info is: #{json_uploaded_io}"
       File.open(@path_for_json_file, 'wb') do |jsonfile|
	  jsonfile.write(json_uploaded_io.read)
       end
     rescue => e
       @error_message = e
       logger.info "ERR: #{@error_message}"
     end
  end
end
