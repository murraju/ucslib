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

require 'nokogiri'

class UCSParser
  class Nokogiri::XML::Node
    TYPENAMES = {1=>'element',2=>'attribute',3=>'text',4=>'cdata',8=>'comment'}
    def to_hash
      {kind:TYPENAMES[node_type],name:name}.tap do |h|
        h.merge! nshref:namespace.href, nsprefix:namespace.prefix if namespace
        h.merge! text:text
        h.merge! attr:attribute_nodes.map(&:to_hash) if element?
        h.merge! kids:children.map(&:to_hash) if element?
      end
    end
  end
  class Nokogiri::XML::Document
    def to_hash; root.to_hash; end
  end
  
end