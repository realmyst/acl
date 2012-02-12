require 'test_helper'

class TestAcl < MiniTest::Unit::TestCase
  def test_example
    assert_equal [:user, :moderator, :editor, :admin].sort, ACL.role_list.sort
    assert ACL.allow?(:post, :edit, :user)
    assert ACL.allow?(:post, :edit, :moderator)
    assert !ACL.allow?(:post, :edit, :editor)

    assert ACL.allow?(:article, :edit, :user)
    assert ACL.allow?(:article, :edit, :moderator)
    assert !ACL.allow?(:article, :edit, :editor)

    assert_raises Acl::AccessDenied do
      ACL.check!(:article, :edit, :editor)
    end

    assert_raises Acl::ResourceNotFound do
      ACL.allow?(:not_found, :edit, :moderator)
    end
    assert true
  end
end
