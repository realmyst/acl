module Acl
  class Privilege

    attr_reader :name, :roles, :asserts

    def initialize(name, roles, &block)
      @name = name.to_sym
      @roles = Array(roles)
      @asserts = {}
      instance_eval(&block) if block_given?
    end

    def assert(name, roles = nil, options = {})
      roles = @roles unless roles
      Array(roles).each do |role|
        role = role.to_sym
        @asserts[role] ||= []
        @asserts[role] << {:name => name, :options => options}
      end
    end

    def has_assert?(role)
      role = role.to_sym
      @asserts[role] && @asserts[role].any?
    end

  end
end
