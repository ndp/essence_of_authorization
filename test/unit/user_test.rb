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
    @user.allow!(:access, @home)
    assert @user.can?(:access, @home)
  end


  test "allow different permissions" do
    assert !@user.can?(:access, @home)
    assert !@user.can?(:burn_down, @home)

    @user.allow!(:access, @home)
    assert @user.can?(:access, @home)
    assert !@user.can?(:burn_down, @home)

    @user.allow!(:burn_down, @home)
    assert @user.can?(:access, @home)
    assert @user.can?(:burn_down, @home)
  end

  test "allow twice" do
    @user.allow!(:access, @home)

    assert @user.can?(:access, @home)
    assert !@user.can?(:access, @office)

    @user.allow!(:access, @home)

    assert @user.can?(:access, @home)
    assert !@user.can?(:access, @office)
  end

  test "allow different direct object" do
    @user.allow!(:access, @home)

    assert @user.can?(:access, @home)
    assert !@user.can?(:access, @office)

    @user.allow!(:access, @office)

    assert @user.can?(:access, @home)
    assert @user.can?(:access, @office)
  end

  test "deny on allowed resource" do
    @user.allow!(:access, @home)
    assert @user.can?(:access, @home)

    @user.deny!(:access, @home)
    assert !@user.can?(:access, @home)
  end

  test "deny! on resource already denied" do
    @user.deny!(:access, @office)
    assert !@user.can?(:access, @office)
  end

  test "scales?" do
    n       = 100
    records = 100
    records.times { |i| @user.allow!(i, @home) }
    t1 = Benchmark.measure { n.times { @user.can?(1, @home) } }.real
    records.times { |i| @user.allow!(i+records, @home) }
    t2 = Benchmark.measure { n.times { @user.can?(500, @home) } }.real
    records.times { |i| @user.allow!(i+2*records, @home) }
    t3 = Benchmark.measure { n.times { @user.can?(500, @home) } }.real
    records.times { |i| @user.allow!(i+3*records, @home) }
    t4 = Benchmark.measure { n.times { @user.can?(500, @home) } }.real
    assert t2 < 2*t1, "increasing number of permissions appears linear"
    assert t3 < 2*t1, "increasing number of permissions appears linear"
    assert t4 < 2*t1, "increasing number of permissions appears linear"
  end


  test "EssenceOfAuthorization.restrict" do

    EssenceOfAuthorization.restrict_subject User, :access, Proc.new { |subject, direct_object| direct_object != @office }
    begin
      assert_raises do
        @user.allow!(:access, @office)
      end
      @user.allow!(:access, @home)

      assert !@user.can?(:access, @office)
      assert @user.can?(:access, @home)

    ensure
      EssenceOfAuthorization.restrict_subject User, :access, nil
    end

  end

  test "before_allow" do

    EssenceOfAuthorization.restrict_subject User, :access, Proc.new { |subject, direct_object| subject == @admin && direct_object == @office }
    begin
      assert_raises do
        @user.allow!(:access, @office)
      end
      assert_raises do
        @user.allow!(:access, @home)
      end
      @admin.allow!(:access, @office)

      assert !@user.can?(:access, @office)
      assert !@user.can?(:access, @home)
      assert @admin.can?(:access, @office)
      assert !@admin.can?(:access, @home)
    ensure
      EssenceOfAuthorization.restrict_subject User, :access, nil
    end
  end

end
