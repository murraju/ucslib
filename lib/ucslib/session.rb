# Author:: Murali Raju (<murali.raju@appliv.com>)
# Copyright:: Copyright (c) 2012 Murali Raju.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#UCSM API Session management


class UCSToken
	#Accept a JSON object that contains the UCSM username, password, and IP
	def get_token(authjson)

	    username = "#{JSON.parse(authjson)['username']}"
	    password = "#{JSON.parse(authjson)['password']}"
	    ip       = "#{JSON.parse(authjson)['ip']}"
	    url      = "https://#{ip}/nuova"
	    
	    xml_builder = Nokogiri::XML::Builder.new do |xml|
	        xml.aaaLogin('inName' => username, 'inPassword' => password)
	    end
	    aaa_login_xml = xml_builder.to_xml.to_s
	    ucs_response = RestClient.post(url, aaa_login_xml, :content_type => 'text/xml').body 
	    ucs_login_doc = Nokogiri::XML(ucs_response) 
	    ucs_login_root = ucs_login_doc.root 
	    cookie = ucs_login_root.attributes['outCookie'] 

		begin
			return session = {  :cookie   => "#{cookie}",
							    :username => "#{username}",
							    :password => "#{password}",
							    :ip       => "#{ip}"  }.to_json 
		rescue Exception => e
			'An Error Occured. Please check authentication credentials'
		else
			Process.exit
		end

	end


	def refresh_token(tokenjson)

		cookie 	 = "#{JSON.parse(tokenjson)['cookie']}"
		username = "#{JSON.parse(tokenjson)['username']}"
	    password = "#{JSON.parse(tokenjson)['password']}"
	    ip       = "#{JSON.parse(tokenjson)['ip']}"
	    url 	 = "https://#{ip}/nuova"
	    

	    xml_builder = Nokogiri::XML::Builder.new do |xml|
	        xml.aaaRefresh('inName' => username, 'inPassword' => password, 'inCookie' => cookie)
	        end
	    aaa_refresh_xml = xml_builder.to_xml.to_s
	    
	    ucs_response = RestClient.post(url, aaa_refresh_xml, :content_type => 'text/xml').body 

	 
	    ucs_login_doc = Nokogiri::XML(ucs_response)
	    ucs_login_root = ucs_login_doc.root 
	    new_cookie = ucs_login_root.attributes['outCookie'] 

	    begin
		    #return ucs_session json containing new cookie, url, ip
			return session = {  :cookie   => "#{new_cookie}",
							    :username => "#{username}",
							    :password => "#{password}",
							    :ip       => "#{ip}"  }.to_json 
		  rescue Exception => e
			'An Error Occured. Please check authentication credentials'
		  else
			  Process.exit
		  end

	end

	def logout(tokenjson)
	  
	  	cookie 	 = "#{JSON.parse(tokenjson)['cookie']}"
    	ip       = "#{JSON.parse(tokenjson)['ip']}"
   	 	url 	 = "https://#{ip}/nuova"
	  
	  	xml_builder = Nokogiri::XML::Builder.new do |xml|
        	xml.aaaLogout('inCookie' => cookie)
        end
    	
    	aaaLogoutXML = xml_builder.to_xml.to_s

    	begin
    		RestClient.post(url, aaaLogoutXML, :content_type => 'text/xml').body
    	rescue Exception => e
    		raise "Error #{e}"
    	end
    	
	end

end