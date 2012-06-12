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

class UCSUpdate
  
  def initialize(tokenjson)
  
    @cookie  = "#{JSON.parse(tokenjson)['cookie']}"
    ip       = "#{JSON.parse(tokenjson)['ip']}"
    @url 	 = "https://#{ip}/nuova"

  end
  
  def update_host_firmware_package(json)
  
		host_firmware_pkg_name  = JSON.parse(json)['host_firmware_pkg_name']
		hardware_model          = JSON.parse(json)['hardware_model'].to_s
		hardware_type           = JSON.parse(json)['hardware_type']
		hardware_vendor         = JSON.parse(json)['hardware_vendor'].to_s
		firmware_version        = JSON.parse(json)['firmware_version'].to_s
		org                     = JSON.parse(json)['org']

    xml_builder = Nokogiri::XML::Builder.new do |xml|
      xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'false'){
        xml.inConfigs{
          xml.pair('key' => "org-root/org-#{org}/fw-host-pack-#{host_firmware_pkg_name}"){
            xml.firmwareComputeHostPack('descr' => '', 'dn' => "org-root/org-#{org}/fw-host-pack-#{host_firmware_pkg_name}",
                                        'ignoreCompCheck' => 'yes', 'mode' => 'staged', 'stageSize' => '0', 'updateTrigger' => 'immediate'){
                                         xml.firmwarePackItem('hwModel' => "#{hardware_model}", 'hwVendor' => "#{hardware_vendor}",
                                                              'rn' => "pack-image-#{hardware_vendor}|#{hardware_model}|#{hardware_type}",
                                                              'type' => "#{hardware_type}", 'version' => "#{firmware_version}")
                                       }
          }
        }
      }
    end

    #Create XML

    update_host_firmware_packageXML = xml_builder.to_xml.to_s

    #Post

    begin
      RestClient.post(@url, update_host_firmware_packageXML, :content_type => 'text/xml').body
    rescue Exception => e
      raise "Error #{e}"
    end

  end

  
end