module Acl
  class Builder

    attr_reader :acl

    def initialize(&block)
      @roles = {}
      @acl = Acl.new
      instance_eval &block
      if @resources
        @resources.each do |resource|
          resource.add_asserts(@asserts)
          @acl.add_resource(resource)
        end
      end
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

    def resources(role, &block)
      @resources = ResourceBuilder.build(@acl, &block)
    end

    def asserts(&block)
      @asserts = AssertsBuilder.build(&block)
    end

  end

  class AssertsBuilder
    attr_reader :asserts

    def initialize(&block)
      @asserts = {}
      instance_eval(&block)
    end

    def self.build(&block)
      builder = new(&block)
      builder.asserts
    end

    def assert(name, params = [], &block)
      assert = Assert.new(name, params, &block)
      @asserts[assert.name] = assert
    end
  end

  class ResourceBuilder
    attr_reader :resources

    def initialize(acl, &block)
      @acl = acl
      @resources = []
      instance_eval(&block)
    end

    def self.build(acl, &block)
      builder = new(acl, &block)
      builder.resources
    end

    def resource(name, roles = nil, &block)
      Array(roles).map {|role| raise UnknownRole unless @acl.role_list.member?(role)}

      resource = Resource.new(name)
      privileges = PrivilegeBuilder.build(roles, @acl, &block)
      resource.add_privileges(privileges)
      @resources << resource
    end
  end

  class PrivilegeBuilder
    attr_reader :privileges

    def initialize(roles, acl, &block)
      @acl = acl
      @global_roles = Array(roles)
      @privileges = {}
      instance_eval(&block)
    end

    def self.build(roles, acl, &block)
      builder = new(roles, acl, &block)
      return builder.privileges
    end

    def privilege(name, roles = nil, &block)
      Array(roles).map {|role| raise UnknownRole unless @acl.role_list.member?(role)}

      roles = Array(roles) | @global_roles
      privilege = Privilege.new(name, roles, &block)
      @privileges[privilege.name] = privilege
    end

    def assert

    end
  end
end
