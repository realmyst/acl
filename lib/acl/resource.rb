module Acl
  class Resource

    attr_reader :privileges, :name

    def initialize(name)
      @privileges = {}
      @name = name.to_sym
    end

    def add_privilege(privilege)
      @privileges[privilege.name] = privilege
    end

    def add_privileges(privileges)
      @privileges.merge!(privileges)
    end

    def allow?(privilege, roles)
      if current = @privileges[privilege]
        Array(roles).each do |role|
          return ::Acl::Result.new(true) if current.roles.member?(role)
        end
      end
      return ::Acl::Result.new(false, "privilege #{privilege} not found")
    end
  end
end
