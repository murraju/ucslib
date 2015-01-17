# Author:: Murali Raju (<murali.raju@appliv.com>)
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
# This section was contributed by Mark Plaksin https://www.linkedin.com/in/happymcplaksin. Thanks Mark!

#UCSM API Session management

module Stats

    STATNAMES = %w(adaptorEthPortStats adaptorEthPortErrStats adaptorEthPortMcastStats adaptorVnicStats computeMbPowerStats computeMbTempStats computePCIeFatalStats computePCIeFatalCompletionStats computePCIeFatalProtocolStats computePCIeFatalReceiveStats equipmentChassisStats equipmentFanStats equipmentFanModuleStats equipmentIOCardStats equipmentNetworkElementFanStats equipmentPsuStats equipmentPsuInputStats etherErrStats etherLossStats etherPauseStats etherRxStats etherTxStats fcStats fcErrStats memoryArrayEnvStats memoryErrorStats memoryUnitEnvStats processorEnvStats processorErrorStats swEnvStats swSystemStats)

    def fetch(tokenjson)
        cookie 	 = "#{JSON.parse(tokenjson)['cookie']}"
        ip       = "#{JSON.parse(tokenjson)['ip']}"
        url 	   = "https://#{ip}/nuova"

        #Start Build the Multi-Class XML

        # Note, the list of stats was gathered by changing hierarchical to "true" in
        # inventory.rb, pointing at UCS and then searching the 10M XML for 'Stats' :)
        #
        # Like this:
        # tr '>' '\n' < /tmp/ucs-play.xml | grep Stats | grep -v Policy | awk '{print $1}' | sort -u | grep -v / | tr -d '<' | grep -v Hist
        xml_builder = Nokogiri::XML::Builder.new do |xml|
            xml.configResolveClasses('cookie' => cookie, 'inHierarchical' => 'false') {
                xml.inIds{
                    xml.classId("value" => "adaptorEthPortStats")
                    xml.classId("value" => "adaptorEthPortErrStats")
                    xml.classId("value" => "adaptorEthPortMcastStats")
                    xml.classId("value" => "adaptorVnicStats")
                    xml.classId("value" => "computeMbPowerStats")
                    xml.classId("value" => "computeMbTempStats")
                    xml.classId("value" => "computePCIeFatalStats")
                    xml.classId("value" => "computePCIeFatalCompletionStats")
                    xml.classId("value" => "computePCIeFatalProtocolStats")
                    xml.classId("value" => "computePCIeFatalReceiveStats")
                    xml.classId("value" => "equipmentChassisStats")
                    xml.classId("value" => "equipmentFanStats")
                    xml.classId("value" => "equipmentFanModuleStats")
                    xml.classId("value" => "equipmentIOCardStats")
                    xml.classId("value" => "equipmentNetworkElementFanStats")
                    xml.classId("value" => "equipmentPsuStats")
                    xml.classId("value" => "equipmentPsuInputStats")
                    xml.classId("value" => "etherErrStats")
                    xml.classId("value" => "etherLossStats")
                    xml.classId("value" => "etherPauseStats")
                    xml.classId("value" => "etherRxStats")
                    xml.classId("value" => "etherTxStats")
                    xml.classId("value" => "fcStats")
                    xml.classId("value" => "fcErrStats")
                    xml.classId("value" => "memoryArrayEnvStats")
                    xml.classId("value" => "memoryErrorStats")
                    xml.classId("value" => "memoryUnitEnvStats")
                    xml.classId("value" => "processorEnvStats")
                    xml.classId("value" => "processorErrorStats")
                    xml.classId("value" => "swEnvStats")
                    xml.classId("value" => "swSystemStats")
                }
            }
        end
        #End Build Multi-Class XML

        ucs_multi_class_XML = xml_builder.to_xml.to_s
        rest_post(ucs_multi_class_XML,@url)

        #Uncomment the following to create a dump to review and debug elements
        # fh = File.new("ucs_response_multiclass.xml", "w")
        # fh.puts ucs_response_multi_class.inspect
        # fh.close
        return Nokogiri::XML(ucs_response_multi_class)
    end

    # Translate stats XML into a hash.
    #
    # If statname is supplied, only include that stat.  Otherwise, include
    # all stats.
    #
    # Hash looks like hash[statname][dn][attribute] = value
    def get_hash(xml,statname=:all)
        statnames = STATNAMES if statname == :all

        h = Hash.new{|k,v| k[v] = Hash.new}
        statnames.each do |statname|
            xml.xpath("configResolveClasses/outConfigs/#{statname}").each do |stat|
                dn = stat.attributes['dn'].value
                h[statname][dn] = Hash.new
                stat.attributes.each do |attr,value|
                    next if attr == 'dn'
                    h[statname][dn][attr] = value.value
                end
            end
        end
        return h
    end

    def show_sample(xml,statname,all=false)
        list = xml.xpath("configResolveClasses/outConfigs/#{statname}")
        list = [list.first] unless all
        list.each do |i|
            show_attributes(i)
        end
    end

    def show_all(xml,statname)
        show_sample(xml,statname,true)
    end

    private
    def show_attributes(item)
        print "The attributes for #{item.name} for dn=#{item.attributes['dn']} are:\n"
        item.attributes.keys.each do |attr|
            next if attr == 'dn'
            print "  #{attr} = #{item.attributes[attr]}\n"
        end
    end
end
