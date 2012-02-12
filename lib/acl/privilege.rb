module Acl
  class Privilege

    attr_reader :name, :roles

    def initialize(name, roles, &block)
      @name = name.to_sym
      @roles = Array(roles)
      instance_eval(&block)
    end

    def assert(name, roles, options = {})

    end

  end
end
