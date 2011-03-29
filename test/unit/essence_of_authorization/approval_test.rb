require File.expand_path('../../../test_helper', __FILE__)


class EssenceOfAuthorization::ApprovalTest < ActiveSupport::TestCase


  test "initialization" do
    a = EssenceOfAuthorization::Approval.new(User, :access, Resource) do
      true
    end


    assert_equal User, a.subject_class
    assert_equal :access, a.verb
    assert_equal Resource, a.direct_object_class
    assert_not_nil a.block
  end

  test 'approve?' do
    a = EssenceOfAuthorization::Approval.new(User, :access, Resource) do
      false
    end

    assert !a.approve?(User.new, :access, Resource.new)
    assert a.approve?(Resource.new, :access, Resource.new)
    assert a.approve?(User.new, :other, Resource.new)
    assert a.approve?(User.new, :access, User.new)
  end


  test 'matches?' do
    a = EssenceOfAuthorization::Approval.new(User, :access, Resource) do
      false
    end

    assert a.matches?(User.new, :access, Resource.new)
    assert !a.matches?(Resource.new, :access, Resource.new)
    assert !a.matches?(User.new, :calling, Resource.new)
    assert !a.matches?(User.new, :access, User.new)
  end




end