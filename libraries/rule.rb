#
# Cookbook:: iptables
# Library:: rule
#
# Copyright:: 2019, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Iptables
  module RuleHelpers
    def comment_builder(name:, comment:)
      int_comment = if comment.is_a?(String)
                      " -m comment --comment \"#{comment}\""
                    elsif comment.is_a?(TrueClass)
                      " -m comment --comment \"#{name}\""
                    else
                      ''
                    end
      int_comment
    end

    def rule_builder(line: nil, chain: nil, match: nil, target: nil, extra_options: nil)
      rule = ''
      raise ArgumentError if line.nil? && chain.nil? && match.nil? && target.nil? && extra_options.nil?

      if match.nil? && target.nil?
        rule.concat(line)
        return rule
      end

      rule.concat("-A #{chain.partition(' ').first} ")
      rule.concat("#{match} ") unless match.nil?
      rule.concat("-j #{target} ") unless target.nil?
      rule.concat(extra_options) unless extra_options.nil?
      rule.strip
    end

    def comment_exists?(rule)
      raise ArgumentError unless rule.is_a?(String)
      rule.match?(/-m comment --comment/)
    end
  end
end
