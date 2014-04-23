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

require 'ucslib/service/ucs/session'
require 'ucslib/service/ucs/provision'
require 'ucslib/service/ucs/parser'
require 'ucslib/service/ucs/update'
require 'ucslib/service/ucs/inventory'
require 'ucslib/service/ucs/destroy'
require 'ucslib/service/ucs/manage'
require 'ucslib/service/ucs/stats'


class UCS
  include Session
  include Update
  include Stats
  include Provision
  include Parser
  include Manage
  include Inventory
  include Destroy

  def initialize (authjson)
    username = "#{JSON.parse(authjson)['username']}"
    password = "#{JSON.parse(authjson)['password']}"
    ip       = "#{JSON.parse(authjson)['ip']}"
    url      = "https://#{ip}/nuova"
    puts "Your credentials are username: #{username} password: #{password} ip: #{ip} url #{url}"
  end

end