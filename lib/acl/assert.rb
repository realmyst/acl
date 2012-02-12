module Acl
  class Assert

    attr_reader :name

    def initialize(name, params, &block)
      @name = name
      @params = params
      self.class.send(:attr_accessor, *params)

      @block = block
    end

    def call_assert(params = {})
      @params.each do |name|
        raise "Option #{name} must be specified for assert #{self.name}" unless params.has_key?(name)
        self.send("#{name}=", params[name])
      end
      instance_eval(&@block)
    end
  end
end
