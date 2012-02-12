#encoding: utf-8
ACL = Acl.build do
  roles do
    role :admin
    role :user
    role :moderator
    role :editor
  end

  asserts do
    assert :owner, [:user_id, :another_user_id] do
      user_id == another_user_id
    end
  end

  resources do
    resource 'post', [:user] do
      privilege :edit, :moderator
      privilege :update
      privilege :index, [:editor] do
        assert :owner, [:editor], :user_id => 1, :another_user_id => 1
      end
    end

    resource 'article', [:user] do
      privilege :edit, :moderator
      privilege :update
      #privilege :index, [:editor] do
        #assert :owner, [:editor], :user_id => 1, :another_user_id => 1
      #end
    end
  end
end
