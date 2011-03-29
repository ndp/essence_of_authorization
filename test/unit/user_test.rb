require 'test_helper'
require 'benchmark'

class UserTest < ActiveSupport::TestCase
  setup do
    @user   = User.create!(:email=>'test@example.com')
    @admin  = User.create!(:email=>'admin@example.com')
    @home   = Resource.create!(:name=>'Home')
    @office = Resource.create!(:name=>'Office')
  end

  test "initial states" do
    assert !@user.can?(:access, @home)
    assert !@user.can?(:burn_down, @home)
    assert !@user.can?(:access, @office)
  end

  test "allow" do
    @user.grant!(:access, @home)
    assert @user.can?(:access, @home)
  end


  test "allow different permissions" do
    assert !@user.can?(:access, @home)
    assert !@user.can?(:burn_down, @home)

    @user.grant!(:access, @home)
    assert @user.can?(:access, @home)
    assert !@user.can?(:burn_down, @home)

    @user.grant!(:burn_down, @home)
    assert @user.can?(:access, @home)
    assert @user.can?(:burn_down, @home)
  end

  test "allow twice" do
    @user.grant!(:access, @home)

    assert @user.can?(:access, @home)
    assert !@user.can?(:access, @office)

    @user.grant!(:access, @home)

    assert @user.can?(:access, @home)
    assert !@user.can?(:access, @office)
  end

  test "allow different direct object" do
    @user.grant!(:access, @home)

    assert @user.can?(:access, @home)
    assert !@user.can?(:access, @office)

    @user.grant!(:access, @office)

    assert @user.can?(:access, @home)
    assert @user.can?(:access, @office)
  end

  test "deny on allowed resource" do
    @user.grant!(:access, @home)
    assert @user.can?(:access, @home)

    @user.revoke!(:access, @home)
    assert !@user.can?(:access, @home)
  end

  test "revoke! on resource already denied" do
    @user.revoke!(:access, @office)
    assert !@user.can?(:access, @office)
  end

  test "scales?" do
    n       = 100
    records = 100
    records.times { |i| @user.grant!(i, @home) }
    t1 = Benchmark.measure { n.times { @user.can?(1, @home) } }.real
    records.times { |i| @user.grant!(i+records, @home) }
    t2 = Benchmark.measure { n.times { @user.can?(500, @home) } }.real
    records.times { |i| @user.grant!(i+2*records, @home) }
    t3 = Benchmark.measure { n.times { @user.can?(500, @home) } }.real
    records.times { |i| @user.grant!(i+3*records, @home) }
    t4 = Benchmark.measure { n.times { @user.can?(500, @home) } }.real
    assert t2 < 2*t1, "increasing number of permissions appears linear"
    assert t3 < 2*t1, "increasing number of permissions appears linear"
    assert t4 < 2*t1, "increasing number of permissions appears linear"
  end



end
