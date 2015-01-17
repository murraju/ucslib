##  ucslib (beta)

Ruby Client Library for Cisco UCS Manager that could be used for Infrastructure Automation.

To see an example of how ucslib is being used, checkout the ucs and ucs-solo Chef Cookbooks created by Velankani Information Systems, Inc here - https://github.com/velankanisys/chef-cookbooks

In addition there is a knife plugin that use ucslib as well - https://github.com/velankanisys/knife-ucs

** Version 0.1.9 has been released **

0.1.9

Updates to allow SSL to be ignored if desired, still defaults to verify_ssl =True
Abstracted out the Rest post call to allow for easier global changes down the road

0.1.8

Namespace updates (clean up) and support for ruby 2.1.0

0.1.7
Multi-chassis server pool creation

0.1.6:
Set syslog server implemented in provisioner

0.1.5:
Moved update boot policy to Update instead of manage
Disabled Parser code for now to allow ucslib to work on Debian Squeeze running Ruby1.9.1

0.1.4:
Bug fixes.

0.1.3:
Host firmware XML change for UCS 2.1.

0.1.2:
Bug fixes.

0.1.1:

1. Provision has set_ vs create_ methods. Please update your apps.
2. Added Manage functions to associate service profiles to server pools

## Install

gem install ucslib

