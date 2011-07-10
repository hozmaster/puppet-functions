#
# uniq.rb
#
# Copyright 2011 Puppet Labs Inc.
# Copyright 2011 Krzysztof Wilczynski
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Puppet::Parser::Functions
  newfunction(:uniq, :type => :rvalue, :doc => <<-EOS
Returns either new array or string by removing duplicates values for it.

Prototype:

    uniq(x)

Where x is either an array type or string value.

For example:

  Given the following statements:

    $a = "abbc"
    $b = ["d", "e", "e", "f", "f"]

    notice uniq($a)
    notice uniq($b)

  The result will be as follows:

    notice: Scope(Class[main]): abc
    notice: Scope(Class[main]): d e f
    EOS
  ) do |arguments|

    #
    # We put arguments that are strings back into the array.  This is
    # to ensure that whenever we call this function from within the
    # Puppet manifest or alternatively form a template it will always
    # do the right thing ...
    #
    arguments.to_a if arguments.is_a?(String)

    raise Puppet::ParseError, "uniq(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)" if arguments.size < 1

    value = arguments.shift

    unless [Array, String].include?(value.class)
      raise Puppet::ParseError, 'uniq(): Requires either array ' +
        'or string type to work with'
    end

    if value.is_a?(String)
      # We turn any string value into an array to be remove duplicates ...
      value = value.split('').uniq.join
    else
      value = value.uniq
    end

    value
  end
end

# vim: set ts=2 sw=2 et :