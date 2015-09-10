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


module Faults

  # Archive code. To be removed later #TODO
  # def discover(tokenjson)

  #   @cookie   = "#{JSON.parse(tokenjson)['cookie']}"
  #   ip       = "#{JSON.parse(tokenjson)['ip']}"
  #   @url      = "https://#{ip}/nuova"

  def faults(token)

    #Start Build the Multi-Class XML
    xml_builder = Nokogiri::XML::Builder.new do |xml|
       xml.configResolveClasses('cookie' => @cookie, 'inHierarchical' => 'false') {
        xml.inIds{
          xml.classId("value" => "faultInst")
        }
       }
    end

    #End Build Multi-Class XML

    ucs_multi_class_XML = xml_builder.to_xml.to_s
    ucs_response_multi_class = rest_post(ucs_multi_class_XML,@url)

     #Uncomment the following to create a dump to review and debug elements
     # fh = File.new("ucs_response_multiclass.xml", "w")
     # fh.puts ucs_response_multi_class.inspect
     # fh.close

     return Nokogiri::XML(ucs_response_multi_class)

  end

  # Translate faults XML into a hash.
  #
  # Hash looks like hash[fault_code][dn][attribute] = value
  def get_faults_hash(xml)
      
      h = Hash.new{|k,v| k[v] = Hash.new}
      xml.xpath("configResolveClasses/outConfigs/faultInst").each do |fault|
          code = fault.attributes['code'].value
          dn = fault.attributes['dn'].value
          h[code][dn] = Hash.new
          fault.attributes.each do |attr,value|
              next if attr == 'dn'
              h[code][dn][attr] = value.value
          end
      end
      
      return h
      
  end

  def list_faults(ucs_multi_class_xml)
      
    ucs_multi_class_xml.xpath("configResolveClasses/outConfigs/faultInst").each do |fault|
        
        puts "Fault: #{fault.attributes["id"]} severity: #{fault.attributes["highestSeverity"]}" \
             " acknowledged: #{fault.attributes["ack"]} cause: #{fault.attributes["cause"]}"
             
    end
    
  end
  
end
