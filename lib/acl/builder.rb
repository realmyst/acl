module Acl
  class Builder

    attr_reader :acl

    def initialize(&block)
      @roles = {}
      @acl = Acl.new
      instance_eval &block
    end

    def self.build(&block)
      builder = new(&block)
      return builder.acl
    end

    private

    def roles(&block)
      instance_eval &block
    end

    def role(name)
      @acl.add_role(name)
    end

    def resources(&block)
      instance_eval(&block)
    end

    def resource(name, roles = nil, &block)
      @resource = Resource.new(name)
      privileges = PrivilegeBuilder.build(roles, &block)
      @resource.add_privileges(privileges)
      @acl.add_resource(@resource)
    end

    def asserts(&block)
      instance_eval(&block)
    end

  end

  class PrivilegeBuilder
    attr_reader :privileges

    def initialize(roles, &block)
      @global_roles = Array(roles)
      @privileges = {}
      instance_eval(&block)
    end

    def self.build(roles, &block)
      builder = new(roles, &block)
      return builder.privileges
    end

    def privilege(name, roles = nil, &block)
      roles = Array(roles) | @global_roles
      privilege = Privilege.new(name, roles)
      @privileges[privilege.name] = privilege
    end


  end
end
