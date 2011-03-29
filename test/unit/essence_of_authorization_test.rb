require 'test_helper'


EssenceOfAuthorization.approve_grants User, :access, Resource do |subject, verb, direct_object|
  puts "considering #{subject.email} in #{direct_object.name}"
  subject.email == 'admin@example.com' && direct_object.name == 'Office'
end

class EssenceOfAuthorizationTest < ActiveSupport::TestCase

  setup do
    @user   = User.create!(:email=>'test@example.com')
    @admin  = User.create!(:email=>'admin@example.com')
    @home   = Resource.create!(:name=>'Home')
    @office = Resource.create!(:name=>'Office')
  end

  test "approve_grants" do

    @admin.grant!(:access, @office)
    assert_raises do
      @user.grant!(:access, @office)
    end
    assert_raises do
      @user.grant!(:access, @home)
    end

    assert !@user.can?(:access, @office)
    assert !@user.can?(:access, @home)
    assert @admin.can?(:access, @office)
    assert !@admin.can?(:access, @home)
  end
end
