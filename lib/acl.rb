require "acl/version"

module Acl
  autoload :Acl, 'acl/acl'
  autoload :Builder, 'acl/builder'
  autoload :Resource, 'acl/resource'
  autoload :Privilege, 'acl/privilege'
  autoload :Result, 'acl/result'
  autoload :Assert, 'acl/assert'

  def self.build(&block)
    return ::Acl::Builder.build(&block)
  end

end
