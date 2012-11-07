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


class UCSInventory
  
  def discover(tokenjson)
    
    cookie 	 = "#{JSON.parse(tokenjson)['cookie']}"
    ip       = "#{JSON.parse(tokenjson)['ip']}"
    url 	   = "https://#{ip}/nuova"

    #Start Build the Multi-Class XML
    xml_builder = Nokogiri::XML::Builder.new do |xml|
       xml.configResolveClasses('cookie' => cookie, 'inHierarchical' => 'false') {
        xml.inIds{
          xml.classId("value" => "topSystem")
          xml.classId("value" => "equipmentChassis")
          xml.classId("value" => "computeBlade")
          xml.classId("value" => "equipmentSwitchCard")
          xml.classId("value" => "equipmentIOCard")
          xml.classId("value" => "equipmentFanModule")
          xml.classId("value" => "equipmentPsu")
          xml.classId("value" => "networkElement")
          xml.classId("value" => "processorUnit")
          xml.classId("value" => "adaptorHostIf")
          xml.classId("value" => "memoryArray")
          xml.classId("value" => "memoryUnit")
          xml.classId("value" => "storageLocalDisk")
          xml.classId("value" => "equipmentFan")
          xml.classId("value" => "firmwareRunning")
          xml.classId("value" => "lsServer")
          xml.classId("value" => "orgOrg")
          xml.classId("value" => "fabricVlan")
          xml.classId("value" => "vnicEther")
          xml.classId("value" => "fabricVsan")
          xml.classId("value" => "vmAdaptor")
          xml.classId("value" => "vmCont")
          xml.classId("value" => "vmDC")
          xml.classId("value" => "vmDCOrg")
          xml.classId("value" => "vmDirCont")
          xml.classId("value" => "vmEp")
          xml.classId("value" => "vmHba")
          xml.classId("value" => "vmHv")
          xml.classId("value" => "vmInstance")
          xml.classId("value" => "vmLifeCyclePolicy")
          xml.classId("value" => "vmNic")
          xml.classId("value" => "vmOrg")
          xml.classId("value" => "vmSwitch")
          xml.classId("value" => "vmVif")
          xml.classId("value" => "vmVirtual")
          xml.classId("value" => "vmVlan")
          xml.classId("value" => "vmVnicProfCl")
          xml.classId("value" => "vmVnicProfInst")
          xml.classId("value" => "vmVsan")
        } 
       }
    end

    #End Build Multi-Class XML

    ucs_multi_class_XML = xml_builder.to_xml.to_s
    ucs_response_multi_class = RestClient.post(url, ucs_multi_class_XML, :content_type => 'text/xml').body

     #Uncomment the following to create a dump to review and debug elements
     # fh = File.new("ucs_response_multiclass.xml", "w")
     # fh.puts ucs_response_multi_class.inspect 
     # fh.close
     
     return Nokogiri::XML(ucs_response_multi_class)
     
  end
  
  
  def list_blades(ucs_multi_class_xml)
    
    ucs_multi_class_xml.xpath("configResolveClasses/outConfigs/computeBlade").each do |blade|
             
        puts "Blade : #{blade.attributes["serverId"]} model: #{blade.attributes["model"]}" \
             " with serial: #{blade.attributes["serial"]} is powered: #{blade.attributes["operPower"]}"
        
    end
    
  end
  
  def list_vsans(ucs_multi_class_xml)

     ucs_multi_class_xml.xpath("configResolveClasses/outConfigs/fabricVsan").each do |fabricvsan|
       
       puts "VSAN: #{fabricvsan.attributes["fcoeVlan"]} with FCoE ID: #{fabricvsan.attributes["id"]}" \
            " status: #{fabricvsan.attributes["operState"]}"
    end

  end
  
  def list_vlans(ucs_multi_class_xml)

    ucs_multi_class_xml.xpath("configResolveClasses/outConfigs/fabricVlan").each do |fabricvlan|

      puts "VLAN: #{fabricvlan.attributes["id"]} with name: #{fabricvlan.attributes["name"]}"

    end
    
  end
  
  def list_cpus(ucs_multi_class_xml)

    ucs_multi_class_xml.xpath("configResolveClasses/outConfigs/processorUnit").each do |processorunit|

     puts "CPU model: #{processorunit.attributes["model"]} Architecture: #{processorunit.attributes["arch"]} with #{processorunit.attributes["cores"]}" \
          "cores with #{processorunit.attributes["coresEnabled"]} enabled ID: #{processorunit.attributes["id"]} Speed: #{processorunit.attributes["speed"]}" \
          "Threads: #{processorunit.attributes["threads"]} Vendor: #{processorunit.attributes["vendor"]}"

    end

  end
  
  def list_memory(ucs_multi_class_xml)

    ucs_multi_class_xml.xpath("configResolveClasses/outConfigs/computeBlade").each do |blade|

      puts "Available Memory: #{blade.attributes["availableMemory"]} Total Memory: #{blade.attributes["totalMemory"]} Speed: #{blade.attributes["memorySpeed"]}"

    end
    
  end
  
  def list_service_profiles(ucs_multi_class_xml)
    
    ucs_multi_class_xml.xpath("configResolveClasses/outConfigs/lsServer").each do |serviceprofile|

       puts "Service Profile: #{serviceprofile.attributes["name"]} in #{serviceprofile.attributes["dn"]} with UUID #{serviceprofile.attributes["uuid"]}" \
            " is: #{serviceprofile.attributes["assocState"]}"

    end
    
  end
  
  def list_running_firmware(ucs_multi_class_xml)

    ucs_multi_class_xml.xpath("configResolveClasses/outConfigs/firmwareRunning").each do |firmware|

      puts "Firmware: #{firmware.attributes["dn"]} version #{firmware.attributes["packageVersion"]} package version" \
           " #{firmware.attributes["packageVersion"]} type #{firmware.attributes["type"]}"

    end

  end
  
end