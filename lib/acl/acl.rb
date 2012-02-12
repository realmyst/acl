module Acl
  class Acl
    def initialize
      @roles = []
      @resources = {}
    end

    def add_role(name)
      @roles << name
    end

    def role_list
      @roles
    end

    def role(role)
      true
    end

    def add_resource(resource)
      @resources[resource.name] = resource
    end

    def allow?(*args)
      result = check(*args)
      return !result.error?
    end

    def check(resource, privilege, roles, options = nil)
      raise ResourceNotFound unless @resources[resource]
      @resources[resource].allow?(privilege, roles, options)
    end

    def check!(*args)
      result = check(*args)
      raise AccessDenied, result.message if result.error?
      return true
    end

  end

  class ResourceNotFound < RuntimeError
  end
  class PrivilegeNotFound < RuntimeError
  end
  class RoleNotFound < RuntimeError
  end
  class AccessDenied < RuntimeError
  end
  class UnknownRole < ArgumentError
  end
end
