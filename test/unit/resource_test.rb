require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  setup do
    @user   = User.create!(:email=>'test@example.com')
    @admin  = User.create!(:email=>'admin@example.com')
    @home   = Resource.create!(:name=>'Home')
    @office = Resource.create!(:name=>'Office')
  end

  test "returns who can do something" do
    assert_equal [], @home.who_can?(:live)
    @user.allow!(:live_at, @home)
    assert_equal [@user], @home.who_can?(:live_at)
    @user.deny!(:live_at, @home)
    assert_equal [], @home.who_can?(:live)
  end


end
