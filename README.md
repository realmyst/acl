Round of pair programming. We tried writing acl based on [YaAcl](https://github.com/mokevnin/ya_acl)

example syntax:

```ruby
acl = Acl.build do
  roles do
    role :admin
    role :another_user
    role :editor
    role :operator
  end

  asserts do
    assert :first, [:var] do
      var
    end

    assert :another, [:first] do
      statuses = [1, 2]
      statuses.include? first
    end

    assert :another2, [:first] do
      !!first
    end

    assert :another3, [:first] do
      statuses = [1, 2]
      statuses.include? first
    end

    assert :another4, [:first, :second] do
      first == second
    end
  end

  resources :admin do
    resource :name, [:editor, :operator] do
      privilege :create, :admin do
        assert :first, [:admin, :another_user]
      end
      privilege :update do
        assert :another, [:editor]
        assert :another2, [:editor, :operator]
        assert :another3, [:operator]
        assert :another4, [:operator]
      end
    end
  end
end

acl.allow?(:name, :update, [:another_user])
acl.allow?(:name, :update, [:editor], :first => true, :second => false)
acl.allow?(:name, :update, [:editor], :first => false, :second => true)
acl.allow?(:name, :update, [:editor], :first => 1, :second => true)
acl.check!(:name, :create, [:admin], :var => 2)
acl.allow?(:name, :update, [:editor], :first => 3, :second => false)
acl.allow?(:name, :update, [:operator], :first => true, :second => true)
acl.allow?(:name, :update, [:operator], :first => 1, :second => 1)
acl.allow?(:name, :update, [:operator], :first => 3, :second => 3)
```

* acl#allow? will be return true/false
* acl#check will be return instance of object Acl::Result
* acl#check! will be raised if false
