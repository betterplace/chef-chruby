# Copyright 2013, Atalanta Systems Ltd
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
include_recipe "ruby_build"

node['chruby']['rubies'].each do |ruby, flag|
  if flag
    ruby_build_ruby ruby do
      prefix_path "/opt/rubies/#{ruby}"
    end
    if gems = node['chruby']['gems'] and gems = gems[ruby]
      for gem in  gems
        name, version = gem.values_at('name', 'version')
        script "Installing gem #{name} #{version}" do
          not_if "/opt/rubies/#{ruby}/bin/gem list | grep -q \"^#{name} \""
          interpreter "bash"
          code "/opt/rubies/#{ruby}/bin/gem install #{name.inspect} -v #{version.inspect}"
        end
      end
    end
  elsif flag == false
    directory "/opt/rubies/#{ruby}" do
      recursive true
      action :delete
    end
  end
end

include_recipe "chruby"
