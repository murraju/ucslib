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

class UCSManage

	def initialize(tokenjson)

	@cookie  = "#{JSON.parse(tokenjson)['cookie']}"
	ip       = "#{JSON.parse(tokenjson)['ip']}"
	@url 	 = "https://#{ip}/nuova"

	end

	def associate_service_profile_template_to_server_pool(json)

	service_profile_boot_policy        = JSON.parse(json)['service_profile_boot_policy']
	service_profile_host_fw_policy     = JSON.parse(json)['service_profile_host_fw_policy']
	service_profile_mgmt_fw_policy     = JSON.parse(json)['service_profile_mgmt_fw_policy']
	service_profile_uuid_pool          = JSON.parse(json)['service_profile_uuid_pool']
	service_profile_template_to_bind   = JSON.parse(json)['service_profile_template_to_bind']
	service_profile_server_pool 	   = JSON.parse(json)['service_profile_server_pool']
	org                				   = JSON.parse(json)['org']


	xml_builder = Nokogiri::XML::Builder.new do |xml|
	  xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
	    xml.inConfigs{
	      xml.pair('key' => "org-root/org-#{org}/ls-#{service_profile_template_to_bind}"){
	        xml.lsServer('agentPolicyName' => '', 'biosProfileName' => '', 'bootPolicyName' => "#{service_profile_boot_policy}",
	                     'descr' => '', 'dn' => "org-root/org-#{org}/ls-#{service_profile_template_to_bind}",
	                     'dynamicConPolicyName' => '', 'extIPState' => 'none', 'hostFwPolicyName' => "#{service_profile_host_fw_policy}",
	                     'identPoolName' => "#{service_profile_uuid_pool}", 'localDiskPolicyName' => 'default', 'maintPolicyName' => 'default',
	                     'mgmtAccessPolicyName' => '', 'mgmtFwPolicyName' => "#{service_profile_mgmt_fw_policy}", 'powerPolicyName' => 'default', 
	                     'scrubPolicyName' => '', 'solPolicyName' => 'default', 'srcTemplName' => '', 
	                     'statsPolicyName' => 'default', 'status' => 'created,modified', 'usrLbl' => '', 'uuid' => '0', 'vconProfileName' => ''){
	                       xml.lsRequirement('name' => "#{service_profile_server_pool}", 'qualifier' => '', 'restrictMigration' => 'no', 'rn' => 'pn-req')
	                     }
	      }
	    }
	  }
	end

	#Create XML

	associate_service_profile_template_to_server_pool_xml = xml_builder.to_xml.to_s

	#Post 
	begin
		RestClient.post(@url, associate_service_profile_template_to_server_pool_xml, :content_type => 'text/xml').body
	rescue Exception => e
		raise "Error #{e}"
	end 

	end
end