#
# prefix.rb
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
  newfunction(:prefix, :type => :rvalue, :doc => <<-EOS
Returns a new string which is the concatenation of each element of the array
into a string using prefix given.

Prototype:

    prefix(a)
    prefix(a, s)

Where a is an array and s is the prefix to concatenate array elements with.

For example:

  Given the following statements:

    $a = ['a', 'b', 'c', 1, 2, 3]
    $b = 'element-'

    notice prefix($a)
    notice prefix($a, $b)

  The result will be as follows:

    notice: Scope(Class[main]): a b c 1 2 3
    notice: Scope(Class[main]): element-a element-b element-c element-1 element-2 element-3
    EOS
  ) do |*arguments|
    #
    # This is to ensure that whenever we call this function from within
    # the Puppet manifest or alternatively form a template it will always
    # do the right thing ...
    #
    arguments = arguments.shift if arguments.first.is_a?(Array)

    # Technically we support two arguments but only first is mandatory ...
    raise Puppet::ParseError, "prefix(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)" if arguments.size < 1

    array = arguments.shift

    raise Puppet::ParseError, 'prefix(): Requires an array type ' +
      'to work with' unless array.is_a?(Array)

    prefix = arguments.shift unless arguments.empty?

    if prefix and not prefix.is_a?(String)
      raise Puppet::ParseError, 'prefix(): Requires prefix to be of a string type'
    end

    # We concatenate with prefix or do nothing ...
    prefix ? array.collect { |i| prefix + i.to_s } : array
  end
end

# vim: set ts=2 sw=2 et :