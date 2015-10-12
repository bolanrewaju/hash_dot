require "hash_dot/version"
require 'symbol'
require 'json'

module HashDot
  class << self
    attr_accessor :universal_dot_syntax

    universal_dot_syntax ||= false
  end
end

class Hash
  def method_missing(method, *args)
    return super(method, *args) unless HashDot.universal_dot_syntax

    prop = create_prop(method)

    if self[prop].nil?
      self[prop] = self.delete(prop.to_s)
    end

    super(method, args) and return if self[prop].nil?

    if setter?(method)
      self[prop] = args.first
    else
      self[prop]
    end
  end

  private

  def setter?(method)
    method.last == "="
  end

  def create_prop(method)
    setter?(method) ? method.chop : method
  end
end
