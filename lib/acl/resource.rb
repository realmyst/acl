module Acl
  class Resource

    attr_reader :privileges, :name, :asserts

    def initialize(name)
      @privileges = {}
      @name = name.to_sym
      @asserts = nil
    end

    def add_asserts(asserts)
      @asserts = asserts
    end

    def add_privilege(privilege)
      @privileges[privilege.name] = privilege
    end

    def add_privileges(privileges)
      @privileges.merge!(privileges)
    end

    def allow?(privilege, roles, options = nil)
      unless current = @privileges[privilege]
        return Result.new(false, "privilege #{privilege} not found")
      end

      roles = Array(roles)
      roles_for_check = roles & current.roles

      roles_for_check.each do |role|
        assert_result = check_asserts(current.asserts[role], role, options)
        return Result.new(true) if current.roles.member?(role) && !assert_result.error?
      end

      return Result.new(false, "Access denied #{roles.inspect} for #{privilege}")
    end

    def check_asserts(asserts, role, options)
      if asserts && asserts.any?
        asserts.each do |assert|
          raise "Assert #{assert[:name]} not specified" unless @asserts[assert[:name]]
          options ||= assert[:options]
          unless @asserts[assert[:name]].call_assert(options)
            return Result.new(false, "Access denied #{role} for assert #{assert[:name]}")
          end
        end
      end
      return Result.new(true)
    end
  end
end