## Usage (example pry session)

  [1] pry(main)> require 'ucslib'
  => true
  [2] pry(main)> authjson = { :username => 'admin', :password => 'admin', :ip => '172.16.192.175', :verify_ssl => "false"}.to_json
  => "{\"username\":\"admin\",\"password\":\"admin\",\"ip\":\"172.16.192.175\",\"verify_ssl_\":\"false\"}"
  [3] pry(main)> ucs = UCS.new(authjson)
  Your credentials are username: admin password: admin ip: 172.16.192.175 url https://172.16.192.175/nuova
  => #<UCS:0x007fd269d1eb18>
  [4] pry(main)> token = ucs.get_token(authjson)
  => "{\"cookie\":\"1398284131/87cdd12e-7cb4-4e0d-b39d-e39a827e3870\",\"username\":\"admin\",\"password\":\"admin\",\"ip\":\"172.16.192.175\"}"
  [5] pry(main)> inventory = ucs.discover(token)

  Hit q to quit

  => #(Document:0x3fd4a6f99e70 {
    name = "document",
    children = [
      #(Element:0x3fd4a6f9954c {
        name = "configResolveClasses",
        attributes = [
          #(Attr:0x3fd4a6f99254 {
            name = "cookie",
            value = "1398284407/c298b159-0cee-434a-ae55-c116b8cd19fe"
            }),
          #(Attr:0x3fd4a6f99240 { name = "response", value = "yes" })],
        children = [
          #(Text " "),
          #(Element:0x3fd4a6fa1b20 {
            name = "outConfigs",
            children = [
              #(Text "  "),
              #(Element:0x3fd4a6fa10d0 {
                name = "topSystem",
                attributes = [
                  #(Attr:0x3fd4a6fa0e3c {
                    name = "address",
                    value = "172.16.192.175"
                    }),
                  #(Attr:0x3fd4a6fa0e28 {
                    name = "currentTime",
                    value = "2014-04-23T20:29:13.906"
                    }),
                  #(Attr:0x3fd4a6fa0e14 { name = "descr", value = "" }),
                  #(Attr:0x3fd4a6fa0e00 { name = "dn", value = "sys" }),
                  #(Attr:0x3fd4a6fa0dec { name = "ipv6Addr", value = "::" }),
                  #(Attr:0x3fd4a6fa0dd8 { name = "mode", value = "cluster" }),
                  #(Attr:0x3fd4a6fa0dc4 {
                    name = "name",
                    value = "UCSPE-172-16-192-175"
                    }),
                  #(Attr:0x3fd4a6fa0db0 { name = "owner", value = "" }),
                  #(Attr:0x3fd4a6fa0d9c { name = "site", value = "" }),
                  #(Attr:0x3fd4a6fa0d88 {
                    name = "systemUpTime",
                    value = "00:06:18:58"
    [6] pry(main)>ucs.list_blades(inventory)
    Blade : 1/1 model: N20-B6620-1 with serial: 3324 is powered: on
    Blade : 1/2 model: N20-B6620-1 with serial: 3325 is powered: on
    Blade : 1/5 model: UCSB-B200-M3 with serial: 3327 is powered: on
    Blade : 1/6 model: N20-B6625-1 with serial: 3328 is powered: on
    Blade : 1/3 model: N20-B6620-2 with serial: 3326 is powered: on
    Blade : 1/7 model: N20-B6740-2 with serial: 3329 is powered: on
    => 0
    [7] pry(main)>vlan200 = { :vlan_id => '200', :vlan_name => 'OpenStack-Mgmt' }.to_json
    => "{\"vlan_id\":\"200\",\"vlan_name\":\"OpenStack-Mgmt\"}"
    [8] pry(main)> ucs.set_vlan(vlan200)
    => " <configConfMos cookie=\"1398291606/fe13664b-b79d-4ac7-9d0f-98cedffd1c5e\" response=\"yes\"> <outConfigs> <pair key=\"fabric/lan/net-OpenStack-Mgmt\"> <fabricVlan childAction=\"deleteNonPresent\" cloud=\"ethlan\" compressionType=\"included\" configIssues=\"\" defaultNet=\"no\" dn=\"fabric/lan/net-OpenStack-Mgmt\" epDn=\"\" fltAggr=\"0\" global=\"0\" id=\"200\" ifRole=\"network\" ifType=\"virtual\" local=\"0\" locale=\"external\" mcastPolicyName=\"\" name=\"OpenStack-Mgmt\" operMcastPolicyName=\"\" operState=\"ok\" peerDn=\"\" policyOwner=\"local\" pubNwDn=\"\" pubNwId=\"1\" pubNwName=\"\" sharing=\"none\" status=\"created\" switchId=\"dual\" transport=\"ether\" type=\"lan\"/> </pair> </outConfigs> </configConfMos>"
    [9] pry(main)> ucs.delete_vlan(vlan200)
    => " <configConfMos cookie=\"1398291606/fe13664b-b79d-4ac7-9d0f-98cedffd1c5e\" response=\"yes\"> <outConfigs> <pair key=\"fabric/lan/net-OpenStack-Mgmt\"> <fabricVlan cloud=\"ethlan\" compressionType=\"included\" configIssues=\"\" defaultNet=\"no\" dn=\"fabric/lan/net-OpenStack-Mgmt\" epDn=\"\" fltAggr=\"0\" global=\"0\" id=\"200\" ifRole=\"network\" ifType=\"virtual\" local=\"0\" locale=\"external\" mcastPolicyName=\"\" name=\"OpenStack-Mgmt\" operMcastPolicyName=\"org-root/mc-policy-default\" operState=\"ok\" peerDn=\"\" policyOwner=\"local\" pubNwDn=\"\" pubNwId=\"1\" pubNwName=\"\" sharing=\"none\" status=\"deleted\" switchId=\"dual\" transport=\"ether\" type=\"lan\"/> </pair> </outConfigs> </configConfMos>"
    [10] pry(main)>



Just do "require ucslib" in your apps. Below is an IRB session to highlight some capabilities.


## Features

1. List inventory of UCS components
2. Provision - turn up ports, create port channels, pools, service profiles
3. Retrieve stats

## Issues and Project Management

Checkout [Pivotal Tracker][1]


## ToDo

Documentation, Documentation, Documentation!



## Contributing to ucslib

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 - 2014 Murali Raju. See LICENSE.txt for further details.

[1]: https://www.pivotaltracker.com/s/projects/1065870

