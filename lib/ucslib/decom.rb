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

class UCSDcom
  
  def initialize(tokenjson)
    
	    @cookie   = "#{JSON.parse(tokenjson)['cookie']}"
	    ip        = "#{JSON.parse(tokenjson)['ip']}"
	    @url 	    = "https://#{ip}/nuova"

	end
	
	def delete_org(json)
	  
	  org = JSON.parse(json)['org']

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true') {
  		  xml.inConfigs{
  		    xml.pair('key' => "org-root/org-#{org}") {
  		      xml.orgOrg('descr' => "#{org} org", 'dn' => "org-root/org-#{org}", 'name' => "#{org}", 'status' => 'deleted')
  		    }
  		  }
  		}
  		end

  		#Create XML
  		delete_org_XML= xml_builder.to_xml.to_s

  		#Post

  		begin
  			RestClient.post(@url, delete_org_XML, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end
	 
	end
	
end