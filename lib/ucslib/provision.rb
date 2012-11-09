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

class UCSProvision

	  def initialize(tokenjson)
    
	    @cookie  = "#{JSON.parse(tokenjson)['cookie']}"
	    ip       = "#{JSON.parse(tokenjson)['ip']}"
	    @url 	 = "https://#{ip}/nuova"

	  end

    def set_org(json)

      org = JSON.parse(json)['org']
      description = JSON.parse(json)['description']

      xml_builder = Nokogiri::XML::Builder.new do |xml|
      xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true') {
        xml.inConfigs{
          xml.pair('key' => "org-root/org-#{org}") {
            xml.orgOrg('descr' => "#{description}", 'dn' => "org-root/org-#{org}", 'name' => "#{org}", 'status' => 'created')
          }
        }
      }
      end

      #Create xml
      set_org_xml= xml_builder.to_xml.to_s

      #Post

      begin
        RestClient.post(@url, set_org_xml, :content_type => 'text/xml').body
      rescue Exception => e
        raise "Error #{e}"
      end     

    end

	  def set_power_policy(json)
		
  		power_policy = "#{JSON.parse(json)['power_policy']}"

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		    xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'false') {
  		      xml.inConfigs{
  		        xml.pair('key' => 'org-root/psu-policy'){
  		          xml.computePsuPolicy('descr' => '', 'dn' => 'org-root/psu-policy', 'redundancy' => "#{power_policy}")
  		        }
  		      }
  		    }
  			end

  		set_power_policy_xml = xml_builder.to_xml.to_s

  		#Post
  		begin	
  			RestClient.post(@url, set_power_policy_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

	  end

    def set_chassis_discovery_policy(json)
    	
      chassis_discovery_policy = "#{JSON.parse(json)['chassis_discovery_policy']}"

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'false') {
  		  xml.inConfigs{
  		    xml.pair('key' => 'org-root/chassis-discovery'){
  		      xml.computeChassisDiscPolicy( 'action' => "#{chassis_discovery_policy}", 'descr' => '', 'dn' => 'org-root/chassis-discovery', 
  		                                    'name' => '', 'rebalance' => 'user-acknowledged')
  		    }
  		  }
  		}
  		end

  		set_chassis_discovery_policy_xml = xml_builder.to_xml.to_s

  		#Post

  		begin
  			RestClient.post(@url, set_chassis_discovery_policy_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

	  end


    def set_time_zone(json)

  		time_zone = "#{JSON.parse(json)['time_zone']}"

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'false'){
  		  xml.inConfigs{
  		    xml.pair('key' => 'sys/svc-ext/datetime-svc'){
  		      xml.commDateTime('adminState' => 'enabled', 'descr' => '', 'dn' => 'sys/svc-ext/datetime-svc', 'port' => '0', 'status' => 'modified', 
  		                   'timezone' => "#{time_zone}")
  		    }
  		  } 
  		}
  		end

  		set_time_zone_xml = xml_builder.to_xml.to_s

  		#Post

  		begin
  			RestClient.post(@url, set_time_zone_xml, :content_type => 'text/xml').body		
  		rescue Exception => e
  			raise "Error #{e}"
  		end

    end

    def set_ntp_server(json)

  		ntp_server = "#{JSON.parse(json)['ntp_server']}"

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'false'){
  		  xml.inConfigs{
  		    xml.pair('key' => "sys/svc-ext/datetime-svc/ntp-#{ntp_server}"){
  		      xml.commNtpProvider('descr' => '', 'dn' => "sys/svc-ext/datetime-svc/ntp-#{ntp_server}", 'name' => "#{ntp_server}", 'status' => 'created' )
  		    }
  		  }
  		}
  		end

  		set_ntp_xml = xml_builder.to_xml.to_s

  		#Post

  		begin
  			RestClient.post(@url, set_ntp_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

    end


    def set_local_disk_policy(json)

      local_disk_policy   = JSON.parse(json)['local_disk_policy']
      org                 = JSON.parse(json)['org']

      xml_builder = Nokogiri::XML::Builder.new do |xml|
      xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
        xml.inConfigs{
          xml.pair('key' => "org-root/org-#{org}/local-disk-config-#{org}-localdisk"){
            xml.storageLocalDiskConfigPolicy('descr' => '', 'dn' => "org-root/org-#{org}/local-disk-config-#{org}-localdisk", 
                                             'mode' => "#{local_disk_policy}", 'name' => "#{org}-localdisk", 'protectConfig' => 'yes',
                                             'status' => 'created')
          }
        }
      }
      end

      #Create xml
      set_local_disk_policy_xml = xml_builder.to_xml.to_s

      #Post
      begin
        RestClient.post(@url, set_local_disk_policy_xml, :content_type => 'text/xml').body
      rescue Exception => e
        raise "Error #{e}"
      end
    
    end


	  def set_server_port(json)

  		switch = JSON.parse(json)['switch']
  		port   = JSON.parse(json)['port']
  		slot   = JSON.parse(json)['slot']


  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'false'){
  		  xml.inConfigs{
  		    xml.pair('key' => "fabric/server/SW-#{switch}"){
  		      xml.fabricDceSwSrv('dn' => "fabric/server/SW-#{switch}", 'status' => 'created,modified'){
  		        xml.fabricDceSwSrvEp( 'adminState' => 'enabled', 'name' => '', 'portId' => "#{port}", 
  		                              'rn' => "slot" + "-" + "#{slot}" + "-" + "port" + "-" + "#{port}", 'slotId' => "#{slot}", 
  		                              'status' => 'created', 'usrLbl' => '' )
  		      }
  		    }
  		  }
  		}
  		end

  		#Create xml 
  		set_server_port_xml = xml_builder.to_xml.to_s

  		#Post

  		begin
  			RestClient.post(@url, set_server_port_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

	  end

    def set_network_uplink_port(json)

  		switch = JSON.parse(json)['switch']
  		port   = JSON.parse(json)['port']
  		slot   = JSON.parse(json)['slot']    	

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'false'){
  		xml.inConfigs{
  		 xml.pair('key' => "fabric/lan/#{switch}"){
  		   xml.fabricEthLan('dn' => "fabric/lan/#{switch}", 'status' => 'created,modified'){
  		     xml.fabricEthLanEp('adminSpeed' => '10gbps', 'adminState' => 'enabled', 'flowCtrlPolicy' => 'default',
  		                        'name' => '', 'portId' => "#{port}", 
  		                        'rn' => "phys" + "-" + "slot" + "-" + "#{slot}" + "-" + "port" + "-" + "#{port}",
  		                        'slotId' => "#{slot}", 'status' => 'created', 'usrLbl' => '')
  		   			}
  		 		}
  			}
  		}
  		end

  		#Create xml 
  		set_network_uplink_xml = xml_builder.to_xml.to_s

  		#Post

  		begin
  			RestClient.post(@url, set_network_uplink_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

    end


    def set_fc_uplink_port(json)

  		switch = JSON.parse(json)['switch']
  		port   = JSON.parse(json)['port']
  		slot   = JSON.parse(json)['slot']  

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		 xml.configConfMos('cookie' => "#{@ucs_cookie}", 'inHierarchical' => 'false'){
  		   xml.inConfigs{
  		     xml.pair('key' => "fabric/san/#{switch}/phys" + "-" + "slot" + "-" + "#{slot}" + "-" + "port" + "-" + "#{port}"){
  		       xml.fabricFcSanEp('adminState' => 'enabled', 'dn' => "fabric/san/#{switch}/phys" + "-" + "slot" + "-" + "#{slot}" + "-" + 
  		                         "port" + "-" + "#{port}" )
  		     }
  		   }
  		 }
  		end

  		#Create xml 
  		set_fc_uplink_xml = xml_builder.to_xml.to_s

  		#Post
  		begin
  			RestClient.post(@url, set_fc_uplink_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

    end


    def set_port_channel(json)
  		#Parse uplink modules on Expansion Module 2. Minimum 2 ports are required for creating a port channel.
  		#As of this implementation, it is assumed that Northboutn uplinks are created using the Expansion Module and not the fixed module

  		switch            = JSON.parse(json)['switch']
  		port_ids          = JSON.parse(json)['port_ids'].split(',')
  		slot              = JSON.parse(json)['slot']
  		port_channel_id   = JSON.parse(json)['port_channel_id']
  		name              = JSON.parse(json)['name']


  		#Create xml
  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		 xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
  		   xml.inConfigs{
  		     xml.pair('key' => "fabric/lan/#{switch}/pc-#{port_channel_id}"){
  		       xml.fabricEthLanPc('adminSpeed' => '10gbps', 'adminState' => 'enabled', 'dn' => "fabric/lan/#{switch}/pc-#{port_channel_id}",
  		                          'flowCtrlPolicy' => 'default', 'name' => "#{name}", 'operSpeed' => '10gbps', 'portId' => "#{port_channel_id}",
  		                          'status' => 'created'){
  		                              port_ids.each do |port_id|
  		                                xml.fabricEthLanPcEp('adminState' => 'enabled', 'name' => '', 'portId' => "#{port_id}", 
  		                                                      'rn' => "ep-slot-#{slot}-port-#{port_id}")
  		                              end
  		                          }

  		     }
  		   }
  		 }
  		end

  		#Create xml
  		set_port_channel_xml = xml_builder.to_xml.to_s

  		#Post
  		begin
  			RestClient.post(@url, set_port_channel_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

	  end

    def set_local_boot_policy(json)

  		name             = JSON.parse(json)['name']
  		description      = JSON.parse(json)['description']
  		org              = JSON.parse(json)['org']

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
  		  xml.inConfigs{
  		    xml.pair('key' => "org-root/org-#{org}/boot-policy-#{name}"){
  		      xml.lsbootPolicy('descr' => "#{description}", 'dn' => "org-root/org-#{org}/boot-policy-#{name}",
  		                       'enforceVnicName' => 'no', 'name' => "#{name}", 'rebootOnUpdate' => 'no',
  		                       'status' => 'created'){
  		                         xml.lsbootVirtualMedia('access' => 'read-only', 'order' => '1', 'rn' => 'read-only-vm', 'status' => 'created')
  		                         xml.lsbootStorage('order' => '2', 'rn' => 'storage', 'status' => 'created'){
  		                           xml.lsbootLocalStorage('rn' => 'local-storage', 'status' => 'created')
  		                         }
  		                       }
  		    }
  		  }
  		}
  		end

  		#Create xml
  		set_local_boot_policy_xml = xml_builder.to_xml.to_s

  		#Post
  		begin
  			RestClient.post(@url, set_local_boot_policy_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

    end

    def set_pxe_boot_policy(json)

  		name           = JSON.parse(json)['name']
  		description    = JSON.parse(json)['description']
  		org            = JSON.parse(json)['org']
  		vnic_a         = JSON.parse(json)['vnic_a']
  		vnic_b         = JSON.parse(json)['vnic_b']

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
  		  xml.inConfigs{
  		    xml.pair('key' => "org-root/org-#{org}/boot-policy-#{name}"){
  		      xml.lsbootPolicy('descr' => "#{description}", 'dn' => "org-root/org-#{org}/boot-policy-#{name}",
  		                       'enforceVnicName' => 'no', 'name' => "#{name}", 'rebootOnUpdate' => 'no',
  		                       'status' => 'created'){
  		                         xml.lsbootLan('order' => '1', 'rn' => 'lan'){
  		                           xml.lsbootLanImagePath('rn' => 'path-primary', 'status' => 'created',
  		                                                  'type' => 'primary', 'vnicName' => "#{vnic_a}")
  		                           xml.lsbootLanImagePath('rn' => 'path-secondary', 'status' => 'created',
  		                                                  'type' => 'secondary', 'vnicName' => "#{vnic_b}")
  		                         }
  		                         xml.lsbootStorage('order' => '2', 'rn' => 'storage', 'status' => 'created'){
  		                           xml.lsbootLocalStorage('rn' => 'local-storage', 'status' => 'created')
  		                         }
  		                       }
  		    }
  		  }
  		}
  		end

  		#Create xml
  		set_pxe_boot_policy_xml = xml_builder.to_xml.to_s

  		#Post
  		begin
  			RestClient.post(@url, set_pxe_boot_policy_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

    end

  	def set_san_boot_policy(json)

  		name         = JSON.parse(json)['name']
  		description  = JSON.parse(json)['description']
  		org          = JSON.parse(json)['org']
  		vnic_a       = JSON.parse(json)['vhba_a']
  		vnic_b       = JSON.parse(json)['vhba_b']
  		target_a_1   = JSON.parse(json)['target_a_1']
  		target_a_2   = JSON.parse(json)['target_a_2']
  		target_b_1   = JSON.parse(json)['target_b_1']
  		target_b_2   = JSON.parse(json)['target_b_2']

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		   xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
  		     xml.inConfigs{
  		       xml.pair('key' => "org-root/org-#{org}/boot-policy-#{name}"){
  		         xml.lsbootPolicy('descr' => "#{description}", 'dn' => "org-root/org-#{org}/boot-policy-#{name}", 'enforceVnicName' => 'no',
  		                          'name' => "#{name}", 'rebootOnUpdate' => 'no', 'status' => 'created'){
  		                            xml.lsbootStorage('order' => '1', 'rn' => 'storage'){
  		                              xml.lsbootSanImage('rn' => 'san-primary', 'status' => 'created', 'type' => 'primary', 'vnicName' => "#{vnic_a}"){
  		                                xml.lsbootSanImagePath('lun' => '0', 'rn' => 'path-primary', 'status' => 'created', 'type' => 'primary', 'wwn' => "#{target_a_1}")
  		                                xml.lsbootSanImagePath('lun' => '0', 'rn' => 'path-secondary', 'status' => 'created', 'type' => 'secondary', 'wwn' => "#{target_a_2}")
  		                              }
  		                              xml.lsbootSanImage('rn' => 'san-secondary', 'status' => 'created', 'type' => 'secondary', 'vnicName' => "#{vnic_b}"){
  		                                xml.lsbootSanImagePath('lun' => '0', 'rn' => 'path-primary', 'status' => 'created', 'type' => 'primary', 'wwn' => "#{target_b_1}")
  		                                xml.lsbootSanImagePath('lun' => '0', 'rn' => 'path-secondary', 'status' => 'created', 'type' => 'secondary', 'wwn' => "#{target_b_2}")
  		                              }
  		                            }
  		                          }
  		       }
  		     }
  		   }
  		end

  		#Create xml
  		set_san_boot_policy_xml = xml_builder.to_xml.to_s

  		#Post
  		begin
  			RestClient.post(@url, set_san_boot_policy_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

  	end


    def set_mgmt_firmware_package(json)
    
      mgmt_firmware_pkg_name        = JSON.parse(json)['mgmt_firmware_pkg_name']
      mgmt_firmware_pkg_description = JSON.parse(json)['mgmt_firmware_pkg_description']
      hardware_model                = JSON.parse(json)['hardware_model'].to_s
      hardware_type                 = JSON.parse(json)['hardware_type']
      hardware_vendor               = JSON.parse(json)['hardware_vendor'].to_s
      firmware_version              = JSON.parse(json)['firmware_version'].to_s
      org                           = JSON.parse(json)['org']

    
      xml_builder = Nokogiri::XML::Builder.new do |xml|
        xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
          xml.inConfigs{
            xml.pair('key' => "org-root/org-#{org}/fw-mgmt-pack-#{mgmt_firmware_pkg_name}"){
              xml.firmwareComputeMgmtPack('descr' => "#{mgmt_firmware_pkg_description}", 'dn' => "org-root/org-#{org}/fw-mgmt-pack-#{mgmt_firmware_pkg_name}",
                                         'ignoreCompCheck' => 'yes', 'mode' => 'staged', 'name' => "#{mgmt_firmware_pkg_name}", 'stageSize' => '0',
                                         'status' => 'created', 'updateTrigger' => 'immediate'){
                                           xml.firmwarePackItem('hwModel' => "#{hardware_model}", 'hwVendor' => "#{hardware_vendor}",
                                                                'rn' => "pack-image-#{hardware_vendor}|#{hardware_model}|#{hardware_type}",
                                                                'type' => "#{hardware_type}", 'version' => "#{firmware_version}")
                                         }
            }
          }
        }
      end


      #Create xml

      set_mgmt_firmware_packagexml = xml_builder.to_xml.to_s

      #Post

      begin
        RestClient.post(@url, set_mgmt_firmware_packagexml, :content_type => 'text/xml').body
      rescue Exception => e
        raise "Error #{e}"
      end

    end

    def set_host_firmware_package(json)
    
  		host_firmware_pkg_name        = JSON.parse(json)['host_firmware_pkg_name']
      host_firmware_pkg_description = JSON.parse(json)['host_firmware_pkg_description']
  		hardware_model                = JSON.parse(json)['hardware_model'].to_s
  		hardware_type                 = JSON.parse(json)['hardware_type']
  		hardware_vendor               = JSON.parse(json)['hardware_vendor'].to_s
  		firmware_version              = JSON.parse(json)['firmware_version'].to_s
  		org                           = JSON.parse(json)['org']
      flag                          = JSON.parse(json)['flag']

      unless flag == 'update'
	  
        xml_builder = Nokogiri::XML::Builder.new do |xml|
          xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
            xml.inConfigs{
              xml.pair('key' => "org-root/org-#{org}/fw-host-pack-#{host_firmware_pkg_name}"){
                xml.firmwareComputeHostPack('descr' => "#{host_firmware_pkg_description}", 'dn' => "org-root/org-#{org}/fw-host-pack-#{host_firmware_pkg_name}",
                                           'ignoreCompCheck' => 'yes', 'mode' => 'staged', 'name' => "#{host_firmware_pkg_name}", 'stageSize' => '0',
                                           'status' => 'created', 'updateTrigger' => 'immediate'){
                                             xml.firmwarePackItem('hwModel' => "#{hardware_model}", 'hwVendor' => "#{hardware_vendor}",
                                                                  'rn' => "pack-image-#{hardware_vendor}|#{hardware_model}|#{hardware_type}",
                                                                  'type' => "#{hardware_type}", 'version' => "#{firmware_version}")
                                           }
              }
            }
          }
        end

      else

        xml_builder = Nokogiri::XML::Builder.new do |xml|
          xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'false'){
            xml.inConfigs{
              xml.pair('key' => "org-root/org-#{org}/fw-host-pack-#{host_firmware_pkg_name}"){
                xml.firmwareComputeHostPack('descr' => "#{host_firmware_pkg_description}", 'dn' => "org-root/org-#{org}/fw-host-pack-#{host_firmware_pkg_name}",
                                            'ignoreCompCheck' => 'yes', 'mode' => 'staged', 'stageSize' => '0', 'updateTrigger' => 'immediate'){
                                             xml.firmwarePackItem('hwModel' => "#{hardware_model}", 'hwVendor' => "#{hardware_vendor}",
                                                                  'rn' => "pack-image-#{hardware_vendor}|#{hardware_model}|#{hardware_type}",
                                                                  'type' => "#{hardware_type}", 'version' => "#{firmware_version}")
                                           }
              }
            }
          }
        end

      end


      #Create xml

      set_host_firmware_packagexml = xml_builder.to_xml.to_s

      #Post

      begin
        RestClient.post(@url, set_host_firmware_packagexml, :content_type => 'text/xml').body
      rescue Exception => e
        raise "Error #{e}"
      end

    end

    def set_management_ip_pool(json)

  		start_ip 	  = JSON.parse(json)['start_ip']
  		end_ip   	  = JSON.parse(json)['end_ip']
  		subnet_mask = JSON.parse(json)['subnet_mask']
  		gateway  	  = JSON.parse(json)['gateway']

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
  		  xml.inConfigs{
  		    xml.pair('key' => "org-root/ip-pool-ext-mgmt/block-#{start_ip}-#{end_ip}"){
  		      xml.ippoolBlock('defGw' => "#{gateway}", 'dn' => "org-root/ip-pool-ext-mgmt/block-#{start_ip}-#{end_ip}",
  		                      'from' => "#{start_ip}", 'status' => 'created', 'subnet' => "#{subnet_mask}", 'to' => "#{end_ip}")
  		    }
  		  }
  		}
  		end

  		#Create xml
  		set_management_ip_pool_xml = xml_builder.to_xml.to_s

  		#Post
  		begin
  			RestClient.post(@url, set_management_ip_pool_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

    end

    def set_vlan(json)

  		vlan_id     = JSON.parse(json)['vlan_id']
  		vlan_name   = JSON.parse(json)['vlan_name']

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		  xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
  		    xml.inConfigs{
  		      xml.pair('key' => "fabric/lan/net-#{vlan_name}"){
  		        xml.fabricVlan('defaultNet' => 'no', 'dn' => "fabric/lan/net-#{vlan_name}", 'id' => "#{vlan_id}",
  		                       'name' => "#{vlan_name}", 'status' => 'created')
  		      }
  		    }
  		  }
  		end

  		#Create xml
  		set_vlan_xml = xml_builder.to_xml.to_s

  		#Post
  		begin
  			RestClient.post(@url, set_vlan_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

	  end

    def set_mac_pool(json)

    	mac_pool_name   = JSON.parse(json)['mac_pool_name']
    	mac_pool_start  = JSON.parse(json)['mac_pool_start']
    	#size            = JSON.parse(json)['size']
    	mac_pool_end    = JSON.parse(json)['mac_pool_end']
    	org    			= JSON.parse(json)['org']
	
    	# 
    	# def get_mac_pool_suffix(size)
    	#  mac_pool_size = size   
    	#  octets         = mac_pool_start.split(':')
    	#  octets[-1]     = (mac_pool_size - 1).to_s(base=16)
    	#  return mac_pool_end = octets.join(':')
    	# end
    	# 
    	# get_mac_pool_suffix(size)

    	xml_builder = Nokogiri::XML::Builder.new do |xml|
    	  xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
    	    xml.inConfigs{
    	      xml.pair('key' => "org-root/org-#{org}/mac-pool-#{mac_pool_name}"){
    	        xml.macpoolPool('descr' => '', 'dn' => "org-root/org-#{org}/mac-pool-#{mac_pool_name}", 'name' => "#{mac_pool_name}",
    	                        'status' => 'created'){
    	                          xml.macpoolBlock('from' => "#{mac_pool_start}", 'rn' => "block-#{mac_pool_start}-#{mac_pool_end}",
    	                                           'status' => 'created', 'to' => "#{mac_pool_end}")
    	                        }
    	      }
    	    }
    	  }

  	  end

  	  #Create xml
  		set_mac_pool_xml = xml_builder.to_xml.to_s

  		#Post
  		begin
  			RestClient.post(@url, set_mac_pool_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

    end

    def set_vnic_template(json)

		  vnic_template_name            = JSON.parse(json)['vnic_template_name']
		  vnic_template_mac_pool        = JSON.parse(json)['vnic_template_mac_pool']
		  switch               		      = JSON.parse(json)['switch']
		  org              			        = JSON.parse(json)['org']
		  vnic_template_VLANs           = JSON.parse(json)['vnic_template_VLANs'].split(',')
		  vnic_template_native_VLAN     = JSON.parse(json)['vnic_template_native_VLAN']
		  vnic_template_mtu             = JSON.parse(json)['vnic_template_mtu']


  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		  xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
  		    xml.inConfigs{
  		      xml.pair('key' => "org-root/org-#{org}/lan-conn-templ-#{vnic_template_name}"){
  		        xml.vnicLanConnTempl('descr' => '', 'dn' => "org-root/org-#{org}/lan-conn-templ-#{vnic_template_name}",
  		                             'identPoolName' => "#{vnic_template_mac_pool}", 'mtu' => "#{vnic_template_mtu}", 'name' => "#{vnic_template_name}",
  		                             'nwCtrlPolicyName' => '', 'pinToGroupName' => '', 'qosPolicyName' => '', 'statsPolicyName' => '',
  		                             'status' => 'created', 'switchId' => "#{switch}", 'templType' => 'updating-template'){
  		                               vnic_template_VLANs.each do |vlan|
  		                                 if vlan == vnic_template_native_VLAN
  		                                   xml.vnicEtherIf('defaultNet' => 'yes', 'name' => "#{vlan}", 'rn' => "if-#{vlan}")
  		                                 else
  		                                   xml.vnicEtherIf('defaultNet' => 'yes', 'name' => "#{vlan}", 'rn' => "if-#{vlan}")
  		                                 end
  		                               end
  		                             }
  		      }
  		    }
  		  }
  	  end

  		#Create xml
  		set_vnic_template_xml = xml_builder.to_xml.to_s

  		#Post
  		begin
  			RestClient.post(@url, set_vnic_template_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

    end


    def set_vsan(json)

  		vsan_id        = JSON.parse(json)['vsan_id']
  		vsan_fcoe_id   = JSON.parse(json)['vsan_fcoe_id']
  		vsan_name      = JSON.parse(json)['vsan_name']

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		  xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
  		    xml.inConfigs{
  		      xml.pair('key' => 'fabric/san/'){
  		        xml.fabricVsan('defaultZoning' => 'disabled', 'dn' => 'fabric/san/', 'fcoeVlan' => "#{vsan_fcoe_id}", 
  		                       'id' => "#{vsan_id}", 'name' => "#{vsan_name}", 'status' => 'created' )
  		      }
  		    }
  		  }
  		end

  		#Create xml
  		set_vsan_xml = xml_builder.to_xml.to_s

  		#Post
  		begin
  			RestClient.post(@url, set_vsan_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

	  end

    def set_wwnn_pool(json)

		 wwnn_name   = JSON.parse(json)['wwnn_name']
		 wwnn_from   = JSON.parse(json)['wwnn_from']
		 wwnn_to     = JSON.parse(json)['wwnn_to']
		 org    	 = JSON.parse(json)['org']

		 xml_builder = Nokogiri::XML::Builder.new do |xml|
		   xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
		     xml.inConfigs{
		       xml.pair('key' => "org-root/org-#{org}/wwn-pool-#{wwnn_name}"){
		         xml.fcpoolInitiators('descr' => '', 'dn' => "org-root/org-#{org}/wwn-pool-#{wwnn_name}", 'name' => "#{wwnn_name}",
		                              'purpose' => 'node-wwn-assignment', 'status' => 'created'){
		                                xml.fcpoolBlock('from' => "#{wwnn_from}", 'rn' => "block-#{wwnn_from}-#{wwnn_to}", 
		                                                'status' => 'created', 'to' => "#{wwnn_to}")
		                              }
		       }
		     }
		   }
		 end
		 #Create xml
		 set_wwnn_pool_xml = xml_builder.to_xml.to_s

		 #Post
		 begin
		 	RestClient.post(@url, set_wwnn_pool_xml, :content_type => 'text/xml').body
		 rescue Exception => e
		 	raise "Error #{e}"
		 end

    end

    def set_wwpn_pool(json)

		 wwpn_name   = JSON.parse(json)['wwpn_name']
		 wwpn_from   = JSON.parse(json)['wwpn_from']
		 wwpn_to     = JSON.parse(json)['wwpn_to']
		 org    	   = JSON.parse(json)['org']

		 xml_builder = Nokogiri::XML::Builder.new do |xml|
		   xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
		     xml.inConfigs{
		       xml.pair('key' => "org-root/org-#{org}/wwn-pool-#{wwpn_name}"){
		         xml.fcpoolInitiators('descr' => '', 'dn' => "org-root/org-#{org}/wwn-pool-#{wwpn_name}",
		                              'name' => "#{wwpn_name}", 'purpose' => 'port-wwn-assignment', 'status' => 'created'){
		                                xml.fcpoolBlock('from' => "#{wwpn_from}", 'rn' => "block-#{wwpn_from}-#{wwpn_to}",
		                                                'status' => 'created', 'to' => "#{wwpn_to}")
		                              }
		       }
		     }
		   }
		 end


		 #Create xml
		 set_wwpn_pool_xml = xml_builder.to_xml.to_s

		 #Post
		 begin
		 	RestClient.post(@url, set_wwpn_pool_xml, :content_type => 'text/xml').body
		 rescue Exception => e
		 	raise "Error #{e}"
		 end

    end

    def set_vhba_template(json)

  		vhba_template_name = JSON.parse(json)['vhba_template_name']
  		wwpn_pool          = JSON.parse(json)['wwpn_pool']
  		switch             = JSON.parse(json)['switch']
  		vsan_name          = JSON.parse(json)['vsan_name']
  		org  			         = JSON.parse(json)['org']
      description        = JSON.parse(json)['description']

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		  xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
  		    xml.inConfigs{
  		      xml.pair('key' => "org-root/org-#{org}/san-conn-templ-#{vhba_template_name}"){
  		        xml.vnicSanConnTempl('descr' => "#{description}", 'dn' => "org-root/org-#{org}/san-conn-templ-#{vhba_template_name}",
  		                             'identPoolName' => "#{wwpn_pool}", 'maxDataFieldSize' => '2048', 'name' => "#{vhba_template_name}",
  		                             'pinToGroupName' => '', 'qosPolicyName' => '', 'statsPolicyName' => 'default', 'status' => 'created',
  		                             'switchId' => "#{switch}", 'templType' => 'updating-template'){
  		                               xml.vnicFcIf('name' => "#{vsan_name}", 'rn' => 'if-default')
  		                             }
  		      }
  		    }
  		  }
  		end

  		#Create xml
  		set_vhba_template_xml = xml_builder.to_xml.to_s

  		#Post
  		begin
  			RestClient.post(@url, set_vhba_template_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end

    end

    def set_uuid_pool(json)

  		uuid_pool_name     = JSON.parse(json)['uuid_pool_name']
  		uuid_from          = JSON.parse(json)['uuid_from']
  		uuid_to            = JSON.parse(json)['uuid_to']
  		org           	   = JSON.parse(json)['org']

  		xml_builder = Nokogiri::XML::Builder.new do |xml|
  		  xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
  		    xml.inConfigs{
  		      xml.pair('key' => "org-root/org-#{org}/uuid-pool-#{uuid_pool_name}"){
  		        xml.uuidpoolPool('descr' => '', 'dn' => "org-root/org-#{org}/uuid-pool-#{uuid_pool_name}",
  		                         'name' => "#{uuid_pool_name}", 'prefix' => 'derived', 'status' => 'created'){
  		                           xml.uuidpoolBlock('from' => "#{uuid_from}", 'rn' => "block-from-#{uuid_from}-to-#{uuid_to}",
  		                                             'status' => 'created', 'to' => "#{uuid_to}")
  		                         }
  		      }
  		    }
  		  }
  		end

  		#Create xml
  		set_uuid_pool_xml = xml_builder.to_xml.to_s

  		#Post
  		begin
  			RestClient.post(@url, set_uuid_pool_xml, :content_type => 'text/xml').body
  		rescue Exception => e
  			raise "Error #{e}"
  		end
		 
    end

    def set_service_profile_template(json)

		 service_profile_template_name               = JSON.parse(json)['service_profile_template_name']
		 service_profile_template_boot_policy        = JSON.parse(json)['service_profile_template_boot_policy']
		 service_profile_template_host_fw_policy     = JSON.parse(json)['service_profile_template_host_fw_policy']
		 service_profile_template_mgmt_fw_policy     = JSON.parse(json)['service_profile_template_mgmt_fw_policy']
		 service_profile_template_uuid_pool          = JSON.parse(json)['service_profile_template_uuid_pool']
		 service_profile_template_vnics_a            = JSON.parse(json)['service_profile_template_vnics_a'].split(',')
		 service_profile_template_vnic_a_template    = JSON.parse(json)['service_profile_template_vnic_a_template']
		 service_profile_template_vnics_b            = JSON.parse(json)['service_profile_template_vnics_b'].split(',')
		 service_profile_template_vnic_b_template    = JSON.parse(json)['service_profile_template_vnic_b_template'].to_s
		 service_profile_template_wwnn_pool          = JSON.parse(json)['service_profile_template_wwnn_pool'].to_s
		 service_profile_template_vhba_a             = JSON.parse(json)['service_profile_template_vhba_a']
		 service_profile_template_vhba_a_template    = JSON.parse(json)['service_profile_template_vhba_a_template']
		 service_profile_template_vhba_b             = JSON.parse(json)['service_profile_template_vhba_b'].to_s
		 service_profile_template_vhba_b_template    = JSON.parse(json)['service_profile_template_vhba_b_template'].to_s
		 org                						             = JSON.parse(json)['org'].to_s

		 xml_builder = Nokogiri::XML::Builder.new do |xml|
		   xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
		     xml.inConfigs{
		       xml.pair('key' => "org-root/org-#{org}/ls-#{service_profile_template_name}"){
		         xml.lsServer('agentPolicyName' => '', 'biosProfileName' => '', 'bootPolicyName' => "#{service_profile_template_boot_policy}",
		                      'descr' => '', 'dn' => "org-root/org-#{org}/ls-#{service_profile_template_name}",
		                      'dynamicConPolicyName' => '', 'extIPState' => 'none', 'hostFwPolicyName' => "#{service_profile_template_host_fw_policy}",
		                      'identPoolName' => "#{service_profile_template_uuid_pool}", 'localDiskPolicyName' => 'default', 'maintPolicyName' => 'default',
		                      'mgmtAccessPolicyName' => '', 'mgmtFwPolicyName' => "#{service_profile_template_mgmt_fw_policy}", 'name' => "#{service_profile_template_name}",
		                      'powerPolicyName' => 'default', 'scrubPolicyName' => '', 'solPolicyName' => 'default', 'srcTemplName' => '', 'statsPolicyName' => 'default',
		                      'status' => 'created', 'type' => 'updating-template', 'usrLbl' => '', 'uuid' => '0', 'vconProfileName' => ''){
		                       service_profile_template_vnics_a.each do |vnic_a|  
		                        xml.vnicEther('adaptorProfileName' => '', 'addr' => 'derived', 'adminVcon' => 'any', 'identPoolName' => '', 'mtu' => '1500',
		                                      'name' => "#{vnic_a}", 'nwCtrlPolicyName' => '', 'nwTemplName' => "#{service_profile_template_vnic_a_template}",
		                                      'order' => '3', 'pinToGroupName' => '', 'qosPolicyName' => '', 'rn' => "ether-#{vnic_a}",
		                                      'statsPolicyName' => 'default', 'status' => 'created', 'switchId' => 'A')
		                       end
							  service_profile_template_vnics_b.each do |vnic_b|               
		                        xml.vnicEther('adaptorProfileName' => '', 'addr' => 'derived', 'adminVcon' => 'any', 'identPoolName' => '', 'mtu' => '1500',
		                                      'name' => "#{vnic_b}", 'nwCtrlPolicyName' => '', 'nwTemplName' => "#{service_profile_template_vnic_b_template}",
		                                      'order' => '4', 'pinToGroupName' => '', 'qosPolicyName' => '', 'rn' => "ether-#{vnic_b}",
		                                      'statsPolicyName' => 'default', 'status' => 'created', 'switchId' => 'B')
		                       end              
		                        xml.vnicFcNode('addr' => 'pool-derived', 'identPoolName' => "#{service_profile_template_wwnn_pool}", 'rn' => 'fc-node')

		                        xml.vnicFc('adaptorProfileName' => '', 'addr' => 'derived', 'adminVcon' => 'any', 'identPoolName' => '', 'maxDataFieldSize' => '2048',
		                                   'name' => "#{service_profile_template_vhba_a}", 'nwTemplName' => "#{service_profile_template_vhba_a_template}", 
		                                   'order' => '1', 'persBind' => 'disabled', 'persBindClear' => 'no', 'pinToGroupName' => '', 'qosPolicyName' => '',
		                                   'rn' => "fc-#{service_profile_template_vhba_a}", 'statsPolicyName' => 'default', 'status' => 'created', 'switchId' => 'A')

		                        xml.vnicFc('adaptorProfileName' => '', 'addr' => 'derived', 'adminVcon' => 'any', 'identPoolName' => '', 'maxDataFieldSize' => '2048',
		                                   'name' => "#{service_profile_template_vhba_b}", 'nwTemplName' => "#{service_profile_template_vhba_b_template}", 
		                                   'order' => '2', 'persBind' => 'disabled', 'persBindClear' => 'no', 'pinToGroupName' => '', 'qosPolicyName' => '',
		                                   'rn' => "fc-#{service_profile_template_vhba_b}", 'statsPolicyName' => 'default', 'status' => 'created', 'switchId' => 'B')

		                        xml.lsPower('rn' => 'power', 'state' => 'up')
		                      }
		       }
		     }
		   }
		 end

		 #Create Template xml
		 set_service_profile_template_xml = xml_builder.to_xml.to_s

		 #Post create Service Profile Template
		 begin
		 	RestClient.post(@url, set_service_profile_template_xml, :content_type => 'text/xml').body
		 rescue Exception => e
		 	raise "Error #{e}"
		 end
		 
    end

   def set_service_profiles_from_template(json)

		 service_profile_template_name              = JSON.parse(json)['service_profile_template_name'].to_s
		 org                						            = JSON.parse(json)['org'].to_s
		 service_profile_template_sp_prefix         = JSON.parse(json)['service_profile_template_sp_prefix'].to_s
		 service_profile_template_num_of_sps        = JSON.parse(json)['service_profile_template_num_of_sps'].to_i

		 xml_builder = Nokogiri::XML::Builder.new do |xml|
		       xml.lsInstantiateNTemplate('dn' => "org-root/org-#{org}/ls-#{service_profile_template_name}",
		                                   'inTargetOrg' => "org-root/org-#{org}", 'inServerNamePrefixOrEmpty' => "#{service_profile_template_sp_prefix}",
		                                   'inNumberOf' => "#{service_profile_template_num_of_sps}", 'inHierarchical' => 'false')


		  end


		 #Create Template xml
		 set_service_profiles_from_template_xml = xml_builder.to_xml.to_s

		 #Post create Service Profiles from Template
		 begin
		 	RestClient.post(@url, set_service_profiles_from_template_xml, :content_type => 'text/xml').body
		 rescue Exception => e
		 	raise "Error #{e}"
		 end
		 
    end



   def set_service_profiles(json)

		service_profile_names              = JSON.parse(json)['service_profile_names'].to_s.split(',')
		service_profile_boot_policy        = JSON.parse(json)['service_profile_boot_policy'].to_s
		service_profile_host_fw_policy     = JSON.parse(json)['service_profile_host_fw_policy'].to_s
		service_profile_mgmt_fw_policy     = JSON.parse(json)['service_profile_mgmt_fw_policy'].to_s
		service_profile_uuid_pool          = JSON.parse(json)['service_profile_uuid_pool'].to_s
		service_profile_vnics_a            = JSON.parse(json)['service_profile_vnics_a'].to_s.split(',')
		service_profile_vnic_a_template    = JSON.parse(json)['service_profile_vnic_a_template'].to_s
		service_profile_vnics_b            = JSON.parse(json)['service_profile_vnics_b'].to_s.split(',')
		service_profile_vnic_b_template    = JSON.parse(json)['service_profile_vnic_b_template'].to_s
		service_profile_wwnn_pool          = JSON.parse(json)['service_profile_wwnn_pool'].to_s
		service_profile_vhba_a             = JSON.parse(json)['service_profile_vhba_a'].to_s
		service_profile_vhba_a_template    = JSON.parse(json)['service_profile_vhba_a_template'].to_s
		service_profile_vhba_b             = JSON.parse(json)['service_profile_vhba_b'].to_s
		service_profile_vhba_b_template    = JSON.parse(json)['service_profile_vhba_b_template'].to_s
		org                				         = JSON.parse(json)['org'].to_s
		service_profile_template_to_bind   = JSON.parse(json)['service_profile_template_to_bind'].to_s



		  xml_builder = Nokogiri::XML::Builder.new do |xml|
		    xml.configConfMos('cookie' => "#{@cookie}", 'inHierarchical' => 'true'){
		      xml.inConfigs{service_profile_names.each do |service_profile_name|
		        xml.pair('key' => "org-root/org-#{org}/ls-#{service_profile_name}"){
		          xml.lsServer('agentPolicyName' => '', 'biosProfileName' => '', 'bootPolicyName' => "#{service_profile_boot_policy}",
		                       'descr' => '', 'dn' => "org-root/org-#{org}/ls-#{service_profile_name}",
		                       'dynamicConPolicyName' => '', 'extIPState' => 'none', 'hostFwPolicyName' => "#{service_profile_host_fw_policy}",
		                       'identPoolName' => "#{service_profile_uuid_pool}", 'localDiskPolicyName' => 'default', 'maintPolicyName' => 'default',
		                       'mgmtAccessPolicyName' => '', 'mgmtFwPolicyName' => "#{service_profile_mgmt_fw_policy}", 'name' => "#{service_profile_name}",
		                       'powerPolicyName' => 'default', 'scrubPolicyName' => '', 'solPolicyName' => 'default', 'srcTemplName' => "#{service_profile_template_to_bind}", 
		                       'statsPolicyName' => 'default', 'status' => 'created', 'usrLbl' => '', 'uuid' => '0', 'vconProfileName' => ''){
		                        service_profile_vnics_a.each do |vnic_a|  
		                         xml.vnicEther('adaptorProfileName' => '', 'addr' => 'derived', 'adminVcon' => 'any', 'identPoolName' => '', 'mtu' => '1500',
		                                       'name' => "#{vnic_a}", 'nwCtrlPolicyName' => '', 'nwTemplName' => "#{service_profile_vnic_a_template}",
		                                       'order' => '3', 'pinToGroupName' => '', 'qosPolicyName' => '', 'rn' => "ether-#{vnic_a}",
		                                       'statsPolicyName' => 'default', 'status' => 'created', 'switchId' => 'A')
		                        end

		                        service_profile_vnics_b.each do |vnic_b|
		                         xml.vnicEther('adaptorProfileName' => '', 'addr' => 'derived', 'adminVcon' => 'any', 'identPoolName' => '', 'mtu' => '1500',
		                                       'name' => "#{vnic_b}", 'nwCtrlPolicyName' => '', 'nwTemplName' => "#{service_profile_vnic_b_template}",
		                                       'order' => '4', 'pinToGroupName' => '', 'qosPolicyName' => '', 'rn' => "ether-#{vnic_b}",
		                                       'statsPolicyName' => 'default', 'status' => 'created', 'switchId' => 'B')
		                        end

		                         xml.vnicFcNode('addr' => 'pool-derived', 'identPoolName' => "#{service_profile_wwnn_pool}", 'rn' => 'fc-node')

		                         xml.vnicFc('adaptorProfileName' => '', 'addr' => 'derived', 'adminVcon' => 'any', 'identPoolName' => '', 'maxDataFieldSize' => '2048',
		                                    'name' => "#{service_profile_vhba_a}", 'nwTemplName' => "#{service_profile_vhba_a}", 
		                                    'order' => '1', 'persBind' => 'disabled', 'persBindClear' => 'no', 'pinToGroupName' => '', 'qosPolicyName' => '',
		                                    'rn' => "fc-#{service_profile_vhba_a}", 'statsPolicyName' => 'default', 'status' => 'created', 'switchId' => 'A')

		                         xml.vnicFc('adaptorProfileName' => '', 'addr' => 'derived', 'adminVcon' => 'any', 'identPoolName' => '', 'maxDataFieldSize' => '2048',
		                                    'name' => "#{service_profile_vhba_b}", 'nwTemplName' => "#{service_profile_vhba_b}", 
		                                    'order' => '2', 'persBind' => 'disabled', 'persBindClear' => 'no', 'pinToGroupName' => '', 'qosPolicyName' => '',
		                                    'rn' => "fc-#{service_profile_vhba_b}", 'statsPolicyName' => 'default', 'status' => 'created', 'switchId' => 'B')

		                         xml.lsPower('rn' => 'power', 'state' => 'up')
		                       }
		        }
		      end}
		    }

		end


		#Create Template xml
		set_service_profiles_xml = xml_builder.to_xml.to_s

		#Post create Service Profiles
		begin
			RestClient.post(@url, set_service_profiles_xml, :content_type => 'text/xml').body
		rescue Exception => e
			raise "Error #{e}"
		end

  end

  def set_server_pool(json)
      server_pool_name           = JSON.parse(json)['server_pool_name'].to_s
      server_pool_description    = JSON.parse(json)['server_pool_description']
      server_pool_chassis_id     = JSON.parse(json)['server_pool_chassis_id'].to_i
      server_pool_blades         = JSON.parse(json)['server_pool_blades'].to_s.split(',')
      org                        = JSON.parse(json)['org'].to_s

      xml_builder = Nokogiri::XML::Builder.new do |xml|
        xml.configConfMos('cookie' => "#{@ucs_cookie}", 'inHierarchical' => 'true'){
          xml.inConfigs{
            xml.pair('key' => "org-root/org-#{org}/compute-pool-#{server_pool_name}"){
              xml.computePool('descr' => "#{server_pool_description}", 'dn' => "org-root/org-#{org}/compute-pool-#{server_pool_name}",
                              'name' => "#{server_pool_name}", 'status' => 'created'){
                                server_pool_blades.each do |slot_id|
                                  xml.computePooledSlot('chassisId' => "#{server_pool_chassis_id}", 
                                                        'rn' => "blade-#{server_pool_chassis_id}-#{slot_id}", 'slotId' => "#{slot_id}")
                                end
                              }
            }
          }
        }
      end



      # xml_builder = Nokogiri::XML::Builder.new do |xml|
      #   xml.configConfMos('cookie' => "#{@ucs_cookie}", 'inHierarchical' => 'true'){
      #     xml.inConfigs{
      #       xml.pair('key' => "org-root/org-#{server_pool_org}/compute-pool-#{server_pool_name}"){
      #         xml.computePool('descr' => '', 'dn' => "org-root/org-#{server_pool_org}/compute-pool-#{server_pool_name}",
      #                         'status' => 'created,modified'){
      #                           server_pool_blades.each do |slot_id|
      #                             xml.computePooledSlot('chassisId' => "#{server_pool_chassis_id}", 
      #                                                   'rn' => "blade-#{server_pool_chassis_id}-#{slot_id}", 'slotId' => "#{slot_id}",
      #                                                   'status' => 'created')
      #                           end
      #                         }
      #       }
      #     }
      #   }
      # end


      #Create XML

      set_server_pool_xml = xml_builder.to_xml.to_s

      #Post 
      begin
        RestClient.post(@url, set_server_pool_xml, :content_type => 'text/xml').body
      rescue Exception => e
        raise "Error #{e}"
      end

  end

end